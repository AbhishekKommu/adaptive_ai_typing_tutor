import '../models/practice_level.dart';
import '../models/typing_result.dart';

class TypingAnalyzer {
  /// Gross WPM using the standard 5 characters = 1 word convention.
  static double calculateWpm(int typedChars, int seconds) {
    if (seconds <= 0) return 0;
    return (typedChars / 5) / (seconds / 60);
  }

  /// Accuracy percentage comparing typed text against the target.
  static double calculateAccuracy(String target, String typed) {
    if (typed.isEmpty) return 100;
    int correct = 0;
    for (int i = 0; i < typed.length; i++) {
      if (i < target.length && typed[i] == target[i]) correct++;
    }
    return correct / typed.length * 100;
  }

  static int countErrors(String target, String typed) {
    int errors = 0;
    for (int i = 0; i < typed.length; i++) {
      if (i >= target.length || typed[i] != target[i]) errors++;
    }
    return errors;
  }

  /// Returns the characters (from the target) the user mistyped, most frequent first.
  static List<String> findWeakKeys(String target, String typed, {int limit = 5}) {
    final counts = <String, int>{};
    for (int i = 0; i < typed.length && i < target.length; i++) {
      if (typed[i] != target[i] && target[i].trim().isNotEmpty) {
        final k = target[i].toLowerCase();
        counts[k] = (counts[k] ?? 0) + 1;
      }
    }
    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(limit).map((e) => e.key).toList();
  }

  static TypingResult analyze({
    required String target,
    required String typed,
    required int seconds,
    required PracticeLevel level,
  }) {
    return TypingResult(
      date: DateTime.now(),
      wpm: calculateWpm(typed.length, seconds),
      accuracy: calculateAccuracy(target, typed),
      errors: countErrors(target, typed),
      durationSeconds: seconds,
      level: level,
      weakKeys: findWeakKeys(target, typed),
    );
  }
}
