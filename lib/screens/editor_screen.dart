import 'package:flutter/material.dart';
import 'package:myapp/screens/settings_screen.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/command.dart';
import 'package:myapp/services/settings_service.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  final TextEditingController _controller = TextEditingController();
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  List<Command> _suggestions = [];
  List<Command> _allCommands = [];
  bool _showAutocomplete = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
    _loadAllCommands();
  }

  Future<void> _loadAllCommands() async {
    _allCommands = await Provider.of<SettingsService>(
      context,
      listen: false,
    ).loadCommands();
  }

  void _onTextChanged() {
    final text = _controller.text;
    final cursorPos = _controller.selection.baseOffset;

    if (cursorPos > 0 && text[cursorPos - 1] == '/') {
      _showAutocomplete = true;
      _suggestions = _allCommands;
      _showOverlay();
    } else if (_showAutocomplete &&
        cursorPos > 0 &&
        text[cursorPos - 1].trim().isNotEmpty) {
      final lastSlashIndex = text.lastIndexOf('/', cursorPos - 1);
      if (lastSlashIndex != -1) {
        final searchTerm = text
            .substring(lastSlashIndex + 1, cursorPos)
            .toLowerCase();
        _suggestions = _allCommands
            .where(
              (command) => command.title.toLowerCase().contains(searchTerm),
            )
            .toList();
        _showOverlay(); // Update overlay with filtered suggestions
      } else {
        _hideOverlay();
      }
    } else {
      _hideOverlay();
    }
  }

  void _showOverlay() {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      _overlayEntry!.markNeedsBuild();
    }
    setState(() {
      _showAutocomplete = true;
    });
  }

  void _hideOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null; // Set to null immediately after removing
      if (mounted) {
        setState(() {
          _showAutocomplete = false;
        });
      }
    }
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => Positioned(
        width: MediaQuery.of(context).size.width * 0.8,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0.0, 50.0), // Adjust as needed
          child: Material(
            elevation: 4.0,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: _suggestions.length,
              itemBuilder: (context, index) {
                final command = _suggestions[index];
                return ListTile(
                  title: Text(command.title),
                  subtitle: Text(command.description),
                  onTap: () {
                    _insertCommand(command);
                    _hideOverlay();
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _insertCommand(Command command) {
    final text = _controller.text;
    final cursorPos = _controller.selection.baseOffset;
    final lastSlashIndex = text.lastIndexOf('/', cursorPos - 1);

    if (lastSlashIndex != -1) {
      final newText =
          text.substring(0, lastSlashIndex + 1) +
          command.title.substring(1) + // Insert without the leading slash
          text.substring(cursorPos);
      _controller.value = _controller.value.copyWith(
        text: newText,
        selection: TextSelection.collapsed(
          offset: lastSlashIndex + command.title.length,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _hideOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spec Editor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
              _loadAllCommands(); // Reload commands after returning from settings
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CompositedTransformTarget(
          link: _layerLink,
          child: TextField(
            controller: _controller,
            expands: true,
            maxLines: null,
            decoration: const InputDecoration(
              hintText: 'Write your spec here...',
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
