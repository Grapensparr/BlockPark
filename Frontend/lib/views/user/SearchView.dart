import 'package:blockpark/controllers/SearchController.dart' as MySearchController;
import 'package:blockpark/widgets/appBar/Header.dart';
import 'package:blockpark/widgets/listings/SearchCard.dart';
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
  final ScrollController _scrollController = ScrollController();
  bool _showSearchResults = false;
  List<Map<String, dynamic>> _searchResults = [];

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

  Future<void> _searchParking() async {
    Map<String, Map<String, String>> dayTimesAsString = {};
    dayTimes.forEach((day, times) {
      String startHour = times['start']!.hour.toString().padLeft(2, '0');
      String startMinute = times['start']!.minute.toString().padLeft(2, '0');
      String endHour = times['end']!.hour.toString().padLeft(2, '0');
      String endMinute = times['end']!.minute.toString().padLeft(2, '0');

      dayTimesAsString[day] = {
        'start': '$startHour:$startMinute',
        'end': '$endHour:$endMinute',
      };
    });

    final List<Map<String, dynamic>> searchResult = await MySearchController.SearchController.searchParking(
      city: _city,
      endDate: _endDate,
      price: _unlimitedPrice ? null : _price,
      accessibility: _accessibility,
      largeVehicles: _largeVehicles,
      selectedDays: selectedDays.toList(),
      dayTimes: dayTimesAsString,
      isGarage: _isGarage,
      isParkingSpace: _isParkingSpace,
    );

    setState(() {
      _searchResults = searchResult;
      _showSearchResults = true;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_showSearchResults) {
        _scrollController.animateTo(
          MediaQuery.of(context).size.height * 1,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
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
                    onPressed: _searchParking,
                    child: const Text('Search'),
                  ),

                  Visibility(
                    visible: _showSearchResults,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(
                              child: Text(
                                'Search results',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Column(
                            children: _searchResults.map((result) {
                              return SearchCard(result);
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
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