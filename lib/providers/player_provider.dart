import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Achievement {
  final String id;
  final String titulo;
  final String descripcion;
  bool isUnlocked;
  final String condicion; // e.g., 'level_2', 'first_mission'

  Achievement({
    required this.id,
    required this.titulo,
    required this.descripcion,
    this.isUnlocked = false,
    required this.condicion,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'titulo': titulo,
    'descripcion': descripcion,
    'isUnlocked': isUnlocked,
    'condicion': condicion,
  };

  factory Achievement.fromJson(Map<String, dynamic> json) => Achievement(
    id: json['id'],
    titulo: json['titulo'],
    descripcion: json['descripcion'],
    isUnlocked: json['isUnlocked'] ?? false,
    condicion: json['condicion'],
  );
}

class PlayerProvider with ChangeNotifier {
  int _level = 1;
  int _currentXp = 0;
  int _nextLevelXp = 100;
  int _streak = 0;
  int _hp = 100;
  
  Map<String, double> _attributes = {
    'Fuerza': 0,
    'Logica': 0,
    'Sabiduria': 0,
    'Constancia': 0,
    'Enfoque': 0,
    'Vitalidad': 0
  };

  List<Achievement> _achievements = [
    Achievement(id: 'lv2', titulo: 'NIVEL 2 ALCANZADO', descripcion: 'Has superado el umbral inicial.', condicion: 'level_2'),
    Achievement(id: 'm1', titulo: 'PRIMERA MISIÓN', descripcion: 'Completaste tu primer desafío en el Gremio.', condicion: 'first_mission'),
  ];

  // Onboarding/System Data
  bool _isInitialized = false;

  int get level => _level;
  int get currentXp => _currentXp;
  int get nextLevelXp => _nextLevelXp;
  int get streak => _streak;
  int get hp => _hp;
  Map<String, double> get attributes => _attributes;
  List<Achievement> get achievements => _achievements;
  bool get isInitialized => _isInitialized;

  PlayerProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _level = prefs.getInt('level') ?? 1;
    _currentXp = prefs.getInt('xp') ?? 0;
    _streak = prefs.getInt('streak') ?? 0;
    _hp = prefs.getInt('hp') ?? 100;
    _isInitialized = prefs.getBool('isInitialized') ?? false;
    
    // Load attributes
    for (String key in _attributes.keys) {
      _attributes[key] = prefs.getDouble('attr_$key') ?? 0.0;
    }

    // Load achievements
    for (var ach in _achievements) {
      ach.isUnlocked = prefs.getBool('ach_${ach.id}') ?? false;
    }

    _calculateNextLevelXp();
    notifyListeners();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('level', _level);
    await prefs.setInt('xp', _currentXp);
    await prefs.setInt('streak', _streak);
    await prefs.setInt('hp', _hp);
    await prefs.setBool('isInitialized', _isInitialized);
    
    for (var entry in _attributes.entries) {
      await prefs.setDouble('attr_${entry.key}', entry.value);
    }

    for (var ach in _achievements) {
      await prefs.setBool('ach_${ach.id}', ach.isUnlocked);
    }
  }

  void initialize([String? priority, String? difficulty]) {
    _isInitialized = true;
    _saveData();
    notifyListeners();
  }

  void _calculateNextLevelXp() {
    _nextLevelXp = (100 * math.pow(_level, 1.5)).toInt();
  }

  void addXp(int amount, String category) {
    _currentXp += amount;
    
    // Update attribute
    if (_attributes.containsKey(category)) {
      _attributes[category] = (_attributes[category]! + 1.0);
    }

    // Level up logic
    while (_currentXp >= _nextLevelXp) {
      _currentXp -= _nextLevelXp;
      _level++;
      _calculateNextLevelXp();
      _checkAchievements('level_$_level');
    }

    _checkAchievements('first_mission'); // Simplified: any addXp could be a mission

    _saveData();
    notifyListeners();
  }

  void updateStreak(int newStreak) {
    _streak = newStreak;
    _saveData();
    notifyListeners();
  }

  void _checkAchievements(String condition) {
    for (var ach in _achievements) {
      if (ach.condicion == condition && !ach.isUnlocked) {
        ach.isUnlocked = true;
      }
    }
  }

  void reset() {
    _level = 1;
    _currentXp = 0;
    _streak = 0;
    _hp = 100;
    _isInitialized = false;
    _attributes.updateAll((key, value) => 0.0);
    for (var ach in _achievements) {
      ach.isUnlocked = false;
    }
    _calculateNextLevelXp();
    _saveData();
    notifyListeners();
  }
}
