import 'package:blockpark/controllers/PostController.dart';
import 'package:blockpark/views/user/postForms/AddressForm.dart';
import 'package:blockpark/views/user/postForms/AvailabilityForm.dart';
import 'package:blockpark/views/user/postForms/DetailsForm.dart';
import 'package:blockpark/views/user/postForms/PricingForm.dart';
import 'package:flutter/material.dart';

class PostView extends StatefulWidget {
  const PostView({Key? key}) : super(key: key);

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  String address = '';
  String zipCode = '';
  String city = '';
  String pricePerHour = '';
  String paymentSchedule = '';
  String additionalInfo = '';
  bool garageSelected = false;
  bool outsideParkingSpaceSelected = false;
  bool acceptLargeVehicles = false;
  bool accessibility = false;

  DateTime startDate = DateTime.now();
  DateTime? endDate;

  Map<String, Map<String, TimeOfDay>> dayTimes = {};

  Set<String> selectedDays = <String>{};

  final List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  void initState() {
    super.initState();

    for (final day in daysOfWeek) {
      dayTimes[day] = {
        'start': const TimeOfDay(hour: 0, minute: 0),
        'end': const TimeOfDay(hour: 0, minute: 0),
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            AddressForm(
              onAddressChanged: (value) {
                setState(() {
                  address = value;
                });
              },
              onZipCodeChanged: (value) {
                setState(() {
                  zipCode = value;
                });
              },
              onCityChanged: (value) {
                setState(() {
                  city = value;
                });
              },
              constraints: const BoxConstraints(maxWidth: 800),
            ),
            const SizedBox(height: 50),
            AvailabilityForm(
              startDate: startDate,
              endDate: endDate,
              daysOfWeek: daysOfWeek,
              dayTimes: dayTimes,
              selectedDays: selectedDays,
              onStartDateChanged: (value) {
                setState(() {
                  startDate = value;
                });
              },
              onEndDateChanged: (value) {
                setState(() {
                  endDate = value;
                });
              },
              onStartTimeChanged: (day, time) {
                setState(() {
                  dayTimes[day]!['start'] = time;
                });
              },
              onEndTimeChanged: (day, time) {
                setState(() {
                  dayTimes[day]!['end'] = time;
                });
              },
              constraints: const BoxConstraints(maxWidth: 800),
            ),
            const SizedBox(height: 50),
            PricingForm(
              pricePerHour: pricePerHour,
              paymentSchedule: paymentSchedule,
              onPricePerHourChanged: (value) {
                setState(() {
                  pricePerHour = value;
                });
              },
              onPaymentScheduleChanged: (value) {
                setState(() {
                  paymentSchedule = value;
                });
              },
              constraints: const BoxConstraints(maxWidth: 800),
            ),
            const SizedBox(height: 50),
            DetailsForm(
              garageSelected: garageSelected,
              outsideParkingSpaceSelected: outsideParkingSpaceSelected,
              acceptLargeVehicles: acceptLargeVehicles,
              accessibility: accessibility,
              additionalInfo: additionalInfo,
              onGarageSelectedChanged: (value) {
                setState(() {
                  garageSelected = value ?? false;
                  if (garageSelected) {
                    outsideParkingSpaceSelected = false;
                  }
                });
              },
              onOutsideParkingSpaceSelectedChanged: (value) {
                setState(() {
                  outsideParkingSpaceSelected = value ?? false;
                  if (outsideParkingSpaceSelected) {
                    garageSelected = false;
                  }
                });
              },
              onAcceptLargeVehiclesChanged: (value) {
                setState(() {
                  acceptLargeVehicles = value ?? false;
                });
              },
              onAccessibilityChanged: (value) {
                setState(() {
                  accessibility = value ?? false;
                });
              },
              onAdditionalInfoChanged: (value) {
                setState(() {
                  additionalInfo = value;
                });
              },
              constraints: const BoxConstraints(maxWidth: 800),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final validDayTimes = dayTimes.entries.where((entry) =>
                  entry.value['start'] != const TimeOfDay(hour: 0, minute: 0) ||
                  entry.value['end'] != const TimeOfDay(hour: 0, minute: 0)
                );

                final formattedDayTimes = Map.fromEntries(
                  validDayTimes.map(
                    (entry) => MapEntry(
                      entry.key,
                      {
                        'start': '${entry.value['start']!.hour}:${entry.value['start']!.minute}',
                        'end': '${entry.value['end']!.hour}:${entry.value['end']!.minute}',
                      },
                    )
                  )
                );

                PostController.addParkingSpace(
                  address: address,
                  zipCode: zipCode,
                  city: city,
                  startDate: startDate,
                  endDate: endDate,
                  price: double.parse(pricePerHour),
                  paymentSchedule: paymentSchedule,
                  isGarage: garageSelected,
                  isParkingSpace: outsideParkingSpaceSelected,
                  accessibility: accessibility,
                  largeVehicles: acceptLargeVehicles,
                  dayTimes: formattedDayTimes,
                  scaffoldMessenger: ScaffoldMessenger.of(context),
                );
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}