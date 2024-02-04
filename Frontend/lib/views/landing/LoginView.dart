import 'package:blockpark/logo/BlockParkLogo.dart';
import 'package:blockpark/utils/colors.dart';
import 'package:blockpark/views/landing/SignupView.dart';
import 'package:blockpark/views/landing/forms/LoginForm.dart';
import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Builder(
          builder: (context) {
            final scaffoldMessenger = ScaffoldMessenger.of(context);
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 50,),
                  const BlockParkLogo(),
                  const SizedBox(height: 50,),
                  LoginForm(scaffoldMessenger: scaffoldMessenger),
                  const SizedBox(height: 20,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40,),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SignupView()),
                          );
                        },
                        child: const Text.rich(
                          TextSpan(
                            text: "Don't have an account? ",
                            children: [
                              TextSpan(
                                text: 'Sign up now!',
                                style: TextStyle(
                                  color: primaryGreen,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        )
      )
    );
  }
}