import 'package:blockpark/views/user/postForms/AddressForm.dart';
import 'package:blockpark/views/user/postForms/DetailsForm.dart';
import 'package:blockpark/views/user/postForms/PricingForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PostView tests', () {
    testWidgets('AddressForm should trigger callbacks on text change', (WidgetTester tester) async {
      String addressValue = '';
      String zipCodeValue = '';
      String cityValue = '';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AddressForm(
              onAddressChanged: (value) {
                addressValue = value;
              },
              onZipCodeChanged: (value) {
                zipCodeValue = value;
              },
              onCityChanged: (value) {
                cityValue = value;
              },
              constraints: const BoxConstraints(),
            ),
          ),
        ),
      );

      await tester.enterText(find.widgetWithText(TextField, 'Address*'), 'Kungsgatan');
      await tester.enterText(find.widgetWithText(TextField, 'Zip code*'), '12345');
      await tester.enterText(find.widgetWithText(TextField, 'City*'), 'Stockholm');

      expect(addressValue, 'Kungsgatan');
      expect(zipCodeValue, '12345');
      expect(cityValue, 'Stockholm');
    });
    
    testWidgets('DetailsForm UI components', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: DetailsForm(
                garageSelected: false,
                outsideParkingSpaceSelected: false,
                acceptLargeVehicles: false,
                accessibility: false,
                additionalInfo: '',
                onGarageSelectedChanged: (value) {},
                onOutsideParkingSpaceSelectedChanged: (value) {},
                onAcceptLargeVehiclesChanged: (value) {},
                onAccessibilityChanged: (value) {},
                onAdditionalInfoChanged: (value) {},
                constraints: const BoxConstraints(),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(Checkbox), findsNWidgets(4));
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('DetailsForm checkboxes, garage and outside parking space cannot both be true', (WidgetTester tester) async {
      bool garageSelected = false;
      bool outsideParkingSpaceSelected = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: DetailsForm(
                garageSelected: garageSelected,
                outsideParkingSpaceSelected: outsideParkingSpaceSelected,
                acceptLargeVehicles: false,
                accessibility: false,
                additionalInfo: '',
                onGarageSelectedChanged: (value) {
                  garageSelected = value ?? false;
                  if (garageSelected) {
                    outsideParkingSpaceSelected = false;
                  }
                },
                onOutsideParkingSpaceSelectedChanged: (value) {
                  outsideParkingSpaceSelected = value ?? false;
                  if (outsideParkingSpaceSelected) {
                    garageSelected = false;
                  }
                },
                onAcceptLargeVehiclesChanged: (value) {},
                onAccessibilityChanged: (value) {},
                onAdditionalInfoChanged: (value) {},
                constraints: const BoxConstraints(),
              ),
            ),
          ),
        ),
      );

      expect(garageSelected, false);
      expect(outsideParkingSpaceSelected, false);

      await tester.tap(find.byType(Checkbox).first);
      await tester.pumpAndSettle();

      expect(garageSelected, true);
      expect(outsideParkingSpaceSelected, false);

      await tester.tap(find.byType(Checkbox).at(1));
      await tester.pumpAndSettle();

      expect(garageSelected, false);
      expect(outsideParkingSpaceSelected, true);

      await tester.tap(find.byType(Checkbox).first);
      await tester.pumpAndSettle();

      expect(garageSelected, true);
      expect(outsideParkingSpaceSelected, false);
    });

    testWidgets('DetailsForm input field', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: DetailsForm(
                garageSelected: false,
                outsideParkingSpaceSelected: false,
                acceptLargeVehicles: false,
                accessibility: false,
                additionalInfo: '',
                onGarageSelectedChanged: (value) {},
                onOutsideParkingSpaceSelectedChanged: (value) {},
                onAcceptLargeVehiclesChanged: (value) {},
                onAccessibilityChanged: (value) {},
                onAdditionalInfoChanged: (value) {},
                constraints: const BoxConstraints(),
              ),
            ),
          ),
        ),
      );

      final inputFieldFinder = find.byType(TextField);

      await tester.enterText(inputFieldFinder, 'Test additional info');

      expect(find.text('Test additional info'), findsOneWidget);
    });

    testWidgets('PricingForm UI components', (WidgetTester tester) async {
      String pricePerHourValue = '';
      String paymentScheduleValue = '';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PricingForm(
              pricePerHour: '',
              paymentSchedule: '',
              onPricePerHourChanged: (value) {
                pricePerHourValue = value;
              },
              onPaymentScheduleChanged: (value) {
                paymentScheduleValue = value;
              },
              constraints: const BoxConstraints(),
            ),
          ),
        ),
      );

      expect(find.text('Pricing'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(Checkbox), findsNWidgets(4));
    });

    testWidgets('Price per hour textfield', (WidgetTester tester) async {
      String pricePerHourValue = '';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PricingForm(
              pricePerHour: '',
              paymentSchedule: '',
              onPricePerHourChanged: (value) {
                pricePerHourValue = value;
              },
              onPaymentScheduleChanged: (value) {},
              constraints: const BoxConstraints(),
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), '10');

      expect(pricePerHourValue, '10');
    });

    testWidgets('Payment schedule checkboxes', (WidgetTester tester) async {
      String paymentScheduleValue = '';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: PricingForm(
                  pricePerHour: '',
                  paymentSchedule: '',
                  onPricePerHourChanged: (value) {},
                  onPaymentScheduleChanged: (value) {
                    paymentScheduleValue = value;
                  },
                  constraints: const BoxConstraints(),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(Checkbox).first);
      await tester.pumpAndSettle();

      expect(paymentScheduleValue, 'fullPayment');
    });
  });
}