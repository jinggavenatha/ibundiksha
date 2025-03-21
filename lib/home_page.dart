import 'package:flutter/material.dart';
import 'package:ibundiksha/login_page.dart';
import 'package:ibundiksha/scan_qr_page.dart';


class HomePage extends StatelessWidget {
  final String username;
  HomePage({required this.username});

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
            // Profil Nasabah
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage('assets/profile.png'), // Gambar profil
                ),
                title: Text('Jingga Venatha L', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Saldo Anda', style: TextStyle(color: Colors.black54)),
                    Text('Rp. 5.000.000', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
                tileColor: Colors.blue[100],
              ),
            ),
            SizedBox(height: 20),
            // Grid Menu
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
            // Bantuan
            Column(
              children: [
                Text(
                  'Butuh Bantuan?',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                Text(
                  '0858-8215-6789',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
                SizedBox(height: 10),
                Icon(Icons.call, size: 40, color: Colors.blue),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        shape: CircleBorder(),
        onPressed: () {
          // Navigasi ke halaman Scan QR (Buat halaman jika belum ada)
          Navigator.push(context, MaterialPageRoute(builder: (context) => ScanQRPage()));
        },
        child: Icon(Icons.qr_code_scanner, size: 40, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _bottomMenu(Icons.settings, 'Setting'),
            SizedBox(width: 50), // Beri jarak untuk FAB (Scan QR)
            _bottomMenu(Icons.person, 'Profile'),
          ],
        ),
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

  Widget _bottomMenu(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 30, color: Colors.blue),
        SizedBox(height: 5),
        Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
