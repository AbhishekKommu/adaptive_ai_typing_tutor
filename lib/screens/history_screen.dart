import 'package:flutter/material.dart';
import '../models/typing_result.dart';
import '../services/storage_service.dart';
import '../widgets/accuracy_chart.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _storage = StorageService();
  List<TypingResult> _history = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final h = await _storage.loadHistory();
    if (mounted) setState(() => _history = h);
  }

  Future<void> _clear() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear history?'),
        content: const Text('This removes all sessions and resets your level.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Clear')),
        ],
      ),
    );
    if (ok == true) {
      await _storage.clearHistory();
      await _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final reversed = _history.reversed.toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _history.isEmpty ? null : _clear,
          ),
        ],
      ),
      body: _history.isEmpty
          ? const Center(child: Text('No sessions yet'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: AccuracyChart(results: _history),
                  ),
                ),
                const SizedBox(height: 8),
                for (final r in reversed)
                  Card(
                    child: ListTile(
                      leading: CircleAvatar(
                          child: Text(r.wpm.toStringAsFixed(0))),
                      title: Text(
                          '${r.wpm.toStringAsFixed(1)} WPM  •  ${r.accuracy.toStringAsFixed(1)}%'),
                      subtitle: Text(
                          '${r.level.label}  •  ${r.date.toLocal().toString().substring(0, 16)}'),
                    ),
                  ),
              ],
            ),
    );
  }
}
