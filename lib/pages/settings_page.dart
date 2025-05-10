import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text('Pengaturan'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Umum',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue[900],
              ),
            ),
            SizedBox(height: 8),
            _buildSettingItem(
              context,
              'Bahasa',
              'Bahasa Indonesia',
              Icons.language,
              () {},
            ),
            _buildSettingItem(
              context,
              'Mode Tema',
              'Light',
              Icons.brightness_6,
              () {},
            ),
            _buildSettingItem(
              context,
              'Notifikasi',
              'Aktif',
              Icons.notifications,
              () {},
            ),

            SizedBox(height: 16),
            Divider(),
            SizedBox(height: 16),

            Text(
              'Keamanan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue[900],
              ),
            ),
            SizedBox(height: 8),
            _buildSettingItem(context, 'Ubah Password', '', Icons.lock, () {}),
            _buildSettingItem(
              context,
              'Login Biometrik',
              'Nonaktif',
              Icons.fingerprint,
              () {},
            ),
            _buildSettingItem(
              context,
              'Verifikasi 2 Langkah',
              'Nonaktif',
              Icons.security,
              () {},
            ),

            SizedBox(height: 16),
            Divider(),
            SizedBox(height: 16),

            Text(
              'Tentang',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue[900],
              ),
            ),
            SizedBox(height: 8),
            _buildSettingItem(
              context,
              'Versi Aplikasi',
              'v1.0.0',
              Icons.info_outline,
              () {},
            ),
            _buildSettingItem(
              context,
              'Syarat dan Ketentuan',
              '',
              Icons.description,
              () {},
            ),
            _buildSettingItem(
              context,
              'Kebijakan Privasi',
              '',
              Icons.privacy_tip,
              () {},
            ),

            SizedBox(height: 16),
            Divider(),
            SizedBox(height: 16),

            
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue[800]),
        title: Text(title),
        subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
