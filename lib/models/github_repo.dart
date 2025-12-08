import 'dart:convert';

class GitHubRepo {
  final String url;
  final String pat;
  final String? name;
  List<String> cachedFiles; // Added for caching file list

  GitHubRepo({
    required this.url,
    required this.pat,
    this.name,
    this.cachedFiles = const [],
  });

  factory GitHubRepo.fromJson(String str) =>
      GitHubRepo.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GitHubRepo.fromMap(Map<String, dynamic> json) => GitHubRepo(
        url: json["url"],
        pat: json["pat"],
        name: json["name"],
        cachedFiles: json["cachedFiles"] == null
            ? []
            : List<String>.from(json["cachedFiles"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "url": url,
        "pat": pat,
        "name": name,
        "cachedFiles": List<dynamic>.from(cachedFiles.map((x) => x)),
      };
}
