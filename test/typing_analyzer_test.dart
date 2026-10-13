import 'package:flutter_test/flutter_test.dart';
import 'package:adaptive_ai_typing_tutor/models/practice_level.dart';
import 'package:adaptive_ai_typing_tutor/services/typing_analyzer.dart';

void main() {
  group('TypingAnalyzer', () {
    test('calculates WPM with 5 chars per word', () {
      expect(TypingAnalyzer.calculateWpm(50, 60), closeTo(10, 0.001));
    });

    test('accuracy is 100 for perfect typing', () {
      expect(TypingAnalyzer.calculateAccuracy('hello', 'hello'), 100);
    });

    test('accuracy drops with mistakes', () {
      expect(TypingAnalyzer.calculateAccuracy('hello', 'hxllo'), closeTo(80, 0.001));
    });

    test('counts errors', () {
      expect(TypingAnalyzer.countErrors('hello', 'hxlxo'), 2);
    });

    test('finds weak keys', () {
      expect(TypingAnalyzer.findWeakKeys('hello', 'hxllo'), ['e']);
    });

    test('analyze returns a populated result', () {
      final r = TypingAnalyzer.analyze(
        target: 'hello',
        typed: 'hello',
        seconds: 60,
        level: PracticeLevel.beginner,
      );
      expect(r.errors, 0);
      expect(r.accuracy, 100);
    });
  });
}
