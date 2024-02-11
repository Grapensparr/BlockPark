import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddressForm extends StatelessWidget {
  final Function(String) onAddressChanged;
  final Function(String) onZipCodeChanged;
  final Function(String) onCityChanged;
  final BoxConstraints constraints;

  const AddressForm({
    Key? key,
    required this.onAddressChanged,
    required this.onZipCodeChanged,
    required this.onCityChanged,
    required this.constraints,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: constraints,
      child: Column(
        children: [
          const Text(
            'Address',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Address*',
              hintText: 'Address*',
              border: OutlineInputBorder(),
            ),
            onChanged: onAddressChanged,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Zip code*',
                    hintText: 'Zip code*',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: onZipCodeChanged,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'City*',
                    hintText: 'City*',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: onCityChanged,
                ),
              ),
            ],
          ),
        ],
      )
    );
  }
}