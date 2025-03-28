import 'package:flutter/material.dart';
import 'package:ibundiksha/home_page.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png', height: 150), // Gambar logo Undiksha
            SizedBox(height: 20),
            Text(
              'Koperasi Undiksha',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            SizedBox(height: 20),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
              ),
              onPressed: () {
                String username = usernameController.text.trim();
                String password = passwordController.text.trim();

                // Validasi username dan password
                if (username.isEmpty || password.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Username dan password harus diisi!')),
                  );
                } else if (username == '2315091027' && password == '2315091027') {
                  // Jika username dan password benar, masuk ke HomePage
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage(username: username)),
                  );
                } else {
                  // Jika username atau password salah, tampilkan pesan error
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Username atau password salah!')),
                  );
                }
              },
              child: Text('Login', style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text('Daftar Mbanking', style: TextStyle(color: Colors.blue)),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text('Lupa password?', style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
            Spacer(),
            Text('copyright @2025 by Undiksha', style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
