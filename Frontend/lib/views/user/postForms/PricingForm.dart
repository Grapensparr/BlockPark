import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PricingForm extends StatefulWidget {
  final String pricePerHour;
  final String paymentSchedule;
  final Function(String) onPricePerHourChanged;
  final Function(String) onPaymentScheduleChanged;
  final BoxConstraints constraints;

  const PricingForm({
    Key? key, 
    required this.pricePerHour,
    required this.paymentSchedule,
    required this.onPricePerHourChanged,
    required this.onPaymentScheduleChanged,
    required this.constraints,
  }) : super(key: key);

  @override
  _PricingFormState createState() => _PricingFormState();
}

class _PricingFormState extends State<PricingForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: widget.constraints,
      child: Column(
        children: [
          const Text(
            'Pricing',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 200,
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Price per hour (ETH)*',
                        hintText: 'Price per hour (ETH)*',
                      ),
                      onChanged: widget.onPricePerHourChanged,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                ],
              ),
            ]
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Payment schedule*:'),
              Column(
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: widget.paymentSchedule == 'fullPayment',
                        onChanged: (value) {
                          widget.onPaymentScheduleChanged('fullPayment');
                        },
                      ),
                      const Text('Single payment'),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: widget.paymentSchedule == 'weekly',
                        onChanged: (value) {
                          widget.onPaymentScheduleChanged('weekly');
                        },
                      ),
                      const Text('Weekly'),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: widget.paymentSchedule == 'biweekly',
                        onChanged: (value) {
                          widget.onPaymentScheduleChanged('biweekly');
                        },
                      ),
                      const Text('Biweekly'),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: widget.paymentSchedule == 'monthly',
                        onChanged: (value) {
                          widget.onPaymentScheduleChanged('monthly');
                        },
                      ),
                      const Text('Monthly'),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      )
    );
  }
}