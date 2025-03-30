import 'package:flutter/material.dart';
import 'package:ibundiksha/login_page.dart';
import 'package:ibundiksha/scan_qr_page.dart';

class HomePage extends StatefulWidget {
  final String username;
  HomePage({required this.username});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double saldo = 5000000; // Simpan saldo pengguna

  void tarikDana() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController jumlahController = TextEditingController();
        return AlertDialog(
          title: Text("Tarik Dana"),
          content: TextField(
            controller: jumlahController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: "Masukkan jumlah"),
          ),
          actions: [
            TextButton(
              child: Text("Batal"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: Text("Tarik"),
              onPressed: () {
                double jumlah = double.tryParse(jumlahController.text) ?? 0;
                if (jumlah <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Jumlah tidak valid!")),
                  );
                  return;
                }
                if (jumlah > saldo) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Saldo tidak cukup!")),
                  );
                  return;
                }
                setState(() {
                  saldo -= jumlah;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Berhasil menarik Rp. ${jumlah.toStringAsFixed(2)}")),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Koperasi Undiksha'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage('assets/profile.png'),
                ),
                title: Text(widget.username, style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Saldo Anda', style: TextStyle(color: Colors.black54)),
                    Text('Rp. ${saldo.toStringAsFixed(2)}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
                tileColor: Colors.blue[100],
              ),
            ),
            SizedBox(height: 20),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              children: [
                _menuItem(Icons.account_balance_wallet, 'Cek Saldo'),
                _menuItem(Icons.send, 'Transfer'),
                _menuItem(Icons.savings, 'Deposito'),
                _menuItem(Icons.payment, 'Pembayaran'),
                _menuItem(Icons.money, 'Pinjaman'),
                _menuItem(Icons.history, 'Mutasi'),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: tarikDana,
              child: Text("Tarik Dana", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        shape: CircleBorder(),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ScanQRPage()));
        },
        child: Icon(Icons.qr_code_scanner, size: 40, color: Colors.white),
      ),
    );
  }

  Widget _menuItem(IconData icon, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 50, color: Colors.blue),
        SizedBox(height: 5),
        Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
