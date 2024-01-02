import 'package:blockpark/utils/colors.dart';
import "package:flutter/material.dart";

class NavigationRailWidget extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onDestinationSelected;
  final List<Widget> screens;

  const NavigationRailWidget(
    {
      super.key,
      required this.selectedIndex,
      required this.onDestinationSelected,
      required this.screens
    }
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (MediaQuery.of(context).size.width > 640)
          NavigationRail(
            destinations: const [
              NavigationRailDestination(icon: Icon(Icons.home), label: Text("Home")),
              NavigationRailDestination(icon: Icon(Icons.edit), label: Text("Post")),
              NavigationRailDestination(icon: Icon(Icons.search), label: Text("Search")),
              NavigationRailDestination(icon: Icon(Icons.person), label: Text("Profile")),
            ],
            labelType: NavigationRailLabelType.all,
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            backgroundColor: white,
            indicatorColor: white,
            selectedIconTheme: const IconThemeData(color: primaryGreen),
            unselectedIconTheme: const IconThemeData(color: grey),
            selectedLabelTextStyle: const TextStyle(color: primaryGreen),
            unselectedLabelTextStyle: const TextStyle(color: grey),
          ),
        Expanded(child: screens[selectedIndex])
      ],
    );
  }
}