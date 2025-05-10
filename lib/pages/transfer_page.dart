import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ibundiksha/provider/account_provider.dart';

class TransferPage extends StatefulWidget {
  @override
  _TransferPageState createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  final TextEditingController rekeningController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nominalController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AccountProvider>(context);
    
    return Scaffold(
      appBar: AppBar(title: Text("Transfer"), backgroundColor: Colors.blue[900]),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Saldo Information
              Card(
                margin: EdgeInsets.only(bottom: 24),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.account_balance_wallet, color: Colors.blue[800]),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Saldo Anda", style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                          Text(
                            "Rp ${provider.saldo.toStringAsFixed(2)}", 
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              
              Text("Detail Penerima", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 16),
              
              // Rekening Field
              TextFormField(
                controller: rekeningController,
                decoration: InputDecoration(
                  labelText: "Nomor Rekening Tujuan",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.account_balance),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor rekening tidak boleh kosong';
                  }
                  if (value.length < 5) {
                    return 'Nomor rekening tidak valid';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              
              // Nama Penerima Field
              TextFormField(
                controller: namaController,
                decoration: InputDecoration(
                  labelText: "Nama Penerima",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama penerima tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              
              Text("Detail Transfer", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 16),
              
              // Nominal Field
              TextFormField(
                controller: nominalController,
                decoration: InputDecoration(
                  labelText: "Nominal Transfer",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                  prefixText: "Rp ",
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nominal tidak boleh kosong';
                  }
                  double? nominal = double.tryParse(value);
                  if (nominal == null || nominal <= 0) {
                    return 'Nominal harus lebih dari 0';
                  }
                  if (nominal > provider.saldo) {
                    return 'Saldo tidak mencukupi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32),
              
              // Transfer Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[900],
                    foregroundColor: Colors.white,
                  ),
                  onPressed: isLoading ? null : () {
                    if (_formKey.currentState!.validate()) {
                      _showConfirmationDialog();
                    }
                  },
                  child: isLoading 
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Transfer Sekarang", style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showConfirmationDialog() {
    double nominal = double.tryParse(nominalController.text) ?? 0;
    
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Konfirmasi Transfer"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Pastikan detail transfer sudah benar:"),
            SizedBox(height: 16),
            _detailRow("Rekening Tujuan", rekeningController.text),
            _detailRow("Nama Penerima", namaController.text),
            _detailRow("Nominal", "Rp ${nominal.toStringAsFixed(2)}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[900],
            ),
            onPressed: () {
              Navigator.pop(context);
              _processTransfer();
            },
            child: Text("Konfirmasi"),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: TextStyle(color: Colors.grey[600])),
          ),
          Expanded(
            flex: 3,
            child: Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _processTransfer() {
    setState(() {
      isLoading = true;
    });

    // Simulasi proses backend
    Future.delayed(Duration(seconds: 1), () {
      double nominal = double.tryParse(nominalController.text) ?? 0;
      String rekening = rekeningController.text;
      String nama = namaController.text;
      
      // Lakukan transfer
      bool success = Provider.of<AccountProvider>(context, listen: false)
          .transfer(nominal, "$rekening (${nama})");

      setState(() {
        isLoading = false;
      });

      if (success) {
        _showSuccessDialog(nominal, nama);
      } else {
        _showErrorDialog();
      }
    });
  }

  void _showSuccessDialog(double nominal, String nama) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text("Transfer Berhasil"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Rp ${nominal.toStringAsFixed(2)} telah dikirim ke $nama"),
            SizedBox(height: 12),
            Text("Transaksi telah dicatat dalam mutasi rekening Anda."),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[900],
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Kembali ke halaman utama
            },
            child: Text("Selesai"),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.error, color: Colors.red),
            SizedBox(width: 8),
            Text("Transfer Gagal"),
          ],
        ),
        content: Text("Saldo tidak mencukupi atau terjadi kesalahan sistem."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }
}