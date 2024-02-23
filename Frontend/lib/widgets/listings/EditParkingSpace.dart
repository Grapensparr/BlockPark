import 'package:blockpark/controllers/UpdateController.dart';
import 'package:blockpark/views/user/postForms/AvailabilityForm.dart';
import 'package:flutter/material.dart';

class EditParkingSpace extends StatefulWidget {
  final Map<String, dynamic> listingData;

  const EditParkingSpace({
    required this.listingData,
  });

  @override
  _EditParkingSpaceState createState() => _EditParkingSpaceState();
}

class _EditParkingSpaceState extends State<EditParkingSpace> {
  late TextEditingController _priceController;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;
  late bool _accessibilityCheckboxValue;
  late bool _largeVehiclesCheckboxValue;

  late DateTime startDate;
  late DateTime? endDate;
  late List<String> daysOfWeek;
  late Map<String, Map<String, TimeOfDay>> dayTimes;
  late Set<String> selectedDays;

  @override
  void initState() {
    super.initState();
    _priceController = TextEditingController(text: widget.listingData['price'].toString());
    startDate = DateTime.parse(widget.listingData['startDate']);
    endDate = widget.listingData['endDate'] != null ? DateTime.parse(widget.listingData['endDate']) : null;
    _startDateController = TextEditingController(text: _formatDate(startDate));
    _endDateController = TextEditingController(
      text: endDate != null ? _formatDate(endDate!) : 'Until further notice');
    _accessibilityCheckboxValue = widget.listingData['accessibility'];
    _largeVehiclesCheckboxValue = widget.listingData['largeVehicles'];
    
    final Map<String, dynamic> rawDayTimes = widget.listingData['dayTimes'];
    dayTimes = rawDayTimes.map<String, Map<String, TimeOfDay>>((key, value) {
      final Map<String, dynamic> timeMap = value as Map<String, dynamic>;
      return MapEntry<String, Map<String, TimeOfDay>>(
        key,
        {
          'start': _parseTimeOfDay(timeMap['start'] as String),
          'end': _parseTimeOfDay(timeMap['end'] as String),
        },
      );
    });

    selectedDays = dayTimes.keys.toSet();
    daysOfWeek = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  }

  @override
  void dispose() {
    _priceController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit parking space'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AvailabilityForm(
              startDate: startDate,
              endDate: endDate,
              daysOfWeek: daysOfWeek,
              dayTimes: dayTimes,
              selectedDays: selectedDays,
              onStartDateChanged: (date) {
                setState(() {
                  startDate = date;
                  _startDateController.text = _formatDate(date);
                });
              },
              onEndDateChanged: (date) {
                setState(() {
                  endDate = date;
                  _endDateController.text = date != null ? _formatDate(date) : 'Until further notice';
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
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
            ),
            const Text('Price:'),
            TextFormField(
              controller: _priceController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            const Text('Large vehicles:'),
            _buildCheckbox('Accepts large vehicles', _largeVehiclesCheckboxValue),
            const SizedBox(height: 16),
            const Text('Accessibility:'),
            _buildCheckbox('Extra wide parking space', _accessibilityCheckboxValue),
            const SizedBox(height: 16),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            _updateParkingSpace();
            Navigator.pop(context);
          },
          child: const Text('Save Changes'),
        ),
      ],
    );
  }

  Widget _buildCheckbox(String title, bool initialValue) {
    return Row(
      children: [
        Checkbox(
          value: initialValue,
          onChanged: (value) {
            setState(() {
              if (title == 'Accepts large vehicles') {
                _largeVehiclesCheckboxValue = value ?? false;
              } else if (title == 'Extra wide parking space') {
                _accessibilityCheckboxValue = value ?? false;
              }
            });
          },
        ),
        Text(title),
      ],
    );
  }

  void _updateParkingSpace() {
    Map<String, Map<String, String>> stringDayTimes = {};
    dayTimes.forEach((day, times) {
      stringDayTimes[day] = {
        'start': '${times['start']?.hour.toString().padLeft(2, '0')}:${times['start']?.minute.toString().padLeft(2, '0')}',
        'end': '${times['end']?.hour.toString().padLeft(2, '0')}:${times['end']?.minute.toString().padLeft(2, '0')}',
      };
    });

    Map<String, dynamic> updatedValues = {
      'price': double.parse(_priceController.text),
      'accessibility': _accessibilityCheckboxValue,
      'largeVehicles': _largeVehiclesCheckboxValue,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'dayTimes': stringDayTimes,
    };

    UpdateController.updateParkingSpace(widget.listingData['_id'], updatedValues, context);
  }

  String _formatDate(dynamic date) {
    if (date == null) {
      return 'Until further notice';
    }
    return date.toString().substring(0, 10);
  }

  TimeOfDay _parseTimeOfDay(String timeString) {
    final parts = timeString.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
}