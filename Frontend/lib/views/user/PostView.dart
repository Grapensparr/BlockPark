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
  bool untilFurtherNotice = false;
  String additionalInfo = '';
  bool garageSelected = false;
  bool parkingSpaceSelected = false;

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
        'end': const TimeOfDay(hour: 23, minute: 59),
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
            TextField(
              decoration: const InputDecoration(labelText: 'Address'),
              onChanged: (value) {
                setState(() {
                  address = value;
                });
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(labelText: 'Zip code'),
                    onChanged: (value) {
                      setState(() {
                        zipCode = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(labelText: 'City'),
                    onChanged: (value) {
                      setState(() {
                        city = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Start date'),
                Row(
                  children: [
                    TextButton(
                      onPressed: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: startDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2101),
                        );
                        if (selectedDate != null) {
                          setState(() {
                            startDate = selectedDate;
                            if (endDate != null &&
                                endDate!.isBefore(startDate)) {
                              endDate = startDate;
                            }
                          });
                        }
                      },
                      child: Text(
                        '${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}',
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: !untilFurtherNotice,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Select end date'),
                      TextButton(
                        onPressed: () async {
                          final selectedDate = await showDatePicker(
                            context: context,
                            initialDate: endDate ?? DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2101),
                          );
                          if (selectedDate != null) {
                            setState(() {
                              endDate = selectedDate;
                              if (endDate!.isBefore(startDate)) {
                                endDate = startDate;
                              }
                            });
                          }
                        },
                        child: Text(
                          endDate != null
                              ? '${endDate!.year}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}'
                              : 'Select end date',
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Checkbox(
                      value: untilFurtherNotice,
                      onChanged: (value) {
                        setState(() {
                          untilFurtherNotice = value ?? false;
                          if (untilFurtherNotice) {
                            endDate = null;
                          }
                        });
                      },
                    ),
                    const Text('Until further notice'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: garageSelected,
                      onChanged: (value) {
                        setState(() {
                          garageSelected = value ?? false;
                          if (garageSelected) {
                            parkingSpaceSelected = false;
                          }
                        });
                      },
                    ),
                    const Text('Garage'),
                  ],
                ),
                const SizedBox(width: 16),
                Row(
                  children: [
                    Checkbox(
                      value: parkingSpaceSelected,
                      onChanged: (value) {
                        setState(() {
                          parkingSpaceSelected = value ?? false;
                          if (parkingSpaceSelected) {
                            garageSelected = false;
                          }
                        });
                      },
                    ),
                    const Text('Parking space'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (int i = 0; i < daysOfWeek.length; i++)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                final day = daysOfWeek[i];
                                if (selectedDays.contains(day)) {
                                  selectedDays.remove(day);
                                } else {
                                  selectedDays.add(day);
                                }
                              });
                            },
                            child: Text(
                              daysOfWeek[i],
                              style: TextStyle(
                                fontWeight: selectedDays.contains(daysOfWeek[i])
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                          if (selectedDays.contains(daysOfWeek[i]))
                            Column(
                              children: [
                                TextButton(
                                  onPressed: () async {
                                    final selectedTime = await showTimePicker(
                                      context: context,
                                      initialTime:
                                          dayTimes[daysOfWeek[i]]!['start']!,
                                      builder:
                                          (BuildContext context, Widget? child) {
                                        return MediaQuery(
                                          data: MediaQuery.of(context)
                                              .copyWith(
                                                  alwaysUse24HourFormat: true),
                                          child: child!,
                                        );
                                      },
                                    );
                                    if (selectedTime != null) {
                                      setState(() {
                                        dayTimes[daysOfWeek[i]]!['start'] =
                                            selectedTime;
                                      });
                                    }
                                  },
                                  child: Text(
                                    '${dayTimes[daysOfWeek[i]]!['start']!.hour.toString().padLeft(2, '0')}:${dayTimes[daysOfWeek[i]]!['start']!.minute.toString().padLeft(2, '0')}',
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    final selectedTime = await showTimePicker(
                                      context: context,
                                      initialTime:
                                          dayTimes[daysOfWeek[i]]!['end']!,
                                      builder:
                                          (BuildContext context, Widget? child) {
                                        return MediaQuery(
                                          data: MediaQuery.of(context)
                                              .copyWith(
                                                  alwaysUse24HourFormat: true),
                                          child: child!,
                                        );
                                      },
                                    );
                                    if (selectedTime != null) {
                                      setState(() {
                                        dayTimes[daysOfWeek[i]]!['end'] =
                                            selectedTime;
                                      });
                                    }
                                  },
                                  child: Text(
                                    '${dayTimes[daysOfWeek[i]]!['end']!.hour.toString().padLeft(2, '0')}:${dayTimes[daysOfWeek[i]]!['end']!.minute.toString().padLeft(2, '0')}',
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration:
                  const InputDecoration(labelText: 'Additional information'),
              onChanged: (value) {
                setState(() {
                  additionalInfo = value;
                });
              },
              maxLines: null,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                print('Address: $address');
                print('Zip code: $zipCode');
                print('City: $city');
                print('Start date: ${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}');
                if (!untilFurtherNotice) {
                  print('End date: ${endDate!.year}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}');
                } else {
                  print('End date: Until further notice');
                }
                if (garageSelected) {
                  print('Selected: Garage');
                } else if (parkingSpaceSelected) {
                  print('Selected: Parking space');
                }
                for (final day in selectedDays) {
                  final startTime = dayTimes[day]!['start'];
                  final endTime = dayTimes[day]!['end'];
                  print('$day Start time: ${startTime!.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}');
                  print('$day End time: ${endTime!.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}');
                }
                print('Additional info: $additionalInfo');
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}