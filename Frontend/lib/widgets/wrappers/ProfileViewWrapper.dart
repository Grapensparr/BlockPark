import 'package:blockpark/controllers/FetchController.dart';
import 'package:blockpark/views/user/ProfileView.dart';
import 'package:flutter/material.dart';

class ProfileViewWrapper extends StatefulWidget {
  const ProfileViewWrapper({Key? key}) : super(key: key);

  @override
  _ProfileViewWrapperState createState() => _ProfileViewWrapperState();
}

class _ProfileViewWrapperState extends State<ProfileViewWrapper> {
  late Future<List<dynamic>> _futureOwnerParkingSpaces;
  late Future<List<dynamic>> _futureRenterParkingSpaces;

  @override
  void initState() {
    super.initState();
    _futureOwnerParkingSpaces = FetchController.fetchParkingSpacesByOwner();
    _futureRenterParkingSpaces = FetchController.fetchParkingSpacesByRenter();
  }

  @override
  Widget build(BuildContext context) {
    return ProfileView(
      futureOwnerParkingSpaces: _futureOwnerParkingSpaces, 
      futureRenterParkingSpaces: _futureRenterParkingSpaces
    );
  }
}