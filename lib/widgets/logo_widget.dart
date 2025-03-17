import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset('assets/logo.png', height: 150), // Ganti dengan logo sesuai proyek
        SizedBox(height: 20),
      ],
    );
  }
}
