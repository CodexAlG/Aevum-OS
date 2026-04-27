import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Mission {
  final String id;
  final String title;
  final String description;
  final String category;
  final int xp;
  final String rank;
  final String attribute;
  bool isDone;

  Mission({
    required this.id,
    required this.title,
    this.description = '',
    required this.category,
    required this.xp,
    required this.rank,
    required this.attribute,
    this.isDone = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'category': category,
    'xp': xp,
    'rank': rank,
    'attribute': attribute,
    'isDone': isDone,
  };

  factory Mission.fromJson(Map<String, dynamic> json) => Mission(
    id: json['id'],
    title: json['title'],
    description: json['description'] ?? '',
    category: json['category'],
    xp: json['xp'],
    rank: json['rank'],
    attribute: json['attribute'] ?? 'Enfoque',
    isDone: json['isDone'],
  );
}

class MissionProvider with ChangeNotifier {
  List<Mission> _missions = [];

  List<Mission> get missions => _missions.where((m) => !m.isDone).toList();
  List<Mission> get completedMissions => _missions.where((m) => m.isDone).toList();

  MissionProvider() {
    _loadMissions();
  }

  Future<void> _loadMissions() async {
    final prefs = await SharedPreferences.getInstance();
    final String? missionsJson = prefs.getString('missions');
    if (missionsJson != null) {
      final List<dynamic> decoded = jsonDecode(missionsJson);
      _missions = decoded.map((m) => Mission.fromJson(m)).toList();
    } else {
      _missions = []; // Start empty as requested
    }
    notifyListeners();
  }

  Future<void> _saveMissions() async {
    final prefs = await SharedPreferences.getInstance();
    final String missionsJson = jsonEncode(_missions.map((m) => m.toJson()).toList());
    await prefs.setString('missions', missionsJson);
  }

  void addMission(Mission mission) {
    _missions.add(mission);
    _saveMissions();
    notifyListeners();
  }

  void deleteMission(String id) {
    _missions.removeWhere((m) => m.id == id);
    _saveMissions();
    notifyListeners();
  }

  void completeMission(String id) {
    final index = _missions.indexWhere((m) => m.id == id);
    if (index != -1) {
      _missions[index].isDone = true;
      _saveMissions();
      notifyListeners();
    }
  }
}
