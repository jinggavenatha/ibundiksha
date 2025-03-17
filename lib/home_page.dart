import 'package:flutter/material.dart';
import 'package:ibundiksha/login_page.dart';

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
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage('assets/profile.png'), // Gambar profil
                ),
                title: Text('Nasabah'),
                subtitle: Text('$username\nTotal Saldo Anda\nRp. 1.200.000'),
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
            Text(
              'Butuh Bantuan?\n0878-1234-1024',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            SizedBox(height: 10),
            Icon(Icons.call, size: 40, color: Colors.blue),
            Spacer(),
            // Bottom Menu
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _bottomMenu(Icons.settings, 'Setting'),
                SizedBox(width: 50),
                _bottomMenu(Icons.person, 'Profile'),
              ],
            ),
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
      children: [
        Icon(icon, size: 50, color: Colors.blue),
        Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
