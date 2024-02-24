import 'package:blockpark/views/user/ProfileView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'FetchController_test.mocks.mocks.dart';

void main() {
  group('HomeView tests', () {
    testWidgets('HomeView shows fetched data', (tester) async {
      final fetchController = MockFetchController();
      final ownerMockData = await fetchController.fetchParkingSpacesByOwner();
      final renterMockData = await fetchController.fetchParkingSpacesByRenter();

      await tester.pumpWidget(MaterialApp(
        home: ProfileView(
          futureOwnerParkingSpaces: Future.value(ownerMockData),
          futureRenterParkingSpaces: Future.value(renterMockData),
        ),
      ));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsOneWidget);

      await tester.tap(find.byType(ListTile).first);
      await tester.pumpAndSettle();

      expect(find.text('Available'), findsOneWidget);

      expect(find.text('Address: ${ownerMockData[0]['address']}, ${ownerMockData[0]['zipCode']}, ${ownerMockData[0]['city']}'), findsOneWidget);

      await tester.tap(find.byType(ListTile).last);
      await tester.pumpAndSettle();

      expect(find.text('Current'), findsOneWidget);
      expect(find.text('Address: ${renterMockData[0]['address']}, ${renterMockData[0]['zipCode']}, ${renterMockData[0]['city']}'), findsOneWidget);
    });
  });
}
