import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';


class JournalEntry {
  String title;
  String content;
  String? folder;


  JournalEntry({required this.title, required this.content, this.folder});


  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
        'folder': folder,
      };


  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      title: json['title'],
      content: json['content'],
      folder: json['folder'],
    );
  }
}


class JournalData {
  List<JournalEntry> entries = [];
  List<String> folders = [];


  static final JournalData _instance = JournalData._internal();


  factory JournalData() => _instance;


  JournalData._internal();


  Future<String> _getFilePath() async {
    final dir = await getApplicationDocumentsDirectory();
    return "${dir.path}/journal_data.json";
  }


  Future<void> saveData() async {
    final path = await _getFilePath();
    final file = File(path);
    final data = {
      'entries': entries.map((e) => e.toJson()).toList(),
      'folders': folders,
    };
    await file.writeAsString(jsonEncode(data));
  }


  Future<void> loadData() async {
    final path = await _getFilePath();
    final file = File(path);
    if (await file.exists()) {
      final content = await file.readAsString();
      final jsonData = jsonDecode(content);
      entries = (jsonData['entries'] as List)
          .map((e) => JournalEntry.fromJson(e))
          .toList();
      folders = List<String>.from(jsonData['folders']);
    }
  }


  void addEntry(JournalEntry entry) {
    entries.add(entry);
    saveData();
  }


  void addFolder(String name) {
    if (!folders.contains(name)) {
      folders.add(name);
      saveData();
    }
  }
}
