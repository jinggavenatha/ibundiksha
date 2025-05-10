import 'package:flutter/foundation.dart';

class AccountProvider with ChangeNotifier {
  double _saldo = 1200000.00;
  List<String> _mutasi = [];

  double get saldo => _saldo;
  List<String> get mutasi => _mutasi;

  // Metode untuk transfer
  void transfer(double jumlah, String tujuan) {
    if (_saldo >= jumlah) {
      _saldo -= jumlah;
      _mutasi.add("Transfer Rp${jumlah.toStringAsFixed(2)} ke $tujuan");
      notifyListeners();
    }
  }

  // Metode untuk menambah saldo (misalnya setor atau deposit)
  void tambahSaldo(double jumlah) {
    _saldo += jumlah;
    _mutasi.add("Setor Rp${jumlah.toStringAsFixed(2)}");
    notifyListeners();
  }

  // Metode untuk menambah saldo dari deposito dan bunga
  void deposito(double jumlah, double bunga) {
    double bungaDeposito = jumlah * (bunga / 100); // Hitung bunga
    _saldo += jumlah + bungaDeposito; // Tambah saldo dengan jumlah deposito dan bunga
    _mutasi.add("Deposito Rp${jumlah.toStringAsFixed(2)} + Bunga Rp${bungaDeposito.toStringAsFixed(2)}");
    notifyListeners();
  }

  // Metode untuk menambahkan mutasi secara manual
  void addMutasi(String mutasi) {
    _mutasi.add(mutasi);
    notifyListeners();
  }
}
