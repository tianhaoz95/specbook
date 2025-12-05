import 'package:flutter/material.dart';
import 'package:myapp/screens/editor_screen.dart';
import 'package:provider/provider.dart';
import 'package:myapp/services/settings_service.dart';

void main() {
  runApp(
    Provider(create: (context) => SettingsService(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const EditorScreen(),
    );
  }
}
