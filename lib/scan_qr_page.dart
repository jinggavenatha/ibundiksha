import 'package:flutter/material.dart';

class ScanQRPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scan QR Code"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text(
          "Fitur Scan QR akan segera hadir!",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
