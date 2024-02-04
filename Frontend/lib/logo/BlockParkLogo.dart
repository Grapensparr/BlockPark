import 'package:blockpark/utils/colors.dart';
import 'package:flutter/material.dart';

class BlockParkLogo extends StatelessWidget {
  const BlockParkLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 2
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'BlockPark',
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    width: 100.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 16, 104, 255),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: const Icon(
                      Icons.directions_car,
                      size: 36.0,
                      color: white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}