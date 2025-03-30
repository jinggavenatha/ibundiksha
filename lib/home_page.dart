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
  double saldo = 5000000; // Simulasi saldo awal

  void tarikDana(double jumlah) {
    if (jumlah > saldo) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Saldo tidak cukup!')),
      );
    } else {
      setState(() {
        saldo -= jumlah;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Penarikan berhasil: Rp. $jumlah')),
      );
    }
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
                title: Text('Jingga Venatha Lisdabrani', style: TextStyle(fontWeight: FontWeight.bold)),
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
                _menuItem(Icons.account_balance_wallet, 'Cek Saldo', () {}),
                _menuItem(Icons.send, 'Transfer', () {}),
                _menuItem(Icons.savings, 'Deposito', () {}),
                _menuItem(Icons.payment, 'Pembayaran', () {}),
                _menuItem(Icons.money, 'Pinjaman', () {}),
                _menuItem(Icons.history, 'Mutasi', () {}),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                _showWithdrawDialog();
              },
              child: Text(
                'Tarik Dana',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
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
            SizedBox(width: 50),
            _bottomMenu(Icons.person, 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 50, color: Colors.blue),
          SizedBox(height: 5),
          Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
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

  void _showWithdrawDialog() {
    TextEditingController amountController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tarik Dana'),
          content: TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: 'Masukkan jumlah dana'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                double? amount = double.tryParse(amountController.text);
                if (amount != null && amount > 0) {
                  tarikDana(amount);
                  Navigator.pop(context);
                }
              },
              child: Text('Tarik'),
            ),
          ],
        );
      },
    );
  }
}
