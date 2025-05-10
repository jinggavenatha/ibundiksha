import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ibundiksha/provider/account_provider.dart';

class CekSaldoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double saldo = Provider.of<AccountProvider>(context).saldo;
    
    return Scaffold(
      appBar: AppBar(title: Text("Cek Saldo"), backgroundColor: Colors.blue[900]),
      body: Center(
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Total Saldo Anda", style: TextStyle(fontSize: 18)),
                SizedBox(height: 10),
                Text("Rp ${saldo.toStringAsFixed(2)}", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue[800])),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
