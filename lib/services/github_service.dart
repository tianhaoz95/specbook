import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myapp/models/github_repo.dart';
import 'package:myapp/services/settings_service.dart'; // Assuming SettingsService handles saving updated GitHubRepo

class GitHubService {
  final SettingsService _settingsService;

  GitHubService(this._settingsService);

  Future<List<String>> fetchRepositoryFiles(GitHubRepo repo) async {
    final List<String> files = [];
    final repoPath = repo.url.startsWith('https://github.com/')
        ? repo.url.substring('https://github.com/'.length)
        : repo.url;
    final url = Uri.parse(
      'https://api.github.com/repos/$repoPath/git/trees/HEAD?recursive=1',
    );
    final headers = {
      'Authorization': 'token ${repo.pat}',
      'Accept': 'application/vnd.github.v3+json',
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        for (var item in data['tree']) {
          if (item['type'] == 'blob') {
            // 'blob' type indicates a file
            files.add(item['path']);
          }
        }
        // Update the cachedFiles in the repo and save it
        final updatedRepo = GitHubRepo(
          url: repo.url,
          pat: repo.pat,
          cachedFiles: files,
        );
        await _updateCachedFilesInSettings(updatedRepo);
        return files;
      } else {
        throw Exception(
          'Failed to load repository files: ${response.statusCode} ${response.body}',
        );
      }
    } on http.ClientException catch (e) {
      throw Exception(
        'Network error fetching repository files: Please check your internet connection. ($e)',
      );
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<void> _updateCachedFilesInSettings(GitHubRepo updatedRepo) async {
    List<GitHubRepo> currentRepos = await _settingsService.loadGitHubRepos();
    // Find and replace the updated repo
    final index = currentRepos.indexWhere((r) => r.url == updatedRepo.url);
    if (index != -1) {
      currentRepos[index] = updatedRepo;
    } else {
      currentRepos.add(
        updatedRepo,
      ); // Should not happen if coming from existing repo
    }
    await _settingsService.saveGitHubRepos(currentRepos);
  }
}
