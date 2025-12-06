import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/command.dart';
import 'package:myapp/services/settings_service.dart';

class ManageCommandsScreen extends StatefulWidget {
  const ManageCommandsScreen({super.key});

  @override
  State<ManageCommandsScreen> createState() => _ManageCommandsScreenState();
}

class _ManageCommandsScreenState extends State<ManageCommandsScreen> {
  late Future<List<Command>> _commandsFuture;

  @override
  void initState() {
    super.initState();
    _loadCommands();
  }

  void _loadCommands() {
    _commandsFuture = Provider.of<SettingsService>(
      context,
      listen: false,
    ).loadCommands();
  }

  Future<void> _showCommandDialog({Command? command, int? index}) async {
    final titleController = TextEditingController(text: command?.title);
    final descriptionController = TextEditingController(
      text: command?.description,
    );

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(command == null ? 'Add Command' : 'Edit Command'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Command Title (e.g., /bug)',
                ),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () async {
                if (!mounted) return; // Add this check
                final newCommand = Command(
                  title: titleController.text,
                  description: descriptionController.text,
                );

                final settingsService = Provider.of<SettingsService>(
                  context,
                  listen: false,
                );
                List<Command> currentCommands = await settingsService
                    .loadCommands();

                if (command == null) {
                  currentCommands.add(newCommand);
                } else if (index != null) {
                  currentCommands[index] = newCommand;
                }

                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
                await settingsService.saveCommands(currentCommands);
                if (!mounted) return; // Add this check before _loadCommands()
                setState(() {
                  _loadCommands();
                });
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteCommand(int index) async {
    final settingsService = Provider.of<SettingsService>(
      context,
      listen: false,
    );
    List<Command> currentCommands = await settingsService.loadCommands();
    currentCommands.removeAt(index);
    await settingsService.saveCommands(currentCommands);
    setState(() {
      _loadCommands();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Commands')),
      body: FutureBuilder<List<Command>>(
        future: _commandsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No commands added yet.'));
          } else {
            final commands = snapshot.data!;
            return ListView.builder(
              itemCount: commands.length,
              itemBuilder: (context, index) {
                final command = commands[index];
                return Dismissible(
                  key: Key(
                    'command_${command.title}_$index',
                  ), // Unique key for Dismissible
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    _deleteCommand(index);
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${command.title} dismissed')),
                    );
                  },
                  child: ListTile(
                    title: Text(command.title),
                    subtitle: Text(command.description),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () =>
                          _showCommandDialog(command: command, index: index),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCommandDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
