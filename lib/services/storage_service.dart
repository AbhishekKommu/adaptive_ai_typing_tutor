import 'package:shared_preferences/shared_preferences.dart';
import '../models/practice_level.dart';
import '../models/typing_result.dart';

class StorageService {
  static const _historyKey = 'typing_history';
  static const _levelKey = 'current_level';
  static const _themeKey = 'background_theme';

  Future<List<TypingResult>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_historyKey) ?? [];
    return raw.map(TypingResult.fromJson).toList();
  }

  Future<void> saveResult(TypingResult result) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_historyKey) ?? [];
    raw.add(result.toJson());
    await prefs.setStringList(_historyKey, raw);
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
    await prefs.remove(_levelKey);
  }

  Future<PracticeLevel> loadLevel() async {
    final prefs = await SharedPreferences.getInstance();
    final idx = prefs.getInt(_levelKey) ?? 0;
    return PracticeLevel.values[idx.clamp(0, PracticeLevel.values.length - 1)];
  }

  Future<void> saveLevel(PracticeLevel level) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_levelKey, level.index);
  }

  Future<int> loadThemeIndex() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_themeKey) ?? 0;
  }

  Future<void> saveThemeIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, index);
  }
}
