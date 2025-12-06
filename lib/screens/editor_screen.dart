import 'package:flutter/material.dart';
import 'package:myapp/screens/settings_screen.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/command.dart';
import 'package:myapp/models/github_repo.dart';
import 'package:myapp/services/settings_service.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'package:share_plus/share_plus.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  final TextEditingController _controller = TextEditingController();
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  List<dynamic> _suggestions = []; // Can be Command or String (for filenames)
  List<Command> _allCommands = [];
  List<GitHubRepo> _allGitHubRepos = [];
  bool _showAutocomplete = false;
  String _autocompleteType = ''; // To distinguish between '/' and '@'

  static const String _editorContentKey =
      'editorContent'; // Key for SharedPreferences

  @override
  void initState() {
    super.initState();
    _loadContent(); // Load saved content
    _controller.addListener(_onTextChanged);
    _loadAllAutocompleteData();
  }

  Future<void> _loadContent() async {
    final prefs = await SharedPreferences.getInstance();
    final savedContent = prefs.getString(_editorContentKey);
    if (savedContent != null) {
      _controller.removeListener(_onTextChanged); // Temporarily remove listener
      _controller.text = savedContent;
      _controller.addListener(_onTextChanged); // Re-add listener
    }
  }

  Future<void> _saveContent() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_editorContentKey, _controller.text);
  }

  Future<void> _loadAllAutocompleteData() async {
    final settingsService = Provider.of<SettingsService>(
      context,
      listen: false,
    );
    _allCommands = await settingsService.loadCommands();
    _allGitHubRepos = await settingsService.loadGitHubRepos();
  }

  void _onTextChanged() {
    _saveContent(); // Auto-save content on text change

    final text = _controller.text;
    final cursorPos = _controller.selection.baseOffset;

    if (cursorPos == 0) {
      _hideOverlay();
      return;
    }

    final lastChar = text[cursorPos - 1];

    if (lastChar == '/' || lastChar == '@') {
      _autocompleteType = lastChar;
      _showAutocomplete = true;
      if (_autocompleteType == '/') {
        _suggestions = _allCommands;
      } else if (_autocompleteType == '@') {
        _suggestions = _allGitHubRepos
            .expand((repo) => repo.cachedFiles)
            .toList();
      }
      _showOverlay();
    } else if (_showAutocomplete) {
      final lastTriggerIndex = text.lastIndexOf(
        _autocompleteType,
        cursorPos - 1,
      );
      if (lastTriggerIndex != -1) {
        final searchTerm = text
            .substring(lastTriggerIndex + 1, cursorPos)
            .toLowerCase();
        if (_autocompleteType == '/') {
          _suggestions = _allCommands
              .where(
                (command) => command.title.toLowerCase().contains(searchTerm),
              )
              .toList();
        } else if (_autocompleteType == '@') {
          _suggestions = _allGitHubRepos
              .expand((repo) => repo.cachedFiles)
              .where((filename) => filename.toLowerCase().contains(searchTerm))
              .toList();
        }
        _showOverlay(); // Update overlay with filtered suggestions
      } else {
        _hideOverlay();
      }
    } else {
      _hideOverlay();
    }
  }

  void _showOverlay() {
    debugPrint('Showing overlay...');
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      _overlayEntry!.markNeedsBuild();
    }
    if (mounted) {
      setState(() {
        _showAutocomplete = true;
      });
    }
  }

  void _hideOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
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
            key: const ValueKey(
              'autocomplete_overlay_material',
            ), // Add this key
            elevation: 4.0,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: _suggestions.length,
              itemBuilder: (context, index) {
                final suggestion = _suggestions[index];
                return ListTile(
                  title: Text(
                    suggestion is Command
                        ? suggestion.title
                        : suggestion as String,
                  ),
                  subtitle: suggestion is Command
                      ? Text(suggestion.description)
                      : null,
                  onTap: () {
                    _insertSuggestion(suggestion);
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

  void _insertSuggestion(dynamic suggestion) {
    final text = _controller.text;
    final cursorPos = _controller.selection.baseOffset;
    final lastTriggerIndex = text.lastIndexOf(_autocompleteType, cursorPos - 1);

    if (lastTriggerIndex != -1) {
      String insertText;
      if (suggestion is Command) {
        insertText = suggestion.title;
      } else if (suggestion is String) {
        insertText =
            '$_autocompleteType$suggestion'; // Add the trigger character
      } else {
        return;
      }

      final newText =
          text.substring(0, lastTriggerIndex) +
          insertText +
          text.substring(cursorPos);
      _controller.value = _controller.value.copyWith(
        text: newText,
        selection: TextSelection.collapsed(
          offset: lastTriggerIndex + insertText.length,
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
            icon: const Icon(Icons.share),
            onPressed: () {
              Share.share(_controller.text);
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
              _loadAllAutocompleteData(); // Reload commands and repos after returning from settings
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
