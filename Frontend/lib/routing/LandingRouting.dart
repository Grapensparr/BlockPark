import 'package:blockpark/logo/BlockParkLogo.dart';
import 'package:blockpark/views/landing/LoginView.dart';
import 'package:blockpark/views/landing/SignupView.dart';
import 'package:flutter/material.dart';

class LandingRouting extends StatelessWidget {
  const LandingRouting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const BlockParkLogo(),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoginView()));
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(150, 60),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(width: 40),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SignupView()));
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(150, 60),
                  ),
                  child: const Text(
                    'Sign up',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}