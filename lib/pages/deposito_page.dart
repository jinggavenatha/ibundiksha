import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ibundiksha/provider/account_provider.dart';

class DepositoPage extends StatefulWidget {
  @override
  _DepositoPageState createState() => _DepositoPageState();
}

class _DepositoPageState extends State<DepositoPage> {
  final TextEditingController jumlahController = TextEditingController();
  final TextEditingController bungaController = TextEditingController(
    text: "5.0",
  );
  final TextEditingController tenorController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  // Pilihan tenor
  final List<int> tenorOptions = [1, 3, 6, 12, 24];
  int selectedTenor = 6; // Default tenor

  @override
  void initState() {
    super.initState();
    tenorController.text = selectedTenor.toString();

    // Listener untuk memperbarui simulasi saat jumlah atau bunga berubah
    jumlahController.addListener(() {
      setState(() {});
    });
    bungaController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    jumlahController.dispose();
    bungaController.dispose();
    tenorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AccountProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Deposito"),
        backgroundColor: Colors.blue[900],
      ),
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
                      Icon(
                        Icons.account_balance_wallet,
                        color: Colors.blue[800],
                      ),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Saldo Tersedia",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            "Rp ${provider.saldo.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              Text(
                "Informasi Deposito",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 16),

              // Jumlah Deposito
              TextFormField(
                controller: jumlahController,
                decoration: InputDecoration(
                  labelText: "Jumlah Deposito (Rp)",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.savings),
                  prefixText: "Rp ",
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jumlah deposito tidak boleh kosong';
                  }
                  double? jumlah = double.tryParse(value);
                  if (jumlah == null) {
                    return 'Masukkan angka yang benar';
                  }
                  if (jumlah <= 0) {
                    return 'Jumlah deposito harus lebih dari 0';
                  }
                  if (jumlah < 10000) {
                    return 'Minimum deposito adalah Rp. 10.000';
                  }
                  if (jumlah > provider.saldo) {
                    return 'Saldo tidak mencukupi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Tenor Selection
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Pilih Jangka Waktu",
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children:
                        tenorOptions.map((tenor) {
                          return ChoiceChip(
                            label: Text("$tenor bulan"),
                            selected: selectedTenor == tenor,
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  selectedTenor = tenor;
                                  tenorController.text = tenor.toString();
                                });
                              }
                            },
                          );
                        }).toList(),
                  ),
                ],
              ),

              SizedBox(height: 16),

              // Bunga
              TextFormField(
                controller: bungaController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Bunga (%)",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.percent),
                  suffixText: "% per tahun",
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                keyboardType: TextInputType.number,
              ),

              SizedBox(height: 32),

              // Perhitungan Bunga (informasi)
              _buildBungaSimulation(),

              SizedBox(height: 32),

              // Deposito Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[900],
                    foregroundColor: Colors.white,
                  ),
                  onPressed:
                      isLoading
                          ? null
                          : () {
                            if (_formKey.currentState!.validate()) {
                              _showConfirmationDialog();
                            }
                          },
                  child:
                      isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                            "Buat Deposito",
                            style: TextStyle(fontSize: 16),
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBungaSimulation() {
    double pokok = double.tryParse(jumlahController.text) ?? 0;
    double bunga = double.tryParse(bungaController.text) ?? 0;
    if (pokok <= 0 || bunga <= 0) {
      return Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Masukkan jumlah dan bunga yang valid untuk melihat simulasi.",
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
      );
    }
    double bungaNominal = pokok * (bunga / 100) * (selectedTenor / 12);
    double total = pokok + bungaNominal;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Simulasi Deposito",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            _detailRow("Pokok", "Rp ${pokok.toStringAsFixed(2)}"),
            _detailRow("Tenor", "$selectedTenor bulan"),
            _detailRow("Bunga", "$bunga% per tahun"),
            _detailRow(
              "Bunga diterima",
              "Rp ${bungaNominal.toStringAsFixed(2)}",
            ),
            Divider(),
            _detailRow(
              "Total saat jatuh tempo",
              "Rp ${total.toStringAsFixed(2)}",
              TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value, [TextStyle? valueStyle]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: valueStyle ?? TextStyle()),
        ],
      ),
    );
  }

  void _showConfirmationDialog() {
    double jumlah = double.tryParse(jumlahController.text) ?? 0;
    double bunga = double.tryParse(bungaController.text) ?? 0;
    double bungaNominal = jumlah * (bunga / 100) * (selectedTenor / 12);
    double total = jumlah + bungaNominal;

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text("Konfirmasi Deposito"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Pastikan detail deposito sudah benar:"),
                SizedBox(height: 16),
                _detailRow("Jumlah Pokok", "Rp ${jumlah.toStringAsFixed(2)}"),
                _detailRow("Tenor", "$selectedTenor bulan"),
                _detailRow("Bunga", "$bunga% per tahun"),
                _detailRow(
                  "Bunga diterima",
                  "Rp ${bungaNominal.toStringAsFixed(2)}",
                ),
                Divider(),
                _detailRow(
                  "Total saat jatuh tempo",
                  "Rp ${total.toStringAsFixed(2)}",
                  TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text(
                  "Catatan: Dana akan dikunci selama $selectedTenor bulan.",
                  style: TextStyle(
                    color: Colors.red[700],
                    fontStyle: FontStyle.italic,
                  ),
                ),
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
                  _processDeposito();
                },
                child: Text("Konfirmasi"),
              ),
            ],
          ),
    );
  }

  void _processDeposito() {
    setState(() {
      isLoading = true;
    });

    // Simulasi proses backend
    Future.delayed(Duration(seconds: 1), () {
      double jumlah = double.tryParse(jumlahController.text) ?? 0;
      double bunga = double.tryParse(bungaController.text) ?? 0;

      // Lakukan deposito
      bool success = Provider.of<AccountProvider>(
        context,
        listen: false,
      ).deposito(jumlah, bunga, selectedTenor);

      setState(() {
        isLoading = false;
      });

      if (success) {
        _showSuccessDialog(jumlah);
      } else {
        _showErrorDialog();
      }
    });
  }

  void _showSuccessDialog(double jumlah) {
    double bunga = double.tryParse(bungaController.text) ?? 0;
    double bungaNominal = jumlah * (bunga / 100) * (selectedTenor / 12);
    double total = jumlah + bungaNominal;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Text("Deposito Berhasil"),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Deposito sebesar Rp ${jumlah.toStringAsFixed(2)} berhasil dibuat",
                ),
                SizedBox(height: 8),
                Text("Pada tanggal jatuh tempo, Anda akan menerima:"),
                SizedBox(height: 4),
                Text(
                  "Rp ${total.toStringAsFixed(2)}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
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
      builder:
          (_) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.error, color: Colors.red),
                SizedBox(width: 8),
                Text("Deposito Gagal"),
              ],
            ),
            content: Text(
              "Saldo tidak mencukupi atau terjadi kesalahan sistem.",
            ),
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