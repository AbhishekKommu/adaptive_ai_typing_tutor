import 'dart:convert';
import 'practice_level.dart';

class TypingResult {
  final DateTime date;
  final double wpm;
  final double accuracy;
  final int errors;
  final int durationSeconds;
  final PracticeLevel level;
  final List<String> weakKeys;

  const TypingResult({
    required this.date,
    required this.wpm,
    required this.accuracy,
    required this.errors,
    required this.durationSeconds,
    required this.level,
    this.weakKeys = const [],
  });

  Map<String, dynamic> toMap() => {
        'date': date.toIso8601String(),
        'wpm': wpm,
        'accuracy': accuracy,
        'errors': errors,
        'durationSeconds': durationSeconds,
        'level': level.index,
        'weakKeys': weakKeys,
      };

  factory TypingResult.fromMap(Map<String, dynamic> map) => TypingResult(
        date: DateTime.parse(map['date'] as String),
        wpm: (map['wpm'] as num).toDouble(),
        accuracy: (map['accuracy'] as num).toDouble(),
        errors: map['errors'] as int,
        durationSeconds: map['durationSeconds'] as int,
        level: PracticeLevel.values[map['level'] as int],
        weakKeys: List<String>.from(map['weakKeys'] as List? ?? []),
      );

  String toJson() => json.encode(toMap());

  factory TypingResult.fromJson(String source) =>
      TypingResult.fromMap(json.decode(source) as Map<String, dynamic>);
}
