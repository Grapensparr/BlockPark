import 'package:blockpark/controllers/FetchController.dart';
import 'package:blockpark/views/user/ChatDetails.dart';
import 'package:blockpark/views/user/ChatView.dart';
import 'package:blockpark/views/user/HomeView.dart';
import 'package:blockpark/views/user/PostView.dart';
import 'package:blockpark/views/user/ProfileView.dart';
import 'package:blockpark/views/user/SearchView.dart';
import 'package:blockpark/widgets/navigation/BottomNavigation.dart';
import 'package:blockpark/widgets/navigation/NavigationRail.dart';
import 'package:flutter/material.dart';

class UserRouting extends StatefulWidget {
  static final GlobalKey<_UserRoutingState> userRoutingKey =
    GlobalKey<_UserRoutingState>();

  const UserRouting({Key? key}) : super(key: key);

  @override
  _UserRoutingState createState() => _UserRoutingState();
}

class _UserRoutingState extends State<UserRouting> {
  final List<Widget> _screens = [
    HomeView(
      statusCounts: FetchController.fetchStatusCounts()
    ),
    const PostView(),
    const SearchView(),
    const ChatView(),
    ProfileView(
      futureOwnerParkingSpaces: FetchController.fetchParkingSpacesByOwner(),
      futureRenterParkingSpaces: FetchController.fetchParkingSpacesByRenter()
    )
  ];

  int _selectedIndex = 0;
  String _chatId = '';
  bool _isChatOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onTabTapped: (int index) {
          setState(() {
            _selectedIndex = index;
            _isChatOpen = false;
          });
        },
      ),
      body: Stack(
        children: [
          NavigationRailWidget(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
                _isChatOpen = false;
              });
            },
            screens: _screens,
          ),
          if (_isChatOpen)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: ChatDetails(
                onClose: () {
                  setState(() {
                    _isChatOpen = false;
                  });
                  Navigator.pop(context, true);
                },
                chatId: _chatId,
              ),
            ),
        ],
      ),
    );
  }

  void updateChatId(String id) {
    setState(() {
      _chatId = id;
      _isChatOpen = true;
    });
  }
}