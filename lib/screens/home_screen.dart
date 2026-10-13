import 'package:flutter/material.dart';
import '../models/practice_level.dart';
import '../models/typing_result.dart';
import '../services/adaptive_engine.dart';
import '../services/storage_service.dart';
import '../utils/app_theme.dart';
import '../widgets/accuracy_chart.dart';
import '../widgets/progress_card.dart';
import 'history_screen.dart';
import 'practice_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _storage = StorageService();
  final _engine = AdaptiveEngine();
  List<TypingResult> _history = [];
  PracticeLevel _level = PracticeLevel.beginner;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final history = await _storage.loadHistory();
    final level = await _storage.loadLevel();
    if (!mounted) return;
    setState(() {
      _history = history;
      _level = level;
      _loading = false;
    });
  }

  Future<void> _startPractice() async {
    final weak = _engine.aggregateWeakKeys(_history);
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PracticeScreen(level: _level, weakKeys: weak),
      ),
    );
    await _load();
  }

  void _openThemePicker() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Background theme',
                  style: Theme.of(ctx).textTheme.titleLarge),
              const SizedBox(height: 20),
              ValueListenableBuilder<BackgroundTheme>(
                valueListenable: AppTheme.current,
                builder: (_, selected, __) => Wrap(
                  spacing: 18,
                  runSpacing: 18,
                  alignment: WrapAlignment.center,
                  children: [
                    for (final t in AppTheme.themes)
                      GestureDetector(
                        onTap: () => AppTheme.select(t),
                        child: Column(
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                gradient: t.gradient,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: t == selected
                                      ? Theme.of(ctx).colorScheme.primary
                                      : Colors.transparent,
                                  width: 3,
                                ),
                              ),
                              child: t == selected
                                  ? const Icon(Icons.check, color: Colors.white)
                                  : null,
                            ),
                            const SizedBox(height: 6),
                            Text(t.name,
                                style: Theme.of(ctx).textTheme.bodySmall),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final avgWpm = _history.isEmpty
        ? 0.0
        : _history.map((r) => r.wpm).reduce((a, b) => a + b) / _history.length;
    final avgAcc = _history.isEmpty
        ? 0.0
        : _history.map((r) => r.accuracy).reduce((a, b) => a + b) /
            _history.length;
    final weak = _engine.aggregateWeakKeys(_history);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Adaptive AI Typing Tutor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.palette_outlined),
            tooltip: 'Themes',
            onPressed: _openThemePicker,
          ),
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'History',
            onPressed: () async {
              await Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const HistoryScreen()));
              await _load();
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.school),
                    title: const Text('Current level'),
                    subtitle: Text(_level.label),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ProgressCard(
                        title: 'Avg WPM',
                        value: avgWpm.toStringAsFixed(1),
                        icon: Icons.speed,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ProgressCard(
                        title: 'Avg Accuracy',
                        value: '${avgAcc.toStringAsFixed(1)}%',
                        icon: Icons.check_circle_outline,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Accuracy trend',
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 12),
                        AccuracyChart(results: _history),
                      ],
                    ),
                  ),
                ),
                if (weak.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.psychology),
                      title: const Text('AI focus keys'),
                      subtitle: Text(weak.map((k) => k.toUpperCase()).join('  ')),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _startPractice,
                  icon: const Icon(Icons.keyboard),
                  label: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Text('Start Practice', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
    );
  }
}
