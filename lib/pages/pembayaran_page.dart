import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ibundiksha/provider/account_provider.dart';

class PembayaranPage extends StatefulWidget {
  @override
  _PembayaranPageState createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<PembayaranPage> {
  final TextEditingController nomorController = TextEditingController();
  final TextEditingController nominalController = TextEditingController();
  String? selectedTagihan;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  final List<Map<String, dynamic>> tagihan = [
    {"name": "Listrik", "icon": Icons.lightbulb_outline, "color": Colors.yellow[700]},
    {"name": "Air", "icon": Icons.water_drop_outlined, "color": Colors.blue[500]},
    {"name": "BPJS", "icon": Icons.medical_services_outlined, "color": Colors.red[400]},
    {"name": "Internet", "icon": Icons.wifi, "color": Colors.green[600]},
    {"name": "Telepon", "icon": Icons.phone_outlined, "color": Colors.orange[700]},
    {"name": "PDAM", "icon": Icons.water, "color": Colors.blue[700]},
  ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AccountProvider>(context);
    
    return Scaffold(
      appBar: AppBar(title: Text("Pembayaran"), backgroundColor: Colors.blue[900]),
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
                        Text("Saldo Anda", style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                        Text(
                          "Rp ${provider.saldo.toStringAsFixed(0)}", 
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            
            // Tagihan Selection
            Text("Pilih Jenis Tagihan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 16),
            
            // Grid for tagihan types
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.1,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: tagihan.length,
              itemBuilder: (context, index) {
                return _buildTagihanItem(tagihan[index]);
              },
            ),
            
            SizedBox(height: 24),
            
            // Only show form if a tagihan is selected
            if (selectedTagihan != null) _buildPaymentForm(provider),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTagihanItem(Map<String, dynamic> item) {
    final bool isSelected = selectedTagihan == item["name"];
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTagihan = item["name"];
          // Reset form when changing tagihan type
          nomorController.clear();
          nominalController.clear();
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              item["icon"] as IconData, 
              size: 32, 
              color: item["color"] as Color,
            ),
            SizedBox(height: 8),
            Text(
              item["name"] as String, 
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPaymentForm(AccountProvider provider) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Detail Pembayaran $selectedTagihan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 16),
          
          // Nomor Pelanggan
          TextFormField(
            controller: nomorController,
            decoration: InputDecoration(
              labelText: "Nomor ID Pelanggan",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.numbers),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Nomor ID pelanggan tidak boleh kosong';
              }
              if (value.length < 5) {
                return 'Nomor ID pelanggan tidak valid';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          
          // Nominal
          TextFormField(
            controller: nominalController,
            decoration: InputDecoration(
              labelText: "Nominal Pembayaran",
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
          
          // Bayar Button
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
                  _showConfirmationDialog(provider);
                }
              },
              child: isLoading 
                ? CircularProgressIndicator(color: Colors.white)
                : Text("Bayar Sekarang", style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog(AccountProvider provider) {
    double nominal = double.tryParse(nominalController.text) ?? 0;
    String nomorID = nomorController.text;
    
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
            _detailRow("ID Pelanggan", nomorID),
            _detailRow("Nominal", "Rp ${nominal.toStringAsFixed(0)}"),
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
              _processPembayaran(provider);
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

  void _processPembayaran(AccountProvider provider) {
    setState(() {
      isLoading = true;
    });

    // Simulate backend process
    Future.delayed(Duration(seconds: 1), () {
      double nominal = double.tryParse(nominalController.text) ?? 0;
      String nomorID = nomorController.text;
      
      // Process payment
      bool success = provider.bayarTagihan(
        "$selectedTagihan ($nomorID)", 
        nominal
      );

      setState(() {
        isLoading = false;
      });

      if (success) {
        _showSuccessDialog(nominal);
      } else {
        _showErrorDialog();
      }
    });
  }

  void _showSuccessDialog(double nominal) {
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
            Text("Pembayaran $selectedTagihan sebesar Rp ${nominal.toStringAsFixed(0)} berhasil dilakukan."),
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
              Navigator.pop(context); // Return to main page
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