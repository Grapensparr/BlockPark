import 'package:blockpark/views/user/ChatView.dart';
import 'package:blockpark/views/user/HomeView.dart';
import 'package:blockpark/views/user/PostView.dart';
import 'package:blockpark/views/user/ProfileView.dart';
import 'package:blockpark/views/user/SearchView.dart';
import 'package:blockpark/widgets/navigation/BottomNavigation.dart';
import 'package:blockpark/widgets/navigation/NavigationRail.dart';
import 'package:flutter/material.dart';

class UserRouting extends StatefulWidget {
  const UserRouting({super.key});

  @override
  _UserRoutingState createState() => _UserRoutingState();
}

class _UserRoutingState extends State<UserRouting> {
  final List<Widget> _screens = [
    const HomeView(),
    const PostView(),
    const SearchView(),
    const ChatView(),
    const ProfileView()
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onTabTapped: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: NavigationRailWidget(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        screens: _screens,
      ),
    );
  }
}