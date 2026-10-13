import 'package:flutter/material.dart';
import 'app.dart';
import 'utils/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppTheme.load();
  runApp(const AdaptiveTypingApp());
}
