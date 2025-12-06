import 'package:flutter/material.dart';
import 'package:myapp/screens/github_repo_settings_screen.dart';
import 'package:myapp/screens/manage_commands_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Commands Section
            ListTile(
              title: const Text('Manage Commands'),
              subtitle: const Text(
                'Add, edit, or delete autocomplete commands',
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ManageCommandsScreen(),
                  ),
                );
              },
            ),
            const Divider(),
            // GitHub Repositories Section
            ListTile(
              title: const Text('Manage GitHub Repositories'),
              subtitle: const Text(
                'Add, edit, or delete GitHub repositories for file autocompletion',
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GitHubRepoSettingsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
