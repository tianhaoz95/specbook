import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/models/command.dart';
import 'package:myapp/models/github_repo.dart';

class SettingsService {
  static const String _commandsKey = 'commands';
  static const String _githubReposKey = 'githubRepos';
  static const String _activeGitHubRepoUrlKey = 'activeGitHubRepoUrl';

  Future<String?> getActiveGitHubRepoUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_activeGitHubRepoUrlKey);
  }

  Future<void> setActiveGitHubRepoUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_activeGitHubRepoUrlKey, url);
  }

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

  Future<List<GitHubRepo>> loadGitHubRepos() async {
    final prefs = await SharedPreferences.getInstance();
    final reposJson = prefs.getStringList(_githubReposKey);
    if (reposJson == null) {
      return [];
    }
    return reposJson
        .map((jsonString) => GitHubRepo.fromJson(jsonString))
        .toList();
  }

  Future<void> saveGitHubRepos(List<GitHubRepo> repos) async {
    final prefs = await SharedPreferences.getInstance();
    final reposJson = repos.map((repo) => repo.toJson()).toList();
    await prefs.setStringList(_githubReposKey, reposJson);
  }
}
