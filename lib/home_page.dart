import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ibundiksha/pages/cek_saldo_page.dart';
import 'package:ibundiksha/pages/transfer_page.dart';
import 'package:ibundiksha/pages/deposito_page.dart';
import 'package:ibundiksha/pages/pembayaran_page.dart';
import 'package:ibundiksha/pages/pinjaman_page.dart';
import 'package:ibundiksha/pages/mutasi_page.dart';
import 'package:ibundiksha/scan_qr_page.dart';
import 'package:ibundiksha/provider/account_provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final saldo = Provider.of<AccountProvider>(context).saldo;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text('Koperasi Undiksha'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile + Saldo
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/profile.png'),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Nasabah", style: TextStyle(color: Colors.grey[700])),
                          Text("Jingga Venatha Lisdabrani", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(height: 6),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Total Saldo Anda", style: TextStyle(fontSize: 12, color: Colors.grey[800])),
                                Text("Rp. ${saldo.toStringAsFixed(2)}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Menu Grid
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _menuItem(context, Icons.account_balance_wallet, 'Cek Saldo', CekSaldoPage()),
                    _menuItem(context, Icons.send, 'Transfer', TransferPage()),
                    _menuItem(context, Icons.savings, 'Deposito', DepositoPage()),
                    _menuItem(context, Icons.payment, 'Pembayaran', PembayaranPage()),
                    _menuItem(context, Icons.attach_money, 'Pinjaman', PinjamanPage()),
                    _menuItem(context, Icons.receipt_long, 'Mutasi', MutasiPage()),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Bantuan
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Butuh Bantuan?", style: TextStyle(fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Text("0858-1234-5678", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(width: 8),
                      Icon(Icons.phone, color: Colors.blue[800]),
                    ],
                  )
                ],
              ),
            ),

            SizedBox(height: 20),

            // Bottom Menu
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.settings, size: 32, color: Colors.blue[800]),
                  onPressed: () {},
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(18),
                    backgroundColor: Colors.blue[800],
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => ScanQRPage()));
                  },
                  child: Icon(Icons.qr_code_scanner, size: 32, color: Colors.white),
                ),
                IconButton(
                  icon: Icon(Icons.person, size: 32, color: Colors.blue[800]),
                  onPressed: () {},
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _menuItem(BuildContext context, IconData icon, String label, Widget page) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.blue[800]),
          SizedBox(height: 8),
          Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
