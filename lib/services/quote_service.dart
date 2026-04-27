import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aevum_os/data/aevum_quotes.dart';

class QuoteService {
  static Future<Map<String, String>> getDailyQuote() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().split('T')[0];
    final lastDate = prefs.getString('last_quote_date');
    final lastIndex = prefs.getInt('last_quote_index') ?? -1;

    // If it's still the same day, return the saved quote
    if (lastDate == today && lastIndex != -1 && lastIndex < aevumQuotes.length) {
      return aevumQuotes[lastIndex];
    }

    // New day or first time: pick a random index different from the last one
    final random = Random();
    int newIndex;
    if (aevumQuotes.length > 1) {
      do {
        newIndex = random.nextInt(aevumQuotes.length);
      } while (newIndex == lastIndex);
    } else {
      newIndex = 0;
    }

    await prefs.setString('last_quote_date', today);
    await prefs.setInt('last_quote_index', newIndex);

    return aevumQuotes[newIndex];
  }
}
