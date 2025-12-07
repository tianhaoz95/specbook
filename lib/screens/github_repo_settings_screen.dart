import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/github_repo.dart';
import 'package:myapp/services/settings_service.dart';
import 'package:myapp/services/github_service.dart';

class GitHubRepoSettingsScreen extends StatefulWidget {
  const GitHubRepoSettingsScreen({super.key});

  @override
  State<GitHubRepoSettingsScreen> createState() =>
      _GitHubRepoSettingsScreenState();
}

class _GitHubRepoSettingsScreenState extends State<GitHubRepoSettingsScreen> {
  late Future<List<GitHubRepo>> _reposFuture;

  @override
  void initState() {
    super.initState();
    _loadGitHubRepos();
  }

  void _loadGitHubRepos() {
    _reposFuture = Provider.of<SettingsService>(
      context,
      listen: false,
    ).loadGitHubRepos();
  }

  Future<void> _showRepoDialog({GitHubRepo? repo, int? index}) async {
    final urlController = TextEditingController(text: repo?.url);
    final patController = TextEditingController(text: repo?.pat);

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            repo == null ? 'Add GitHub Repository' : 'Edit GitHub Repository',
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: urlController,
                decoration: const InputDecoration(
                  labelText: 'Repository URL (e.g., owner/repo)',
                ),
              ),
              TextField(
                controller: patController,
                decoration: const InputDecoration(
                  labelText: 'Personal Access Token (PAT)',
                ),
                obscureText: true,
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
                if (!mounted) return;
                final newRepo = GitHubRepo(
                  url: urlController.text,
                  pat: patController.text,
                  cachedFiles:
                      repo?.cachedFiles ??
                      [], // Preserve cached files if editing
                );

                final settingsService = Provider.of<SettingsService>(
                  context,
                  listen: false,
                );
                List<GitHubRepo> currentRepos = await settingsService
                    .loadGitHubRepos();

                if (repo == null) {
                  currentRepos.add(newRepo);
                  // Set the new repo as active
                  await settingsService.setActiveGitHubRepoUrl(newRepo.url);
                } else if (index != null) {
                  currentRepos[index] = newRepo;
                }

                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
                await settingsService.saveGitHubRepos(currentRepos);
                if (!mounted) return;
                setState(() {
                  _loadGitHubRepos();
                });
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteRepo(int index) async {
    final settingsService = Provider.of<SettingsService>(
      context,
      listen: false,
    );
    List<GitHubRepo> currentRepos = await settingsService.loadGitHubRepos();
    currentRepos.removeAt(index);
    await settingsService.saveGitHubRepos(currentRepos);
    setState(() {
      _loadGitHubRepos();
    });
  }

  Future<void> _refreshRepoFiles(GitHubRepo repo, int index) async {
    final githubService = Provider.of<GitHubService>(context, listen: false);
    try {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fetching files for ${repo.url}...')),
      );
      await githubService.fetchRepositoryFiles(repo);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Files for ${repo.url} refreshed successfully!'),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to refresh files: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _loadGitHubRepos(); // Reload to update cached files count in UI
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GitHub Repositories')),
      body: FutureBuilder<List<GitHubRepo>>(
        future: _reposFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No GitHub repositories added yet.'),
            );
          } else {
            final repos = snapshot.data!;
            return ListView.builder(
              itemCount: repos.length,
              itemBuilder: (context, index) {
                final repo = repos[index];
                return Dismissible(
                  key: Key('repo_${repo.url}_$index'), // Unique key
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    _deleteRepo(index);
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${repo.url} dismissed')),
                    );
                  },
                  child: ListTile(
                    title: Text(repo.url),
                    subtitle: Text('Files cached: ${repo.cachedFiles.length}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: () => _refreshRepoFiles(repo, index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () =>
                              _showRepoDialog(repo: repo, index: index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showRepoDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
