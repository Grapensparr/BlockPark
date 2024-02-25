import 'package:blockpark/controllers/FetchController.dart';
import 'package:blockpark/views/user/HomeView.dart';
import 'package:flutter/material.dart';

class HomeViewWrapper extends StatefulWidget {
  const HomeViewWrapper({Key? key}) : super(key: key);

  @override
  _HomeViewWrapperState createState() => _HomeViewWrapperState();
}

class _HomeViewWrapperState extends State<HomeViewWrapper> {
  late Future<Map<String, int>> _statusCountsFuture;

  @override
  void initState() {
    super.initState();
    _statusCountsFuture = FetchController.fetchStatusCounts();
  }

  @override
  Widget build(BuildContext context) {
    return HomeView(statusCounts: _statusCountsFuture);
  }
}