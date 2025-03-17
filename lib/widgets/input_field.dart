import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String label;
  final bool isPassword;

  InputField({required this.label, this.isPassword = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextField(
        obscureText: isPassword,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: label,
        ),
      ),
    );
  }
}
