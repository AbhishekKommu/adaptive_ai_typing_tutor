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
      'my mom made a hot cup of tea for me',
      'the sun is up and the birds sing a song',
      'i can run fast and jump high in the park',
      'we ate rice and beans for lunch today',
      'the little fish swam around in the pond',
      'she has a red hat and a blue bag',
      'let us go to the shop and buy some milk',
    ],
    PracticeLevel.intermediate: [
      'Practice makes progress, so keep your fingers on the home row.',
      'A steady rhythm matters more than raw speed when you are learning.',
      'Typing without looking at the keyboard builds real muscle memory.',
      'Take a deep breath, relax your shoulders, and let your fingers glide.',
      'Every expert was once a beginner who refused to give up.',
      'Good posture and a calm mind help you type faster with fewer mistakes.',
      'Small daily practice sessions are better than one long session a week.',
      'Learning to type well saves hours of time over the years.',
      'Focus on accuracy first, and speed will follow naturally.',
      'The best way to improve is to review your mistakes and try again.',
    ],
    PracticeLevel.advanced: [
      'Consistency, patience, and deliberate practice transform clumsy keystrokes into fluent, effortless typing.',
      'Programmers often type symbols like {}, [], and (); accuracy there saves a lot of debugging time.',
      'The quick brown fox jumps over the lazy dog, proving every letter can appear in one sentence.',
      'Great typists do not stare at their hands; they trust their training and keep their eyes on the screen.',
      'Whether you are writing an email, a report, or a program, fast and accurate typing makes the work flow.',
      'Technology changes quickly, but the ability to express ideas clearly and quickly will always be valuable.',
      'Rhythm, relaxation, and repetition are the three pillars of building lasting typing skill.',
      'When errors creep in, slow down slightly, correct your form, and then gradually build your speed again.',
      'A curious learner explores new words, new phrases, and new challenges every single day.',
      'Pack my box with five dozen liquor jugs, and sphinx of black quartz, judge my vow.',
    ],
    PracticeLevel.expert: [
      'In 2024, 1,250 engineers shipped 3,872 commits; zero-downtime deployments required meticulous, error-free keystrokes!',
      'Refactoring "legacy_code.py" (v2.1.0) took 47 minutes: rename, test, commit, push -- repeat until green.',
      'Quantum-resistant cryptography demands precise syntax: AES-256, SHA-3, and RSA-4096 are not interchangeable.',
      'Error: NullPointerException at line 128 (UserService.java); fix it, re-run tests, and verify the build @ 3:45 PM.',
      'The API returned {"status": 200, "items": [12, 45, 78], "ok": true}; parse it, validate it, and log the result.',
      'Email me at dev.team@example.com by 5:30 PM -- include the report (Q3-2026), the budget (\$24,500), and the timeline.',
      'if (x >= 10 && y <= 20) { total += x * y; } else { total -= (x + y) / 2; } // compute the adjusted score',
      'Synchronization, asynchronous programming, and concurrency are notoriously difficult; practice them deliberately.',
      'Meeting notes: 1) review sprint goals, 2) triage 14 open bugs, 3) plan the v3.0 release for Nov. 15th.',
      'Phenomenal accomplishments require uncompromising discipline, extraordinary persistence, and unwavering concentration.',
    ],
  };

  final Random _random = Random();

  /// Decide the next level based on the most recent results.
  PracticeLevel nextLevel(PracticeLevel current, List<TypingResult> history) {
    if (history.isEmpty) return current;
    final recent =
        history.length > 3 ? history.sublist(history.length - 3) : history;
    final avgAcc =
        recent.map((r) => r.accuracy).reduce((a, b) => a + b) / recent.length;
    final avgWpm =
        recent.map((r) => r.wpm).reduce((a, b) => a + b) / recent.length;

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

  /// Builds a multi-sentence passage; sentences with the user's weak keys come first.
  String generateText(PracticeLevel level, {List<String> weakKeys = const []}) {
    final pool = [..._texts[level]!]..shuffle(_random);
    if (weakKeys.isNotEmpty) {
      pool.sort((a, b) => _score(b, weakKeys).compareTo(_score(a, weakKeys)));
    }
    final count = _sentenceCount(level);
    return pool.take(count).join(' ');
  }

  int _sentenceCount(PracticeLevel level) {
    switch (level) {
      case PracticeLevel.beginner:
        return 1;
      case PracticeLevel.intermediate:
        return 2;
      case PracticeLevel.advanced:
      case PracticeLevel.expert:
        return 3;
    }
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
    final recent =
        history.length > 5 ? history.sublist(history.length - 5) : history;
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