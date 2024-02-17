import 'package:blockpark/controllers/UpdateController.dart';
import 'package:flutter/material.dart';

class ListingCard extends StatelessWidget {
  final String headerText;
  final List<dynamic> parkingSpaces;
  final String status;
  final Map<String, bool> isExpanded;
  final Function() fetchParkingSpacesData;
  final VoidCallback refreshData;

  const ListingCard(this.headerText, this.parkingSpaces, this.status, this.isExpanded, this.fetchParkingSpacesData, this.refreshData, {super.key});

  @override
  Widget build(BuildContext context) {
    List<dynamic> filteredListings = parkingSpaces.where((listing) => listing['status'] == status).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            headerText,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        for (var listing in filteredListings)
          ExpansionTile(
            title: Text('Address: ${listing['address']}, ${listing['zipCode']}, ${listing['city']}'),
            initiallyExpanded: isExpanded[listing['_id']] ?? false,
            onExpansionChanged: (value) {
              final updatedIsExpandedMap = {...isExpanded};
              updatedIsExpandedMap[listing['_id']] = value;
            },
            children: [
              ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (listing['renter'] != null)
                      Text(
                        'Renter: ${listing['renter']}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    Text(
                      'Start date: ${_formatDate(listing['startDate'])}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(
                      'End date: ${_formatEndDate(listing['endDate'])}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const Text(
                      'Availability:',
                      style: TextStyle(fontSize: 14),
                    ),
                    for (var day in listing['dayTimes'].keys)
                      if (listing['dayTimes'][day]['start'] != '00:00' && listing['dayTimes'][day]['end'] != '00:00')
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            '$day: ${listing['dayTimes'][day]['start']} - ${listing['dayTimes'][day]['end']}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                    Text(
                      'Price: ${listing['price']}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(
                      'Payment schedule: ${_formatPaymentSchedule(listing['paymentSchedule'])}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(
                      'Garage: ${listing['isGarage'] ? 'Yes' : 'No'}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(
                      'Outside parking space: ${listing['isParkingSpace'] ? 'Yes' : 'No'}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(
                      'Extra wide parking space: ${listing['accessibility'] ? 'Yes' : 'No'}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(
                      'Accepts large vehicles: ${listing['largeVehicles'] ? 'Yes' : 'No'}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    if (listing['review'] != null)
                      Text(
                        'Review: ${listing['review']}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    if (listing['rating'] != null)
                      Text(
                        'Rating: ${listing['rating']}',
                        style: const TextStyle(fontSize: 14),
                      ),
                  ],
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              ),
              if (listing['status'] == 'available')
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 90,
                          child: ElevatedButton(
                            onPressed: () {
                              
                            },
                            child: const Text('Edit'),
                          ),
                        ),
                        SizedBox(
                          width: 90,
                          child: ElevatedButton(
                            onPressed: () async {
                              await UpdateController.updateParkingStatus('${listing['_id']}', 'onHold', context);
                              fetchParkingSpacesData();
                              refreshData();
                            },
                            child: const Text('Pause'),
                          ),
                        ),
                        SizedBox(
                          width: 90,
                          child: ElevatedButton(
                            onPressed: () async {
                              await UpdateController.removeEntry('${listing['_id']}', context);
                              fetchParkingSpacesData();
                              refreshData();
                            },
                            child: const Text('Delete'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (listing['status'] == 'onHold')
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 90,
                          child: ElevatedButton(
                            onPressed: () {
                              
                            },
                            child: const Text('Edit'),
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: ElevatedButton(
                            onPressed: () async {
                              await UpdateController.updateParkingStatus('${listing['_id']}', 'available', context);
                              fetchParkingSpacesData();
                              refreshData();
                            },
                            child: const Text('Activate'),
                          ),
                        ),
                        SizedBox(
                          width: 90,
                          child: ElevatedButton(
                            onPressed: () async {
                              await UpdateController.removeEntry('${listing['_id']}', context);
                              fetchParkingSpacesData();
                              refreshData();
                            },
                            child: const Text('Delete'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        const Divider(),
      ],
    );
  }

  String? _formatDate(String? date) {
    return date?.split('T')[0];
  }

  String _formatEndDate(String? endDate) {
    return endDate != null ? endDate.split('T')[0] : 'Until further notice';
  }

  String _formatPaymentSchedule(String paymentSchedule) {
    if (paymentSchedule == 'fullPayment') {
      return 'Full payment';
    } else {
      return paymentSchedule[0].toUpperCase() + paymentSchedule.substring(1);
    }
  }
}