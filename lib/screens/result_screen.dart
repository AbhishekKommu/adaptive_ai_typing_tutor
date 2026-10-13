import 'package:flutter/material.dart';
import '../models/practice_level.dart';
import '../models/typing_result.dart';
import '../widgets/progress_card.dart';

class ResultScreen extends StatelessWidget {
  final TypingResult result;
  final PracticeLevel nextLevel;

  const ResultScreen({super.key, required this.result, required this.nextLevel});

  String get _feedback {
    if (nextLevel.index > result.level.index) {
      return 'Great work! You are moving up to ${nextLevel.label}.';
    }
    if (nextLevel.index < result.level.index) {
      return 'Let us slow down and build accuracy at ${nextLevel.label}.';
    }
    return 'Solid session. Keep practicing at ${nextLevel.label}.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: ProgressCard(
                  title: 'WPM',
                  value: result.wpm.toStringAsFixed(1),
                  icon: Icons.speed,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ProgressCard(
                  title: 'Accuracy',
                  value: '${result.accuracy.toStringAsFixed(1)}%',
                  icon: Icons.check_circle_outline,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ProgressCard(
                  title: 'Errors',
                  value: '${result.errors}',
                  icon: Icons.error_outline,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ProgressCard(
                  title: 'Time',
                  value: '${result.durationSeconds}s',
                  icon: Icons.timer_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.psychology),
              title: const Text('AI feedback'),
              subtitle: Text(_feedback),
            ),
          ),
          if (result.weakKeys.isNotEmpty)
            Card(
              child: ListTile(
                leading: const Icon(Icons.keyboard_alt_outlined),
                title: const Text('Keys to improve'),
                subtitle: Text(
                    result.weakKeys.map((k) => k.toUpperCase()).join('  ')),
              ),
            ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: Text('Back to Home'),
            ),
          ),
        ],
      ),
    );
  }
}
