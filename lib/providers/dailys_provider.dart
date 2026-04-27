import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:aevum_os/providers/player_provider.dart';
import 'package:provider/provider.dart';

class Habit {
  final String id;
  final String title;
  bool isCompleted;

  Habit({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'isCompleted': isCompleted,
  };

  factory Habit.fromJson(Map<String, dynamic> json) => Habit(
    id: json['id'],
    title: json['title'],
    isCompleted: json['isCompleted'],
  );
}

class DailysProvider with ChangeNotifier {
  List<Habit> _habits = [];

  List<Habit> get habits => _habits;
  bool get isLocked => _habits.isNotEmpty;

  DailysProvider() {
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final String? habitsJson = prefs.getString('habits');
    if (habitsJson != null) {
      final List<dynamic> decoded = jsonDecode(habitsJson);
      _habits = decoded.map((h) => Habit.fromJson(h)).toList();
    } else {
      _habits = [];
    }
    notifyListeners();
  }

  Future<void> _saveHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final String habitsJson = jsonEncode(_habits.map((h) => h.toJson()).toList());
    await prefs.setString('habits', habitsJson);
  }

  void defineRoutine(List<String> titles) {
    if (_habits.isNotEmpty) return;
    _habits = titles
        .where((t) => t.trim().isNotEmpty)
        .map((t) => Habit(id: DateTime.now().millisecondsSinceEpoch.toString() + t, title: t.toUpperCase()))
        .toList();
    _saveHabits();
    notifyListeners();
  }

  void redefineRoutine(List<String> titles) {
    _habits = titles
        .where((t) => t.trim().isNotEmpty)
        .take(5)
        .map((t) => Habit(id: DateTime.now().millisecondsSinceEpoch.toString() + t, title: t.toUpperCase()))
        .toList();
    _saveHabits();
    notifyListeners();
  }

  void toggleHabit(String id, BuildContext context) {
    final index = _habits.indexWhere((h) => h.id == id);
    if (index != -1) {
      final wasCompleted = _habits[index].isCompleted;
      _habits[index].isCompleted = !wasCompleted;
      
      if (!wasCompleted) {
        // Gain XP
        context.read<PlayerProvider>().addXp(10, 'Constancia');
        
        // Check for streak
        if (_habits.every((h) => h.isCompleted)) {
          final player = context.read<PlayerProvider>();
          player.updateStreak(player.streak + 1);
        }
      }

      _saveHabits();
      notifyListeners();
    }
  }

  void removeHabit(String id) {
    _habits.removeWhere((h) => h.id == id);
    _saveHabits();
    notifyListeners();
  }
}
