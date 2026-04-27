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
  bool isDone;

  Mission({
    required this.id,
    required this.title,
    this.description = '',
    required this.category,
    required this.xp,
    required this.rank,
    this.isDone = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'category': category,
    'xp': xp,
    'rank': rank,
    'isDone': isDone,
  };

  factory Mission.fromJson(Map<String, dynamic> json) => Mission(
    id: json['id'],
    title: json['title'],
    description: json['description'] ?? '',
    category: json['category'],
    xp: json['xp'],
    rank: json['rank'],
    isDone: json['isDone'],
  );
}

class MissionProvider with ChangeNotifier {
  List<Mission> _missions = [];

  List<Mission> get missions => _missions;

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
      _missions = [
        Mission(id: '1', title: 'HIDRATACIÓN', description: 'Beber al menos 2 litros de agua al día.', category: 'Diarias', xp: 50, rank: 'E'),
        Mission(id: '2', title: 'LECTURA TÉCNICA', description: 'Leer documentación o artículos de ingeniería.', category: 'Diarias', xp: 120, rank: 'B'),
        Mission(id: '3', title: 'CÓDIGO PURO', description: 'Completar un módulo funcional sin deuda técnica.', category: 'Corto Plazo', xp: 300, rank: 'S'),
      ];
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
