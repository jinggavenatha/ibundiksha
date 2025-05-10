import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ibundiksha/provider/account_provider.dart';

class PinjamanPage extends StatefulWidget {
  @override
  _PinjamanPageState createState() => _PinjamanPageState();
}

class _PinjamanPageState extends State<PinjamanPage> {
  final TextEditingController jumlahController = TextEditingController();
  final TextEditingController tenorController = TextEditingController();
  final TextEditingController tujuanController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  double bungaRate = 10.0; // Default bunga rate (%)

  // Opsi tenor diperbarui sesuai permintaan
  final List<int> tenorOptions = [1, 3, 6, 12, 24];
  int selectedTenor = 3; // Default tenor diubah ke 3 bulan

  @override
  void initState() {
    super.initState();
    tenorController.text = selectedTenor.toString();
    jumlahController.addListener(() {
      setState(() {
        // Memperbarui UI saat input jumlah berubah
      });
    });
  }

  @override
  void dispose() {
    jumlahController.dispose();
    tenorController.dispose();
    tujuanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AccountProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Pengajuan Pinjaman"),
        backgroundColor: Colors.blue[900],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Data Diri Section Card
              Card(
                margin: EdgeInsets.only(bottom: 24),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Data Peminjam",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage('assets/profile.png'),
                          ),
                          SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Jingga Venatha Lisdabrani",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              Text("No. Anggota: 1234567890",
                                  style: TextStyle(color: Colors.grey[600])),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              Text("Informasi Pinjaman",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 16),

              // Jumlah Pinjaman
              TextFormField(
                controller: jumlahController,
                decoration: InputDecoration(
                  labelText: "Jumlah Pinjaman (Rp)",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                  prefixText: "Rp ",
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jumlah pinjaman tidak boleh kosong';
                  }
                  double? jumlah = double.tryParse(value);
                  if (jumlah == null || jumlah <= 0) {
                    return 'Jumlah pinjaman harus lebih dari 0';
                  }
                  if (jumlah < 1000000) {
                    return 'Minimum pinjaman Rp. 1.000.000';
                  }
                  if (jumlah > 100000000) {
                    return 'Maximum pinjaman Rp. 100.000.000';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Tenor Selection
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Pilih Jangka Waktu",
                      style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: tenorOptions.map((tenor) {
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

              // Tujuan Pinjaman
              TextFormField(
                controller: tujuanController,
                decoration: InputDecoration(
                  labelText: "Tujuan Pinjaman",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tujuan pinjaman tidak boleh kosong';
                  }
                  return null;
                },
              ),

              SizedBox(height: 32),

              // Perhitungan Bunga (informasi)
              _buildPinjamanSimulation(),

              SizedBox(height: 24),

              // Disclaimer
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange[300]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Catatan Penting:",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.orange[800]),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Pengajuan pinjaman akan diproses dalam 1-3 hari kerja. Anda akan mendapatkan notifikasi setelah pinjaman disetujui.",
                      style: TextStyle(fontSize: 13, color: Colors.orange[800]),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 32),

              // Ajukan Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[900],
                    foregroundColor: Colors.white,
                  ),
                  onPressed: isLoading
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            _showConfirmationDialog(provider);
                          }
                        },
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text("Ajukan Pinjaman", style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPinjamanSimulation() {
    double pokok = double.tryParse(jumlahController.text) ?? 0;
    if (pokok <= 0) {
      return Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Masukkan jumlah pinjaman yang valid untuk melihat simulasi.",
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
      );
    }

    double bungaPerTahun = bungaRate / 100;
    double bungaTotal = pokok * bungaPerTahun * (selectedTenor / 12);
    double total = pokok + bungaTotal;
    double angsuranPerBulan = total / selectedTenor;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Simulasi Pinjaman", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            _detailRow("Pokok Pinjaman", "Rp ${pokok.toStringAsFixed(0)}"),
            _detailRow("Tenor", "$selectedTenor bulan"),
            _detailRow("Bunga", "$bungaRate% per tahun"),
            _detailRow("Total Bunga", "Rp ${bungaTotal.toStringAsFixed(0)}"),
            Divider(),
            _detailRow("Total Pengembalian", "Rp ${total.toStringAsFixed(0)}",
                TextStyle(fontWeight: FontWeight.bold)),
            _detailRow("Angsuran per Bulan", "Rp ${angsuranPerBulan.toStringAsFixed(0)}",
                TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[800])),
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

  void _showConfirmationDialog(AccountProvider provider) {
    double jumlah = double.tryParse(jumlahController.text) ?? 0;
    String tujuan = tujuanController.text;
    double bungaTotal = jumlah * (bungaRate / 100) * (selectedTenor / 12);
    double total = jumlah + bungaTotal;
    double angsuranPerBulan = total / selectedTenor;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Konfirmasi Pengajuan"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Pastikan detail pinjaman sudah benar:"),
            SizedBox(height: 16),
            _detailRow("Jumlah Pinjaman", "Rp ${jumlah.toStringAsFixed(0)}"),
            _detailRow("Tenor", "$selectedTenor bulan"),
            _detailRow("Tujuan", tujuan),
            _detailRow("Angsuran/Bulan", "Rp ${angsuranPerBulan.toStringAsFixed(0)}"),
            SizedBox(height: 16),
            Text(
              "Dengan mengajukan pinjaman ini, Anda setuju dengan ketentuan yang berlaku.",
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
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
              _processPinjaman(provider);
            },
            child: Text("Konfirmasi"),
          ),
        ],
      ),
    );
  }

  void _processPinjaman(AccountProvider provider) {
    setState(() {
      isLoading = true;
    });

    // Simulate backend process
    Future.delayed(Duration(seconds: 1), () {
      double jumlah = double.tryParse(jumlahController.text) ?? 0;

      // Process loan application
      provider.ajukanPinjaman(jumlah, selectedTenor);

      // Simulasi persetujuan pinjaman (langsung disetujui untuk contoh ini)
      provider.setujuiPinjaman(jumlah);

      setState(() {
        isLoading = false;
      });

      _showSuccessDialog(jumlah);
    });
  }

  void _showSuccessDialog(double jumlah) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text("Pengajuan Berhasil"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Pengajuan pinjaman sebesar Rp ${jumlah.toStringAsFixed(0)} telah diterima."),
            SizedBox(height: 12),
            Text(
              "Kami akan meninjau pengajuan Anda dalam waktu 1-3 hari kerja. Status pengajuan dapat Anda lihat di halaman mutasi.",
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[900],
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Return to main page
            },
            child: Text("Selesai"),
          ),
        ],
      ),
    );
  }
}
