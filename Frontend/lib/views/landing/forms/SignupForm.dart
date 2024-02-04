import 'package:blockpark/controllers/SignupController.dart';
import 'package:flutter/material.dart';

class SignupForm extends StatefulWidget {
  final ScaffoldMessengerState scaffoldMessenger;

  const SignupForm({Key? key, required this.scaffoldMessenger}) : super(key: key);

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  bool _isPasswordVisible = false;
  DateTime? selectedDate;

  final SignupController controller = SignupController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    ))!;

    if (picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        controller.dateOfBirth.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: controller.fullName,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.person_outline_outlined),
              labelText: 'Full name',
              hintText: 'Full name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10,),
          InkWell(
            onTap: () {
              _selectDate(context);
            },
            child: IgnorePointer(
              child: TextFormField(
                controller: controller.dateOfBirth,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person_outline_outlined),
                  labelText: 'Date of birth',
                  hintText: 'Date of birth',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10,),
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
          TextFormField(
            obscureText: !_isPasswordVisible,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.fingerprint),
              labelText: 'Confirm password',
              hintText: 'Confirm password',
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
                  controller.registerUser(widget.scaffoldMessenger);
                }
              },
              child: const Text('Sign up'),
            ),
          )
        ],
      ),
    );
  }
}