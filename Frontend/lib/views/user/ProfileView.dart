import 'package:blockpark/controllers/FetchController.dart';
import 'package:blockpark/widgets/appBar/Header.dart';
import 'package:blockpark/widgets/listings/ListingCard.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  Future<List<dynamic>> futureOwnerParkingSpaces;
  Future<List<dynamic>> futureRenterParkingSpaces;

  ProfileView({
    super.key,
    required this.futureOwnerParkingSpaces, 
    required this.futureRenterParkingSpaces
  });

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final Map<String, bool> _isExpanded = {'Parking spaces as owner': false, 'Parking spaces as renter': false};
  final List<String> _categories = ['Parking spaces as owner', 'Parking spaces as renter'];

  void _fetchParkingSpacesData() async {
    widget.futureOwnerParkingSpaces = FetchController.fetchParkingSpacesByOwner();
    widget.futureRenterParkingSpaces = FetchController.fetchParkingSpacesByRenter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(),
      body: FutureBuilder<List<dynamic>>(
        future: widget.futureOwnerParkingSpaces,
        builder: (context, ownerSnapshot) {
          if (ownerSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (ownerSnapshot.hasError) {
            return Center(child: Text('Error: ${ownerSnapshot.error}'));
          } else {
            List<dynamic> ownerParkingSpaces = ownerSnapshot.data ?? [];

            return FutureBuilder<List<dynamic>>(
              future: widget.futureRenterParkingSpaces,
              builder: (context, renterSnapshot) {
                if (renterSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (renterSnapshot.hasError) {
                  return Center(child: Text('Error: ${renterSnapshot.error}'));
                } else {
                  List<dynamic> renterParkingSpaces = renterSnapshot.data ?? [];

                  return ListView(
                    children: [
                      for (var category in _categories)
                        ExpansionPanelList(
                          expansionCallback: (int index, bool isExpanded) {
                            setState(() {
                              _isExpanded[category] = !isExpanded;
                            });
                          },
                          children: [
                            ExpansionPanel(
                              headerBuilder: (BuildContext context, bool isExpanded) {
                                return ListTile(
                                  title: Text(
                                    category,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _isExpanded[category] = !_isExpanded[category]!;
                                    });
                                  },
                                );
                              },
                              body: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Column(
                                  children: [
                                    if (_isExpanded[category]! && category == 'Parking spaces as owner')
                                      Column(
                                        children: [
                                          ListingCard('Available', ownerParkingSpaces, 'available', _isExpanded, _fetchParkingSpacesData, refreshData),
                                          ListingCard('Rented out', ownerParkingSpaces, 'rented', _isExpanded, _fetchParkingSpacesData, refreshData),
                                          ListingCard('Renting complete', ownerParkingSpaces, 'rentingComplete', _isExpanded, _fetchParkingSpacesData, refreshData),
                                          ListingCard('On hold', ownerParkingSpaces, 'onHold', _isExpanded, _fetchParkingSpacesData, refreshData),
                                          ListingCard('Expired', ownerParkingSpaces, 'expired', _isExpanded, _fetchParkingSpacesData, refreshData),
                                        ],
                                      ),
                                    if (_isExpanded[category]! && category == 'Parking spaces as renter')
                                      Column(
                                        children: [
                                          ListingCard('Current', renterParkingSpaces, 'rented', _isExpanded, _fetchParkingSpacesData, refreshData),
                                          ListingCard('Renting complete', renterParkingSpaces, 'rentingComplete', _isExpanded, _fetchParkingSpacesData, refreshData),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                              isExpanded: _isExpanded[category]!,
                            ),
                          ],
                        ),
                    ],
                  );
                }
              },
            );
          }
        },
      ),
    );
  }

  void refreshData() {
    setState(() {});
  }
}