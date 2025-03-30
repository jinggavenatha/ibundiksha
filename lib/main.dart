import 'package:flutter/material.dart';
import 'login_page.dart';

void main() {
  runApp(MyApp()); // Hapus const
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mobile Banking Undiksha',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(), // Hapus const
    );
  }
}

