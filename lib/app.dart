import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'utils/app_theme.dart';

class AdaptiveTypingApp extends StatelessWidget {
  const AdaptiveTypingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<BackgroundTheme>(
      valueListenable: AppTheme.current,
      builder: (context, bg, _) {
        return MaterialApp(
          title: 'Adaptive AI Typing Tutor',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.build(bg),
          builder: (context, child) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              decoration: BoxDecoration(gradient: bg.gradient),
              child: child,
            );
          },
          home: const HomeScreen(),
        );
      },
    );
  }
}
