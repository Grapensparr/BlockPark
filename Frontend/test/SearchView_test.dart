import 'package:blockpark/views/user/SearchView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SearchView tests', () {
    testWidgets('SearchView UI components', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SearchView()
        )
      );

      expect(find.byType(TextFormField), findsNWidgets(3));
      expect(find.byType(Checkbox), findsNWidgets(5));
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('SearchView checkboxes', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SearchView()
        )
      );

      await tester.tap(find.byType(Checkbox).first);
      await tester.tap(find.byType(Checkbox).at(1));

      await tester.pumpAndSettle();

      expect(tester.widget<Checkbox>(find.byType(Checkbox).first).value, true);
      expect(tester.widget<Checkbox>(find.byType(Checkbox).at(1)).value, true);

      await tester.tap(find.byType(Checkbox).first);
      await tester.tap(find.byType(Checkbox).at(1));

      await tester.pumpAndSettle();

      expect(tester.widget<Checkbox>(find.byType(Checkbox).first).value, false);
      expect(tester.widget<Checkbox>(find.byType(Checkbox).at(1)).value, false);
    });

    testWidgets('SearchView input field', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SearchView()
        )
      );

      final inputFieldFinder = find.byType(TextFormField).first;

      await tester.enterText(inputFieldFinder, 'Stockholm');

      expect(find.text('Stockholm'), findsOneWidget);
    });
  });
}