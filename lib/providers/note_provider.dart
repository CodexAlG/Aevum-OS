import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Note {
  final String id;
  final String title;
  final String content;
  final String date;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'date': date,
  };

  factory Note.fromJson(Map<String, dynamic> json) => Note(
    id: json['id'],
    title: json['title'],
    content: json['content'],
    date: json['date'],
  );
}

class NoteProvider with ChangeNotifier {
  List<Note> _notes = [];

  List<Note> get notes => _notes;

  NoteProvider() {
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? notesJson = prefs.getString('notes');
    if (notesJson != null) {
      final List<dynamic> decoded = jsonDecode(notesJson);
      _notes = decoded.map((n) => Note.fromJson(n)).toList();
    } else {
      _notes = []; // Empty by default
    }
    notifyListeners();
  }

  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final String notesJson = jsonEncode(_notes.map((n) => n.toJson()).toList());
    await prefs.setString('notes', notesJson);
  }

  void addNote(String title, String content) {
    final now = DateTime.now();
    final months = ['ENE', 'FEB', 'MAR', 'ABR', 'MAY', 'JUN', 'JUL', 'AGO', 'SEP', 'OCT', 'NOV', 'DIC'];
    
    _notes.insert(0, Note(
      id: now.millisecondsSinceEpoch.toString(),
      title: title.toUpperCase(),
      content: content,
      date: '${now.day} ${months[now.month - 1]}',
    ));
    _saveNotes();
    notifyListeners();
  }

  void updateNote(String id, String title, String content) {
    final index = _notes.indexWhere((n) => n.id == id);
    if (index != -1) {
      final oldNote = _notes[index];
      _notes[index] = Note(
        id: oldNote.id,
        title: title.toUpperCase(),
        content: content,
        date: oldNote.date,
      );
      _saveNotes();
      notifyListeners();
    }
  }

  void removeNote(String id) {
    _notes.removeWhere((n) => n.id == id);
    _saveNotes();
    notifyListeners();
  }
}
