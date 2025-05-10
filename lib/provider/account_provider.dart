import 'package:flutter/foundation.dart';

class AccountProvider with ChangeNotifier {
  double _saldo = 1200000.00;
  List<Transaction> _transactions = [
    // Initial transaction for testing
    Transaction(
      type: TransactionType.credit,
      amount: 1200000.00,
      description: "Saldo awal",
      date: DateTime.now().subtract(Duration(days: 5)),
    ),
  ];

  // Getter untuk saldo dan mutasi
  double get saldo => _saldo;
  List<Transaction> get transactions => _transactions;

  // Getter mutasi sebagai list string (deskripsi)
  List<String> get mutasi {
    return _transactions.map((t) => t.description).toList();
  }

  // Metode transfer dengan validasi saldo
  bool transfer(double jumlah, String tujuan) {
    if (_saldo >= jumlah && jumlah > 0) {
      _saldo -= jumlah;
      _transactions.add(
        Transaction(
          type: TransactionType.debit,
          amount: jumlah,
          description: "Transfer ke $tujuan",
          date: DateTime.now(),
        ),
      );
      notifyListeners();
      return true;
    }
    return false;
  }

  // Tambah saldo, misal setor tunai
  void tambahSaldo(double jumlah) {
    if (jumlah > 0) {
      _saldo += jumlah;
      _transactions.add(
        Transaction(
          type: TransactionType.credit,
          amount: jumlah,
          description: "Setoran tunai",
          date: DateTime.now(),
        ),
      );
      notifyListeners();
    }
  }

  // Deposito dengan bunga sederhana
  bool deposito(double jumlah, double bunga, int tenor) {
    if (jumlah > 0 && _saldo >= jumlah) {
      _saldo -= jumlah;

      double bungaDeposito = jumlah * (bunga / 100) * (tenor / 12);

      _transactions.add(
        Transaction(
          type: TransactionType.debit,
          amount: jumlah,
          description: "Pembuatan deposito $tenor bulan dengan bunga $bunga%",
          date: DateTime.now(),
        ),
      );

      _transactions.add(
        Transaction(
          type: TransactionType.pending,
          amount: jumlah + bungaDeposito,
          description: "Jatuh tempo deposito (estimasi)",
          date: DateTime.now().add(Duration(days: tenor * 30)),
        ),
      );

      notifyListeners();
      return true;
    }
    return false;
  }

  // Bayar tagihan dengan validasi saldo
  bool bayarTagihan(String jenis, double jumlah) {
    if (_saldo >= jumlah && jumlah > 0) {
      _saldo -= jumlah;
      _transactions.add(
        Transaction(
          type: TransactionType.debit,
          amount: jumlah,
          description: "Pembayaran $jenis",
          date: DateTime.now(),
        ),
      );
      notifyListeners();
      return true;
    }
    return false;
  }

  // Ajukan pinjaman (menyimpan status pending di transaksi)
  bool ajukanPinjaman(double jumlah, int tenor) {
    if (jumlah > 0) {
      _transactions.add(
        Transaction(
          type: TransactionType.pending,
          amount: jumlah,
          description: "Pengajuan pinjaman tenor $tenor bulan",
          date: DateTime.now(),
        ),
      );
      notifyListeners();
      return true;
    }
    return false;
  }

  // Setujui pinjaman: tambahkan saldo dan buat transaksi pencairan
  bool setujuiPinjaman(double jumlah) {
    if (jumlah > 0) {
      _saldo += jumlah;
      _transactions.add(
        Transaction(
          type: TransactionType.credit,
          amount: jumlah,
          description:
              "Pencairan pinjaman sebesar Rp ${jumlah.toStringAsFixed(0)}",
          date: DateTime.now(),
        ),
      );
      notifyListeners();
      return true;
    }
    return false;
  }

  // Tambah mutasi manual jika diperlukan
  void addMutasi(String deskripsi) {
    _transactions.add(
      Transaction(
        type: TransactionType.other,
        amount: 0,
        description: deskripsi,
        date: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  // Pencairan pinjaman (bisa diintegrasikan dengan setujuiPinjaman)
  bool pencairanPinjaman(double jumlah) {
    _saldo += jumlah;
    _transactions.add(
      Transaction(
        type: TransactionType.credit,
        amount: jumlah,
        description: "Pencairan pinjaman",
        date: DateTime.now(),
      ),
    );
    notifyListeners();
    return true;
  }
}

// Enum tipe transaksi
enum TransactionType {
  credit, // Masuk saldo
  debit, // Keluar saldo
  pending, // Status tertunda (pengajuan)
  other, // Lain-lain
}

// Class data transaksi
class Transaction {
  final TransactionType type;
  final double amount;
  final String description;
  final DateTime date;

  Transaction({
    required this.type,
    required this.amount,
    required this.description,
    required this.date,
  });
}
