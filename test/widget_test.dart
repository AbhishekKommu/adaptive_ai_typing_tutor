import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:adaptive_ai_typing_tutor/app.dart';

void main() {
  testWidgets('Home screen shows title and start button', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const AdaptiveTypingApp());
    await tester.pumpAndSettle();

    expect(find.text('Adaptive AI Typing Tutor'), findsOneWidget);
    expect(find.text('Start Practice'), findsOneWidget);
  });
}
