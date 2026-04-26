import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlayerProvider extends ChangeNotifier {
  int _level = 1;
  int _hp = 100;
  int _maxHp = 100;
  int _xp = 0;
  int _nextLevelXp = 100;

  int get level => _level;
  int get hp => _hp;
  int get maxHp => _maxHp;
  int get xp => _xp;
  int get nextLevelXp => _nextLevelXp;

  PlayerProvider() {
    loadData();
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _level = prefs.getInt('level') ?? 1;
    _hp = prefs.getInt('hp') ?? 100;
    _maxHp = prefs.getInt('maxHp') ?? 100;
    _xp = prefs.getInt('xp') ?? 0;
    _nextLevelXp = prefs.getInt('nextLevelXp') ?? 100;
    notifyListeners();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('level', _level);
    await prefs.setInt('hp', _hp);
    await prefs.setInt('maxHp', _maxHp);
    await prefs.setInt('xp', _xp);
    await prefs.setInt('nextLevelXp', _nextLevelXp);
  }

  int calculateNextLevelXp(int currentLevel) {
    return (100 * pow(currentLevel, 1.5)).floor();
  }

  void gainXp(int amount) {
    _xp += amount;
    
    while (_xp >= _nextLevelXp) {
      _xp -= _nextLevelXp;
      _level++;
      _nextLevelXp = calculateNextLevelXp(_level);
      
      // Heal 20% of maxHp
      int healAmount = (_maxHp * 0.20).floor();
      _hp = min(_maxHp, _hp + healAmount);
    }
    
    _saveData();
    notifyListeners();
  }

  void takeDamage(int amount) {
    _hp = max(0, _hp - amount);
    _saveData();
    notifyListeners();
  }
}
