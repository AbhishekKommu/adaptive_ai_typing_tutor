import 'package:flutter/material.dart';
import '../models/typing_result.dart';

/// Simple dependency-free line chart showing accuracy (%) per session.
class AccuracyChart extends StatelessWidget {
  final List<TypingResult> results;
  final double height;

  const AccuracyChart({super.key, required this.results, this.height = 180});

  @override
  Widget build(BuildContext context) {
    if (results.length < 2) {
      return SizedBox(
        height: height,
        child: const Center(child: Text('Complete 2+ sessions to see your trend')),
      );
    }
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _ChartPainter(
          values: results.map((r) => r.accuracy).toList(),
          lineColor: scheme.primary,
          gridColor: scheme.outlineVariant,
        ),
      ),
    );
  }
}

class _ChartPainter extends CustomPainter {
  final List<double> values;
  final Color lineColor;
  final Color gridColor;

  _ChartPainter({
    required this.values,
    required this.lineColor,
    required this.gridColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = gridColor
      ..strokeWidth = 1;
    for (int i = 0; i <= 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    const minV = 0.0, maxV = 100.0;
    final line = Paint()
      ..color = lineColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final dot = Paint()..color = lineColor;

    final path = Path();
    for (int i = 0; i < values.length; i++) {
      final x = size.width * i / (values.length - 1);
      final y = size.height * (1 - (values[i] - minV) / (maxV - minV));
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, line);
    for (int i = 0; i < values.length; i++) {
      final x = size.width * i / (values.length - 1);
      final y = size.height * (1 - (values[i] - minV) / (maxV - minV));
      canvas.drawCircle(Offset(x, y), 4, dot);
    }
  }

  @override
  bool shouldRepaint(covariant _ChartPainter old) =>
      old.values != values || old.lineColor != lineColor;
}
