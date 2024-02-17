import 'package:blockpark/controllers/FetchController.dart';
import 'package:blockpark/widgets/appBar/Header.dart';
import 'package:blockpark/widgets/listings/ListingCard.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late Future<List<dynamic>> _futureParkingSpaces;
  final Map<String, bool> _isExpanded = {};

  @override
  void initState() {
    super.initState();
    _fetchParkingSpacesData();
  }

  void _fetchParkingSpacesData() {
    _futureParkingSpaces = FetchController.fetchParkingSpacesByOwner();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(),
      body: FutureBuilder<List<dynamic>>(
        future: _futureParkingSpaces,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<dynamic> parkingSpaces = snapshot.data ?? [];
            return ListView(
              children: [
                ListingCard('Available', parkingSpaces, 'available', _isExpanded, _fetchParkingSpacesData, refreshData),
                ListingCard('Rented out', parkingSpaces, 'rented', _isExpanded, _fetchParkingSpacesData, refreshData),
                ListingCard('Renting complete', parkingSpaces, 'rentingComplete', _isExpanded, _fetchParkingSpacesData, refreshData),
                ListingCard('On hold', parkingSpaces, 'onHold', _isExpanded, _fetchParkingSpacesData, refreshData),
                ListingCard('Expired', parkingSpaces, 'expired', _isExpanded, _fetchParkingSpacesData, refreshData),
              ],
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