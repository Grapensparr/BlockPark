import 'package:blockpark/views/HomeView.dart';
import 'package:blockpark/views/PostView.dart';
import 'package:blockpark/views/ProfileView.dart';
import 'package:blockpark/views/SearchView.dart';
import 'package:blockpark/views/landing/LoginView.dart';
import 'package:blockpark/views/landing/SignupView.dart';
import 'package:blockpark/widgets/navigation/BottomNavigation.dart';
import 'package:blockpark/widgets/navigation/NavigationRail.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final List<Widget> _screens = [
    const SignupView(),
    const LoginView(),
    const HomeView(),
    const PostView(),
    //const SearchView(),
    //const ProfileView(),
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