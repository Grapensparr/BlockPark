import 'package:flutter/material.dart';

class AvailabilityForm extends StatefulWidget {
  final DateTime startDate;
  final DateTime? endDate;
  final List<String> daysOfWeek;
  final Map<String, Map<String, TimeOfDay>> dayTimes;
  final Set<String> selectedDays;
  final Function(DateTime) onStartDateChanged;
  final Function(DateTime?) onEndDateChanged;
  final Function(String, TimeOfDay) onStartTimeChanged;
  final Function(String, TimeOfDay) onEndTimeChanged;
  final BoxConstraints constraints;

  const AvailabilityForm({
    Key? key, 
    required this.startDate,
    required this.endDate,
    required this.daysOfWeek,
    required this.dayTimes,
    required this.selectedDays,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
    required this.onStartTimeChanged,
    required this.onEndTimeChanged,
    required this.constraints,
  }) : super(key: key);

  @override
  _AvailabilityFormState createState() => _AvailabilityFormState();
}

class _AvailabilityFormState extends State<AvailabilityForm> {
  bool untilFurtherNotice = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: widget.constraints,
      child: Column(
        children: [
          const Text(
            'Availability',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: widget.constraints.maxWidth * 0.25,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Start date'),
                      TextButton(
                        onPressed: () async {
                          final selectedDate = await showDatePicker(
                            context: context,
                            initialDate: widget.startDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2101),
                          );
                          if (selectedDate != null) {
                            widget.onStartDateChanged(selectedDate);
                            if (widget.endDate != null && widget.endDate!.isBefore(selectedDate)) {
                              widget.onEndDateChanged(selectedDate);
                            }
                          }
                        },
                        child: Text(
                          '${widget.startDate.year}-${widget.startDate.month.toString().padLeft(2, '0')}-${widget.startDate.day.toString().padLeft(2, '0')}',
                        ),
                      ),
                      Visibility(
                        visible: !untilFurtherNotice,
                        child: const SizedBox(height: 34),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: widget.constraints.maxWidth * 0.25,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('End date'),
                      Visibility(
                        visible: !untilFurtherNotice,
                        child: TextButton(
                          onPressed: () async {
                            final selectedDate = await showDatePicker(
                              context: context,
                              initialDate: widget.endDate ?? DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2101),
                            );
                            if (selectedDate != null) {
                              widget.onEndDateChanged(selectedDate);
                              if (selectedDate.isBefore(widget.startDate)) {
                                widget.onStartDateChanged(selectedDate);
                              }
                            }
                          },
                          child: Text(
                            widget.endDate != null
                              ? '${widget.endDate!.year}-${widget.endDate!.month.toString().padLeft(2, '0')}-${widget.endDate!.day.toString().padLeft(2, '0')}'
                              : 'End date',
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: untilFurtherNotice,
                            onChanged: (value) {
                              setState(() {
                                untilFurtherNotice = value ?? false;
                                if (untilFurtherNotice) {
                                  widget.onEndDateChanged(null);
                                }
                              });
                            },
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 3),
                            child: Text('Until further notice'),
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (int i = 0; i < widget.daysOfWeek.length; i++)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                final day = widget.daysOfWeek[i];
                                if (widget.selectedDays.contains(day)) {
                                  widget.selectedDays.remove(day);
                                  widget.dayTimes[day]!['start'] = const TimeOfDay(hour: 0, minute: 0);
                                  widget.dayTimes[day]!['end'] = const TimeOfDay(hour: 0, minute: 0);
                                } else {
                                  widget.selectedDays.add(day);
                                }
                              });
                            },
                            child: Text(
                              widget.daysOfWeek[i],
                              style: TextStyle(
                                fontWeight: widget.selectedDays.contains(widget.daysOfWeek[i])
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                        if (widget.selectedDays.contains(widget.daysOfWeek[i]))
                          Column(
                            children: [
                              TextButton(
                                onPressed: () async {
                                  final selectedTime = await showTimePicker(
                                    context: context,
                                    initialTime: widget.dayTimes[widget.daysOfWeek[i]]!['start']!,
                                    builder: (BuildContext context, Widget? child) {
                                      return MediaQuery(
                                        data: MediaQuery.of(context).copyWith(
                                          alwaysUse24HourFormat: true,
                                        ),
                                        child: child!,
                                      );
                                    },
                                  );
                                  if (selectedTime != null) {
                                    widget.onStartTimeChanged(widget.daysOfWeek[i], selectedTime);
                                  }
                                },
                                child: Text(
                                  '${widget.dayTimes[widget.daysOfWeek[i]]!['start']!.hour.toString().padLeft(2, '0')}:${widget.dayTimes[widget.daysOfWeek[i]]!['start']!.minute.toString().padLeft(2, '0')}',
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  final selectedTime = await showTimePicker(
                                    context: context,
                                    initialTime: widget.dayTimes[widget.daysOfWeek[i]]!['end']!,
                                    builder: (BuildContext context, Widget? child) {
                                      return MediaQuery(
                                        data: MediaQuery.of(context).copyWith(
                                          alwaysUse24HourFormat: true,
                                        ),
                                        child: child!,
                                      );
                                    },
                                  );
                                  if (selectedTime != null) {
                                    widget.onEndTimeChanged(widget.daysOfWeek[i], selectedTime);
                                  }
                                },
                                child: Text(
                                  '${widget.dayTimes[widget.daysOfWeek[i]]!['end']!.hour.toString().padLeft(2, '0')}:${widget.dayTimes[widget.daysOfWeek[i]]!['end']!.minute.toString().padLeft(2, '0')}',
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
        ],
      )
    );
  }
}