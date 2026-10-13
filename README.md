# Adaptive AI Typing Tutor

A Flutter typing tutor that adapts practice difficulty to your speed and accuracy.

## Features
- Four difficulty levels: Beginner, Intermediate, Advanced, Expert
- Real-time WPM, accuracy, and timer
- Adaptive engine that promotes or demotes you based on your last 3 sessions
- Weak-key detection: practice text is chosen to emphasize keys you mistype
- Session history with an accuracy trend chart (local storage)
- 7 beautiful gradient background themes (Aurora, Sunset, Ocean, Forest, Midnight, Cotton Candy, Sky) with a theme picker; your choice is saved
- Runs on Android and Web

## Getting Started

```bash
# 1. Generate missing platform files (android/ runner, etc.)
flutter create . --platforms=android,web --project-name adaptive_ai_typing_tutor

# 2. Install dependencies
flutter pub get

# 3. Run
flutter run -d chrome      # web
flutter run                # android device/emulator

# 4. Test
flutter test
```

> `flutter create .` keeps the existing `lib/`, `test/`, `pubspec.yaml` and only fills in the missing platform scaffolding.

## Project Structure

```
lib/
  main.dart, app.dart
  models/    typing_result.dart, practice_level.dart
  screens/   home, practice, result, history
  services/  typing_analyzer, adaptive_engine, storage_service
  widgets/   typing_text_field, progress_card, accuracy_chart
  utils/     app_theme.dart
```

## How the Adaptive Engine Works
- Accuracy >= 95% and WPM above the level target (20/35/50/70) -> level up
- Accuracy < 80% -> level down
- Otherwise stay on the current level
- Most-missed characters from recent sessions bias the next text selection

## Deployment
- **GitHub Pages:** push to `main`; `.github/workflows/deploy.yml` builds and deploys.
- **Render:** connect the repo; `render.yaml` defines a static site.

## License
MIT
