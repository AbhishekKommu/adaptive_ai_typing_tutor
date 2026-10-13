import 'package:flutter/material.dart';

/// Shows the target text with per-character coloring and an input field below.
class TypingTextField extends StatelessWidget {
  final String target;
  final String typed;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final bool enabled;

  const TypingTextField({
    super.key,
    required this.target,
    required this.typed,
    required this.controller,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final spans = <TextSpan>[];
    for (int i = 0; i < target.length; i++) {
      Color color;
      Color? bg;
      if (i < typed.length) {
        final ok = typed[i] == target[i];
        color = ok ? Colors.green : Colors.red;
        bg = ok ? null : Colors.red.withValues(alpha: 0.15);
      } else if (i == typed.length) {
        color = scheme.onPrimary;
        bg = scheme.primary;
      } else {
        color = scheme.onSurface.withValues(alpha: 0.6);
      }
      spans.add(TextSpan(
        text: target[i],
        style: TextStyle(color: color, backgroundColor: bg),
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 22,
                  height: 1.6,
                  fontFamily: 'monospace',
                  color: scheme.onSurface,
                ),
                children: spans,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: controller,
          onChanged: onChanged,
          enabled: enabled,
          autofocus: true,
          maxLines: 3,
          style: const TextStyle(fontSize: 18, fontFamily: 'monospace'),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Start typing here...',
          ),
        ),
      ],
    );
  }
}
