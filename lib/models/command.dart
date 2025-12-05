import 'dart:convert';

class Command {
  final String title;
  final String description;

  Command({required this.title, required this.description});

  factory Command.fromJson(String str) => Command.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Command.fromMap(Map<String, dynamic> json) =>
      Command(title: json["title"], description: json["description"]);

  Map<String, dynamic> toMap() => {"title": title, "description": description};
}
