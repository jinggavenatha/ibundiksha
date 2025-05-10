import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ibundiksha/provider/account_provider.dart';

class MutasiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> mutasi = Provider.of<AccountProvider>(context).mutasi;

    return Scaffold(
      appBar: AppBar(title: Text("Mutasi"), backgroundColor: Colors.blue[900]),
      body: ListView.builder(
        itemCount: mutasi.length,
        padding: EdgeInsets.all(16),
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(mutasi[index]),
              leading: Icon(Icons.receipt_long),
            ),
          );
        },
      ),
    );
  }
}
