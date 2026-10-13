import 'package:flutter/material.dart';
import '../services/storage_service.dart';

/// A full-screen gradient background plus a matching color scheme.
class BackgroundTheme {
  final String name;
  final List<Color> colors;
  final Brightness brightness;
  final Color seed;

  const BackgroundTheme({
    required this.name,
    required this.colors,
    required this.brightness,
    required this.seed,
  });

  LinearGradient get gradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: colors,
      );
}

class AppTheme {
  static const List<BackgroundTheme> themes = [
    BackgroundTheme(
      name: 'Aurora',
      colors: [Color(0xFF0F0C29), Color(0xFF302B63), Color(0xFF24C6DC)],
      brightness: Brightness.dark,
      seed: Color(0xFF7C4DFF),
    ),
    BackgroundTheme(
      name: 'Sunset',
      colors: [Color(0xFFFF7E5F), Color(0xFFD6336C), Color(0xFF6A1B9A)],
      brightness: Brightness.dark,
      seed: Color(0xFFFF7043),
    ),
    BackgroundTheme(
      name: 'Ocean',
      colors: [Color(0xFF2193B0), Color(0xFF1565C0), Color(0xFF0D2B5C)],
      brightness: Brightness.dark,
      seed: Color(0xFF29B6F6),
    ),
    BackgroundTheme(
      name: 'Forest',
      colors: [Color(0xFF0B3D2E), Color(0xFF1B6B4A), Color(0xFF2E8B57)],
      brightness: Brightness.dark,
      seed: Color(0xFF66BB6A),
    ),
    BackgroundTheme(
      name: 'Midnight',
      colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
      brightness: Brightness.dark,
      seed: Color(0xFF4DD0E1),
    ),
    BackgroundTheme(
      name: 'Cotton Candy',
      colors: [Color(0xFFFFE0F0), Color(0xFFE0D4FF), Color(0xFFCDEBFF)],
      brightness: Brightness.light,
      seed: Color(0xFFEC407A),
    ),
    BackgroundTheme(
      name: 'Sky',
      colors: [Color(0xFFE0F7FA), Color(0xFFB3E5FC), Color(0xFF81D4FA)],
      brightness: Brightness.light,
      seed: Color(0xFF0288D1),
    ),
  ];

  /// Currently selected background theme.
  static final ValueNotifier<BackgroundTheme> current =
      ValueNotifier<BackgroundTheme>(themes.first);

  static final StorageService _storage = StorageService();

  static Future<void> load() async {
    final idx = await _storage.loadThemeIndex();
    current.value = themes[idx.clamp(0, themes.length - 1)];
  }

  static Future<void> select(BackgroundTheme theme) async {
    current.value = theme;
    await _storage.saveThemeIndex(themes.indexOf(theme));
  }

  static ThemeData build(BackgroundTheme t) {
    final isDark = t.brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: t.seed,
      brightness: t.brightness,
    );
    final cardColor = isDark
        ? Colors.white.withValues(alpha: 0.12)
        : Colors.white.withValues(alpha: 0.65);

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: Colors.transparent,
      canvasColor: Colors.transparent,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        foregroundColor: scheme.onSurface,
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: Colors.white.withValues(alpha: isDark ? 0.18 : 0.8),
          ),
        ),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: scheme.onSurface,
        textColor: scheme.onSurface,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: isDark ? const Color(0xFF1B1B2F) : Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
    );
  }
}
