// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart'; // Import provider
import 'package:myapp/main.dart';
import 'package:myapp/services/settings_service.dart'; // Import SettingsService

void main() {
  group('EditorScreen Tests', () {
    testWidgets('EditorScreen UI Test', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        Provider(create: (_) => SettingsService(), child: const MyApp()),
      );

      // Verify that our editor screen is displayed.
      expect(find.text('Spec Editor'), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('Autocomplete for / commands appears and inserts correctly', (
      WidgetTester tester,
    ) async {
      // Mock SharedPreferences to return some commands
      SharedPreferences.setMockInitialValues({
        'commands': [
          '{"title":"/bug","description":"Report a bug"}',
          '{"title":"/feature","description":"Request a new feature"}',
        ],
      });

      await tester.pumpWidget(
        Provider(create: (_) => SettingsService(), child: const MyApp()),
      );

      // Type '/' to trigger autocomplete
      await tester.enterText(find.byType(TextField), '/');
      await tester.pump();

      // Verify that suggestions appear
      expect(find.text('/bug'), findsOneWidget);
      expect(find.text('/feature'), findsOneWidget);

      // Tap on a suggestion
      await tester.tap(find.text('/bug'));
      await tester.pumpAndSettle();

      // Verify that the suggestion is inserted
      expect(find.text('/bug'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        '/bug',
      );
    });
  });
}
