import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ibundiksha/provider/account_provider.dart';

class CekSaldoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double saldo = Provider.of<AccountProvider>(context).saldo;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cek Saldo"),
        backgroundColor: Colors.blue.shade900,
        centerTitle: true,
      ),
      backgroundColor: Colors.grey.shade100,
      body: Center(
        child: Card(
          elevation: 6,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.account_balance_wallet_rounded,
                    size: 48, color: Colors.blue.shade800),
                const SizedBox(height: 16),
                const Text(
                  "Total Saldo Anda",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Rp ${saldo.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
