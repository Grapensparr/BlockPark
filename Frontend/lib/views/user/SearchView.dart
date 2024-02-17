import 'package:blockpark/widgets/appBar/Header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  String? _city;
  DateTime? _endDate;
  double? _price;
  late TextEditingController _priceController;
  bool _unlimitedPrice = false;
  bool _isGarage = false;
  bool _isParkingSpace = false;
  bool _accessibility = false;
  bool _largeVehicles = false;
  bool _untilFurtherNotice = false;

  List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  Map<String, Map<String, TimeOfDay>> dayTimes = {};

  Set<String> selectedDays = <String>{};

  @override
  void initState() {
    super.initState();

    _priceController = TextEditingController(text: _price != null ? '$_price' : '');

    for (final day in daysOfWeek) {
      dayTimes[day] = {
        'start': const TimeOfDay(hour: 0, minute: 0),
        'end': const TimeOfDay(hour: 0, minute: 0),
      };
    }
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'City'),
                    onChanged: (value) {
                      setState(() {
                        _city = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(labelText: 'End date'),
                          onTap: () async {
                            if (!_untilFurtherNotice) {
                              final selectedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2100),
                              );
                              if (selectedDate != null) {
                                setState(() {
                                  _endDate = selectedDate;
                                });
                              }
                            }
                          },
                          readOnly: true,
                          controller: TextEditingController(text: _untilFurtherNotice ? 'Until further notice' : (_endDate != null ? _endDate.toString() : '')),
                        ),
                      ),
                      Checkbox(
                        value: _untilFurtherNotice,
                        onChanged: (value) {
                          setState(() {
                            _untilFurtherNotice = value!;
                            if (_untilFurtherNotice) {
                              _endDate = null;
                            }
                          });
                        },
                      ),
                      const Text('Until further notice'),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Maximum price per hour (ETH)',
                          ),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                          ],
                          enabled: !_unlimitedPrice,
                          onChanged: (value) {
                            setState(() {
                              if (!_unlimitedPrice) {
                                _price = double.tryParse(value);
                              }
                            });
                          },
                          controller: _priceController,
                        ),
                      ),
                      Checkbox(
                        value: _unlimitedPrice,
                        onChanged: (value) {
                          setState(() {
                            _unlimitedPrice = value!;
                            if (value) {
                              _priceController.text = '';
                              _price = null;
                            }
                          });
                        },
                      ),
                      const Text('Unlimited price'),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Checkbox(
                        value: _isGarage,
                        onChanged: (value) {
                          setState(() {
                            _isGarage = value!;
                          });
                        },
                      ),
                      const Text('Garage'),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: _isParkingSpace,
                        onChanged: (value) {
                          setState(() {
                            _isParkingSpace = value!;
                          });
                        },
                      ),
                      const Text('Outside parking space'),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: _accessibility,
                        onChanged: (value) {
                          setState(() {
                            _accessibility = value!;
                          });
                        },
                      ),
                      const Text('Extra wide parking space'),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: _largeVehicles,
                        onChanged: (value) {
                          setState(() {
                            _largeVehicles = value!;
                          });
                        },
                      ),
                      const Text('Accepts large vehicles (trucks, RVs etc.)'),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Center(
                    child: SingleChildScrollView(
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
                                          dayTimes[day]!['start'] = const TimeOfDay(hour: 0, minute: 0);
                                          dayTimes[day]!['end'] = const TimeOfDay(hour: 0, minute: 0);
                                        } else {
                                          selectedDays.add(day);
                                        }
                                      });
                                    },
                                    child: Text(
                                      daysOfWeek[i],
                                      style: TextStyle(
                                        fontWeight: selectedDays.contains(daysOfWeek[i]) ? FontWeight.bold : FontWeight.normal,
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
                                              initialTime: dayTimes[daysOfWeek[i]]!['start']!,
                                            );
                                            if (selectedTime != null) {
                                              setState(() {
                                                dayTimes[daysOfWeek[i]]!['start'] = selectedTime;
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
                                              initialTime: dayTimes[daysOfWeek[i]]!['end']!,
                                            );
                                            if (selectedTime != null) {
                                              setState(() {
                                                dayTimes[daysOfWeek[i]]!['end'] = selectedTime;
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
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      print('City: $_city');
                      print('End date: $_endDate');
                      print('Price: $_price');
                      print('Garage: $_isGarage');
                      print('Parking space: $_isParkingSpace');
                      print('Accessibility: $_accessibility');
                      print('Large vehicles: $_largeVehicles');
                      print('Selected days: $selectedDays');
                      print('Day times: $dayTimes');
                    },
                    child: const Text('Search'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}