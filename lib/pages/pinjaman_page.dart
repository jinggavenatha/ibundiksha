import 'package:flutter/material.dart';

class PinjamanPage extends StatelessWidget {
  final TextEditingController jumlahController = TextEditingController();
  final TextEditingController tenorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pinjaman"), backgroundColor: Colors.blue[900]),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: jumlahController,
              decoration: InputDecoration(labelText: "Jumlah Pinjaman (Rp)"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            TextField(
              controller: tenorController,
              decoration: InputDecoration(labelText: "Tenor (bulan)"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[900]),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text("Pengajuan Diterima"),
                    content: Text("Pinjaman Rp ${jumlahController.text} untuk ${tenorController.text} bulan telah diajukan."),
                    actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))],
                  ),
                );
              },
              child: Text("Ajukan Pinjaman"),
            ),
          ],
        ),
      ),
    );
  }
}
