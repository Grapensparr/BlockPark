import 'package:flutter/material.dart';

class DetailsForm extends StatefulWidget {
  final bool garageSelected;
  final bool outsideParkingSpaceSelected;
  final bool acceptLargeVehicles;
  final bool accessibility;
  final String additionalInfo;
  final void Function(bool?) onGarageSelectedChanged;
  final void Function(bool?) onOutsideParkingSpaceSelectedChanged;
  final void Function(bool?) onAcceptLargeVehiclesChanged;
  final void Function(bool?) onAccessibilityChanged;
  final void Function(String) onAdditionalInfoChanged;
  final BoxConstraints constraints;

  const DetailsForm({
    Key? key, 
    required this.garageSelected,
    required this.outsideParkingSpaceSelected,
    required this.acceptLargeVehicles,
    required this.accessibility,
    required this.additionalInfo,
    required this.onGarageSelectedChanged,
    required this.onOutsideParkingSpaceSelectedChanged,
    required this.onAcceptLargeVehiclesChanged,
    required this.onAccessibilityChanged,
    required this.onAdditionalInfoChanged,
    required this.constraints,
  }) : super(key: key);

  @override
  _DetailsFormState createState() => _DetailsFormState();
}

class _DetailsFormState extends State<DetailsForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: widget.constraints,
      child: Column(
        children: [
          const Text(
            'Details',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Checkbox(
                value: widget.garageSelected,
                onChanged: widget.onGarageSelectedChanged,
              ),
              const Text('Garage'),
            ],
          ),
          Row(
            children: [
              Checkbox(
                value: widget.outsideParkingSpaceSelected,
                onChanged: widget.onOutsideParkingSpaceSelectedChanged,
              ),
              const Text('Outside parking space'),
            ],
          ),
          Row(
            children: [
              Checkbox(
                value: widget.acceptLargeVehicles,
                onChanged: widget.onAcceptLargeVehiclesChanged,
              ),
              const Text('Available for large vehicles (trucks, RVs etc.)'),
            ],
          ),
          Row(
            children: [
              Checkbox(
                value: widget.accessibility,
                onChanged: widget.onAccessibilityChanged,
              ),
              const Text('Extra wide parking space'),
            ],
          ),
          TextField(
            decoration: const InputDecoration(labelText: 'Additional information'),
            onChanged: widget.onAdditionalInfoChanged,
            maxLines: null,
            controller: TextEditingController(text: widget.additionalInfo),
          ),
        ],
      )
    );
  }
}