import 'package:flutter/material.dart';
import 'package:myapp/screens/settings_screen.dart';

class EditorScreen extends StatelessWidget {
  const EditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spec Editor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: TextField(
          expands: true,
          maxLines: null,
          decoration: InputDecoration(
            hintText: 'Write your spec here...',
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
