import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ibundiksha/provider/account_provider.dart';

class DepositoPage extends StatelessWidget {
  final TextEditingController jumlahController = TextEditingController();
  final TextEditingController bungaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Deposito"), backgroundColor: Colors.blue[900]),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: jumlahController,
              decoration: InputDecoration(labelText: "Jumlah Deposito (Rp)"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            TextField(
              controller: bungaController,
              decoration: InputDecoration(labelText: "Bunga (%)"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[900]),
              onPressed: () {
                double jumlah = double.tryParse(jumlahController.text) ?? 0;
                double bunga = double.tryParse(bungaController.text) ?? 0;

                if (jumlah > 0 && bunga > 0) {
                  Provider.of<AccountProvider>(context, listen: false)
                      .deposito(jumlah, bunga);

                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text("Deposito Berhasil"),
                      content: Text("Deposito Rp ${jumlah.toStringAsFixed(2)} dengan bunga $bunga% telah dilakukan."),
                      actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))],
                    ),
                  );
                }
              },
              child: Text("Deposit"),
            ),
          ],
        ),
      ),
    );
  }
}
