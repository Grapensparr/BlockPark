import 'package:blockpark/controllers/LoginController.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  final ScaffoldMessengerState scaffoldMessenger;

  const LoginForm({Key? key, required this.scaffoldMessenger}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _isPasswordVisible = false;

  final LoginController controller = LoginController();

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: controller.email,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.person_outline_outlined),
              labelText: 'Email',
              hintText: 'Email',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10,),
          TextFormField(
            controller: controller.password,
            obscureText: !_isPasswordVisible,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.fingerprint),
              labelText: 'Password',
              hintText: 'Password',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
                icon: Icon(
                  _isPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10,),
          Align(
            alignment: Alignment.center,
            child: OutlinedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  controller.loginUser(widget.scaffoldMessenger);
                }
              },
              child: const Text('Login'), 
            ),
          )
        ],
      ),
    );
  }
}