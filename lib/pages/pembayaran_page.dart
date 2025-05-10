import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ibundiksha/provider/account_provider.dart';

class PembayaranPage extends StatefulWidget {
  @override
  _PembayaranPageState createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<PembayaranPage> {
  final List<Map<String, dynamic>> tagihan = [
    {"nama": "Listrik", "icon": Icons.lightbulb, "color": Colors.yellow[700]},
    {"nama": "Air", "icon": Icons.water_drop, "color": Colors.blue[400]},
    {"nama": "BPJS", "icon": Icons.health_and_safety, "color": Colors.red[400]},
    {"nama": "Internet", "icon": Icons.wifi, "color": Colors.purple[400]},
    {"nama": "Telepon", "icon": Icons.phone, "color": Colors.green[400]},
    {"nama": "Pendidikan", "icon": Icons.school, "color": Colors.orange[400]},
  ];

  final TextEditingController nomorController = TextEditingController();
  final TextEditingController jumlahController = TextEditingController();
  String? selectedTagihan;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AccountProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Pembayaran"), 
        backgroundColor: Colors.blue[900]
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
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
                        Text("Saldo Tersedia", style: TextStyle(fontSize: 14, color: Colors.grey[600])),
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
            
            Text("Pilih Jenis Tagihan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 16),
            
            // Tagihan Grid
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: tagihan.length,
              itemBuilder: (context, index) {
                final item = tagihan[index];
                final isSelected = selectedTagihan == item["nama"];
                
                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedTagihan = item["nama"];
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue[50] : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? Colors.blue[800]! : Colors.grey[300]!,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          item["icon"], 
                          size: 32, 
                          color: item["color"],
                        ),
                        SizedBox(height: 8),
                        Text(
                          item["nama"],
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            
            SizedBox(height: 24),
            
            // Form input if tagihan is selected
            if (selectedTagihan != null) ...[
              Text("Detail Pembayaran", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 16),
              
              TextField(
                controller: nomorController,
                decoration: InputDecoration(
                  labelText: "Nomor $selectedTagihan",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.confirmation_number),
                ),
                keyboardType: TextInputType.number,
              ),
              
              SizedBox(height: 16),
              
              TextField(
                controller: jumlahController,
                decoration: InputDecoration(
                  labelText: "Jumlah Tagihan (Rp)",
                  border: OutlineInputBorder(),
                  prefixText: "Rp ",
                ),
                keyboardType: TextInputType.number,
              ),
              
              SizedBox(height: 24),
              
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[900],
                    foregroundColor: Colors.white,
                  ),
                  onPressed: isLoading ? null : () {
                    if (nomorController.text.isEmpty || jumlahController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Semua field harus diisi"))
                      );
                      return;
                    }
                    
                    double? jumlah = double.tryParse(jumlahController.text);
                    if (jumlah == null || jumlah <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Jumlah tagihan tidak valid"))
                      );
                      return;
                    }
                    
                    if (jumlah > provider.saldo) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Saldo tidak mencukupi"))
                      );
                      return;
                    }
                    
                    _showConfirmationDialog(jumlah);
                  },
                  child: isLoading 
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Bayar Sekarang", style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  void _showConfirmationDialog(double jumlah) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Konfirmasi Pembayaran"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Pastikan detail pembayaran sudah benar:"),
            SizedBox(height: 16),
            _detailRow("Jenis Tagihan", selectedTagihan!),
            _detailRow("Nomor", nomorController.text),
            _detailRow("Jumlah", "Rp ${jumlah.toStringAsFixed(2)}"),
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
              _processPembayaran(jumlah);
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
  
  void _processPembayaran(double jumlah) {
    setState(() {
      isLoading = true;
    });

    // Simulasi proses backend
    Future.delayed(Duration(seconds: 1), () {
      final nomor = nomorController.text;
      
      // Lakukan pembayaran
      bool success = Provider.of<AccountProvider>(context, listen: false)
          .bayarTagihan("$selectedTagihan ($nomor)", jumlah);

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
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text("Pembayaran Berhasil"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("$selectedTagihan berhasil dibayar"),
            SizedBox(height: 8),
            Text("Nomor: ${nomorController.text}"),
            Text("Jumlah: Rp ${jumlah.toStringAsFixed(2)}"),
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
            Text("Pembayaran Gagal"),
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