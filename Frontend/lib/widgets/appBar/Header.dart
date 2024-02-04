import 'package:blockpark/providers/AuthProvider.dart';
import 'package:blockpark/routing/LandingRouting.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 2.0,
          ),
        ),
      ),
      child: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "BlockPark",
        ),
        centerTitle: true,
        actions: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  final authProvider = Provider.of<AuthProvider>(context, listen: false);
                  authProvider.logout();

                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const LandingRouting(),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}