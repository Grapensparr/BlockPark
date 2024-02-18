import 'package:flutter/material.dart';

class SearchCard extends StatelessWidget {
  final Map<String, dynamic> searchData;

  const SearchCard(this.searchData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String address = searchData['address'] ?? 'Address Not Available';
    String zipCode = searchData['zipCode'] ?? 'Zip Code Not Available';
    String city = searchData['city'] ?? 'City Not Available';
    String endDate = searchData['endDate'] != null ? searchData['endDate'].toString().split('T')[0] : 'Until further notice';
    double price = searchData['price'] ?? 0;
    String paymentSchedule = _formatPaymentSchedule(searchData['paymentSchedule']);
    bool isGarage = searchData['isGarage'] ?? false;
    bool isParkingSpace = searchData['isParkingSpace'] ?? false;
    bool accessibility = searchData['accessibility'] ?? false;
    bool largeVehicles = searchData['largeVehicles'] ?? false;
    Map<String, dynamic> dayTimes = searchData['dayTimes'] ?? {};

    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$address, $zipCode, $city',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'End date: $endDate',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Price per hour: $price ETH',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Payment schedule: $paymentSchedule',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              isGarage ? 'Garage' : (isParkingSpace ? 'Outside parking space' : ''),
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            if (accessibility)
              const Text(
                'Extra wide parking space',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            const SizedBox(height: 4),
            if (largeVehicles)
              const Text(
                'Accepts large vehicles',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            const SizedBox(height: 8),
            const Text(
              'Availability:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: dayTimes.entries.map((entry) {
                String day = entry.key;
                String startTime = entry.value['start'];
                String endTime = entry.value['end'];
                return Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    '$day: $startTime - $endTime',
                    style: const TextStyle(fontSize: 16),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  
                },
                child: const Text('Contact Owner'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatPaymentSchedule(String? paymentSchedule) {
    if (paymentSchedule == 'fullPayment') {
      return 'Full payment';
    } else if (paymentSchedule != null && paymentSchedule.isNotEmpty) {
      return paymentSchedule[0].toUpperCase() + paymentSchedule.substring(1);
    } else {
      return 'Payment schedule not available';
    }
  }
}