import 'package:flutter/foundation.dart';

class AccountProvider with ChangeNotifier {
  double _saldo = 1200000.00;
  List<Transaction> _transactions = [
    // Adding some initial transactions for testing
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
  
  // Getter untuk mutasi sebagai string (untuk backward compatibility)
  List<String> get mutasi {
    return _transactions.map((t) => t.description).toList();
  }

  // Metode untuk transfer dengan validasi saldo
  bool transfer(double jumlah, String tujuan) {
    if (_saldo >= jumlah && jumlah > 0) {
      _saldo -= jumlah;
      _transactions.add(
        Transaction(
          type: TransactionType.debit,
          amount: jumlah,
          description: "Transfer ke $tujuan",
          date: DateTime.now(),
        )
      );
      notifyListeners();
      return true;
    }
    return false;
  }

  // Metode untuk menambah saldo (misalnya setor atau deposit)
  void tambahSaldo(double jumlah) {
    if (jumlah > 0) {
      _saldo += jumlah;
      _transactions.add(
        Transaction(
          type: TransactionType.credit,
          amount: jumlah,
          description: "Setoran tunai",
          date: DateTime.now(),
        )
      );
      notifyListeners();
    }
  }

  // Metode untuk menambah saldo dari deposito dan bunga
  bool deposito(double jumlah, double bunga, int tenor) {
    if (jumlah > 0 && _saldo >= jumlah) {
      // Kurangi saldo untuk deposito
      _saldo -= jumlah;
      
      // Hitung bunga (sederhana)
      double bungaDeposito = jumlah * (bunga / 100) * (tenor / 12);
      
      // Tambahkan informasi deposito ke transaksi
      _transactions.add(
        Transaction(
          type: TransactionType.debit,
          amount: jumlah,
          description: "Pembuatan deposito $tenor bulan dengan bunga $bunga%",
          date: DateTime.now(),
        )
      );
      
      // Simulasi penambahan bunga dan pengembalian deposito saat jatuh tempo
      // (Dalam aplikasi nyata, ini akan dikelola oleh sistem backend)
      double totalReturn = jumlah + bungaDeposito;
      _transactions.add(
        Transaction(
          type: TransactionType.pending,
          amount: totalReturn,
          description: "Jatuh tempo deposito (estimasi)",
          date: DateTime.now().add(Duration(days: tenor * 30)), // Simulasi jatuh tempo
        )
      );
      
      notifyListeners();
      return true;
    }
    return false;
  }
  
  // Metode untuk membayar tagihan
  bool bayarTagihan(String jenis, double jumlah) {
    if (_saldo >= jumlah && jumlah > 0) {
      _saldo -= jumlah;
      _transactions.add(
        Transaction(
          type: TransactionType.debit,
          amount: jumlah,
          description: "Pembayaran $jenis",
          date: DateTime.now(),
        )
      );
      notifyListeners();
      return true;
    }
    return false;
  }
  
  // Metode untuk pengajuan pinjaman
  bool ajukanPinjaman(double jumlah, int tenor) {
    if (jumlah > 0) {
      _transactions.add(
        Transaction(
          type: TransactionType.pending,
          amount: jumlah,
          description: "Pengajuan pinjaman tenor $tenor bulan",
          date: DateTime.now(),
        )
      );
      notifyListeners();
      return true;
    }
    return false;
  }

  // Metode untuk menambahkan mutasi secara manual
  void addMutasi(String deskripsi) {
    _transactions.add(
      Transaction(
        type: TransactionType.other,
        amount: 0,
        description: deskripsi,
        date: DateTime.now(),
      )
    );
    notifyListeners();
  }
  
  // Metode untuk menambahkan pencairan pinjaman 
  bool pencairanPinjaman(double jumlah) {
    _saldo += jumlah;
    _transactions.add(
      Transaction(
        type: TransactionType.credit,
        amount: jumlah,
        description: "Pencairan pinjaman",
        date: DateTime.now(),
      )
    );
    notifyListeners();
    return true;
  }
}

// Enum untuk tipe transaksi
enum TransactionType {
  credit,  // Masuk
  debit,   // Keluar
  pending, // Transaksi tertunda
  other    // Lainnya
}

// Class untuk menyimpan data transaksi
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