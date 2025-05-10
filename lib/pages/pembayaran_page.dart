import 'package:flutter/material.dart';

class PembayaranPage extends StatelessWidget {
  final List<String> tagihan = ["Listrik", "Air", "BPJS", "Internet"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pembayaran"), backgroundColor: Colors.blue[900]),
      body: ListView.separated(
        padding: EdgeInsets.all(16),
        itemCount: tagihan.length,
        separatorBuilder: (_, __) => SizedBox(height: 12),
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.payment),
            title: Text("Bayar ${tagihan[index]}"),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Pembayaran ${tagihan[index]} diproses")),
              );
            },
          );
        },
      ),
    );
  }
}
