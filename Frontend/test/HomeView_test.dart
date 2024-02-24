import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:blockpark/views/user/HomeView.dart';
import 'FetchController_test.mocks.mocks.dart';

void main() {
  group('HomeView Tests', () {
    testWidgets('HomeView shows fetched data', (tester) async {
      final fetchController = MockFetchController();
      final mockData = await fetchController.fetchStatusCounts();

      await tester.pumpWidget(MaterialApp(
        home: HomeView(
          statusCounts: Future.value(mockData)
        ),
      ));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();

      expect(find.text('Available parking spaces'), findsOneWidget);
      expect(find.text('${mockData['available']}'), findsOneWidget);
      expect(find.text('Current rentals'), findsOneWidget);
      expect(find.text('${mockData['rented']}'), findsOneWidget);
      expect(find.text('Completed rentals'), findsOneWidget);
      expect(find.text('${mockData['rentingComplete']}'), findsOneWidget);
    });
  });
}