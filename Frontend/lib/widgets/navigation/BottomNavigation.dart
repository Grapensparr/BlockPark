import "package:blockpark/utils/colors.dart";
import "package:flutter/material.dart";

class BottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabTapped;

  const BottomNavigation(
    {
      super.key,
      required this.selectedIndex,
      required this.onTabTapped
    }
  );

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).size.width < 640
      ? BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,

        selectedItemColor: primaryGreen,
        selectedFontSize: 14,

        unselectedItemColor: grey,
        unselectedFontSize: 12,

        onTap: onTabTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: "Post"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      )
    : const SizedBox();
  }
}