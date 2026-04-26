import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlayerProvider with ChangeNotifier {
  int _level = 1;
  int _xp = 0;
  int _hp = 100;
  int _nextLevelXp = 100;

  int get level => _level;
  int get xp => _xp;
  int get hp => _hp;
  int get nextLevelXp => _nextLevelXp;

  PlayerProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _level = prefs.getInt('level') ?? 1;
    _xp = prefs.getInt('xp') ?? 0;
    _hp = prefs.getInt('hp') ?? 100;
    _calculateNextLevelXp();
    notifyListeners();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('level', _level);
    await prefs.setInt('xp', _xp);
    await prefs.setInt('hp', _hp);
  }

  void _calculateNextLevelXp() {
    // Formula: 100 * level^1.5
    _nextLevelXp = (100 * math.pow(_level, 1.5)).toInt();
  }

  void gainXp(int amount) {
    _xp += amount;
    
    // Level Up Logic
    while (_xp >= _nextLevelXp) {
      _xp -= _nextLevelXp;
      _level++;
      _calculateNextLevelXp();
      // Healed slightly on level up
      _hp = math.min(100, _hp + 20);
    }
    
    _saveData();
    notifyListeners();
  }

  void updateHp(int delta) {
    _hp = (_hp + delta).clamp(0, 100);
    _saveData();
    notifyListeners();
  }

  void reset() {
    _level = 1;
    _xp = 0;
    _hp = 100;
    _calculateNextLevelXp();
    _saveData();
    notifyListeners();
  }
}
