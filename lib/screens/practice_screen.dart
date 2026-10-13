import 'dart:async';
import 'package:flutter/material.dart';
import '../models/practice_level.dart';
import '../services/adaptive_engine.dart';
import '../services/storage_service.dart';
import '../services/typing_analyzer.dart';
import '../widgets/typing_text_field.dart';
import 'result_screen.dart';

class PracticeScreen extends StatefulWidget {
  final PracticeLevel level;
  final List<String> weakKeys;

  const PracticeScreen({
    super.key,
    required this.level,
    this.weakKeys = const [],
  });

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  final _engine = AdaptiveEngine();
  final _storage = StorageService();
  final _controller = TextEditingController();
  late String _target;
  String _typed = '';
  int _seconds = 0;
  Timer? _timer;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    _target = _engine.generateText(widget.level, weakKeys: widget.weakKeys);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    if (_finished) return;
    _timer ??= Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _seconds++);
    });
    if (value.length >= _target.length) {
      value = value.substring(0, _target.length);
      _controller.text = value;
      _controller.selection = TextSelection.collapsed(offset: value.length);
      setState(() => _typed = value);
      _finish();
      return;
    }
    setState(() => _typed = value);
  }

  Future<void> _finish() async {
    _finished = true;
    _timer?.cancel();
    final seconds = _seconds == 0 ? 1 : _seconds;
    final result = TypingAnalyzer.analyze(
      target: _target,
      typed: _typed,
      seconds: seconds,
      level: widget.level,
    );
    await _storage.saveResult(result);
    final history = await _storage.loadHistory();
    final next = _engine.nextLevel(widget.level, history);
    await _storage.saveLevel(next);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(result: result, nextLevel: next),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final liveWpm = TypingAnalyzer.calculateWpm(_typed.length, _seconds);
    return Scaffold(
      appBar: AppBar(title: Text('${widget.level.label} Practice')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _stat('Time', '${_seconds}s'),
                _stat('WPM', liveWpm.toStringAsFixed(0)),
                _stat('Accuracy',
                    '${TypingAnalyzer.calculateAccuracy(_target, _typed).toStringAsFixed(0)}%'),
              ],
            ),
            const SizedBox(height: 16),
            TypingTextField(
              target: _target,
              typed: _typed,
              controller: _controller,
              onChanged: _onChanged,
              enabled: !_finished,
            ),
          ],
        ),
      ),
    );
  }

  Widget _stat(String label, String value) => Column(
        children: [
          Text(value,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold)),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      );
}
