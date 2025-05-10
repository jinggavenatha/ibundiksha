import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ibundiksha/provider/account_provider.dart';

class TransferPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController rekeningController = TextEditingController();
    TextEditingController nominalController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text("Transfer"), backgroundColor: Colors.blue[900]),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: rekeningController,
              decoration: InputDecoration(labelText: "Nomor Rekening Tujuan"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            TextField(
              controller: nominalController,
              decoration: InputDecoration(labelText: "Nominal Transfer"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[900]),
              onPressed: () {
                double nominal = double.tryParse(nominalController.text) ?? 0;
                if (nominal > 0) {
                  Provider.of<AccountProvider>(context, listen: false)
                      .transfer(nominal, rekeningController.text);

                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text("Transfer Berhasil"),
                      content: Text("Rp ${nominal.toStringAsFixed(2)} telah dikirim ke ${rekeningController.text}"),
                      actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))],
                    ),
                  );
                }
              },
              child: Text("Kirim"),
            ),
          ],
        ),
      ),
    );
  }
}
