import 'dart:math';
import '../models/practice_level.dart';
import '../models/typing_result.dart';

/// Rule-based adaptive engine: picks the next difficulty level and
/// generates practice text that emphasizes the user's weak keys.
class AdaptiveEngine {
  static const Map<PracticeLevel, List<String>> _texts = {
    PracticeLevel.beginner: [
      'the cat sat on the mat and the dog ran by',
      'we like to play in the sun all day long',
      'a big red bus went up the hill and stopped',
    ],
    PracticeLevel.intermediate: [
      'Practice makes progress, so keep your fingers on the home row.',
      'A steady rhythm matters more than raw speed when you are learning.',
      'Typing without looking at the keyboard builds real muscle memory.',
    ],
    PracticeLevel.advanced: [
      'Consistency, patience, and deliberate practice transform clumsy keystrokes into fluent, effortless typing.',
      'Programmers often type symbols like {}, [], and (); accuracy there saves a lot of debugging time.',
      'The quick brown fox jumps over the lazy dog, proving every letter can appear in one sentence.',
    ],
    PracticeLevel.expert: [
      'In 2024, 1,250 engineers shipped 3,872 commits; zero-downtime deployments required meticulous, error-free keystrokes!',
      'Refactoring "legacy_code.py" (v2.1.0) took 47 minutes: rename, test, commit, push -- repeat until green.',
      'Quantum-resistant cryptography demands precise syntax: AES-256, SHA-3, and RSA-4096 are not interchangeable.',
    ],
  };

  final Random _random = Random();

  /// Decide the next level based on the most recent results.
  PracticeLevel nextLevel(PracticeLevel current, List<TypingResult> history) {
    if (history.isEmpty) return current;
    final recent = history.length > 3 ? history.sublist(history.length - 3) : history;
    final avgAcc =
        recent.map((r) => r.accuracy).reduce((a, b) => a + b) / recent.length;
    final avgWpm = recent.map((r) => r.wpm).reduce((a, b) => a + b) / recent.length;

    if (avgAcc >= 95 && avgWpm >= _wpmTarget(current)) return current.next;
    if (avgAcc < 80) return current.previous;
    return current;
  }

  double _wpmTarget(PracticeLevel level) {
    switch (level) {
      case PracticeLevel.beginner:
        return 20;
      case PracticeLevel.intermediate:
        return 35;
      case PracticeLevel.advanced:
        return 50;
      case PracticeLevel.expert:
        return 70;
    }
  }

  /// Returns practice text; if weak keys are known, prefers text containing them.
  String generateText(PracticeLevel level, {List<String> weakKeys = const []}) {
    final pool = _texts[level]!;
    if (weakKeys.isNotEmpty) {
      final scored = [...pool]..sort((a, b) =>
          _score(b, weakKeys).compareTo(_score(a, weakKeys)));
      if (_score(scored.first, weakKeys) > 0) return scored.first;
    }
    return pool[_random.nextInt(pool.length)];
  }

  int _score(String text, List<String> keys) {
    final lower = text.toLowerCase();
    int s = 0;
    for (final k in keys) {
      s += k.allMatches(lower).length;
    }
    return s;
  }

  /// Collects the most common weak keys across recent sessions.
  List<String> aggregateWeakKeys(List<TypingResult> history, {int limit = 5}) {
    final counts = <String, int>{};
    final recent = history.length > 5 ? history.sublist(history.length - 5) : history;
    for (final r in recent) {
      for (final k in r.weakKeys) {
        counts[k] = (counts[k] ?? 0) + 1;
      }
    }
    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(limit).map((e) => e.key).toList();
  }
}
