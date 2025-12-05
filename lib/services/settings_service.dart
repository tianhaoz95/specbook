import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/models/command.dart';

class SettingsService {
  static const String _commandsKey = 'commands';

  Future<List<Command>> loadCommands() async {
    final prefs = await SharedPreferences.getInstance();
    final commandsJson = prefs.getStringList(_commandsKey);
    if (commandsJson == null) {
      return [];
    }
    return commandsJson
        .map((jsonString) => Command.fromJson(jsonString))
        .toList();
  }

  Future<void> saveCommands(List<Command> commands) async {
    final prefs = await SharedPreferences.getInstance();
    final commandsJson = commands.map((command) => command.toJson()).toList();
    await prefs.setStringList(_commandsKey, commandsJson);
  }
}
