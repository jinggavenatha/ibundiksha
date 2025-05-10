import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ibundiksha/provider/account_provider.dart';
import 'package:intl/intl.dart';

class MutasiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AccountProvider>(context);
    final transactions = provider.transactions;
    
    // Sort transactions by date (newest first)
    final sortedTransactions = List.from(transactions)
      ..sort((a, b) => b.date.compareTo(a.date));

    return Scaffold(
      appBar: AppBar(title: Text("Mutasi"), backgroundColor: Colors.blue[900]),
      body: sortedTransactions.isEmpty 
          ? Center(child: Text("Belum ada transaksi", style: TextStyle(fontSize: 16)))
          : ListView.builder(
              itemCount: sortedTransactions.length,
              padding: EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final transaction = sortedTransactions[index];
                return _buildTransactionCard(transaction);
              },
            ),
    );
  }

  Widget _buildTransactionCard(Transaction transaction) {
    // Format date
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm');
    final formattedDate = dateFormat.format(transaction.date);
    
    // Define icon and color based on transaction type
    IconData icon;
    Color color;
    
    switch (transaction.type) {
      case TransactionType.credit:
        icon = Icons.arrow_downward;
        color = Colors.green;
        break;
      case TransactionType.debit:
        icon = Icons.arrow_upward;
        color = Colors.red;
        break;
      case TransactionType.pending:
        icon = Icons.schedule;
        color = Colors.orange;
        break;
      case TransactionType.other:
      default:
        icon = Icons.swap_horiz;
        color = Colors.blue;
        break;
    }

    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color.withOpacity(0.2),
                  child: Icon(icon, color: color),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction.description, 
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      SizedBox(height: 4),
                      Text(
                        formattedDate,
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Text(
                  _formatAmount(transaction),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: transaction.type == TransactionType.credit ? Colors.green : 
                           transaction.type == TransactionType.pending ? Colors.orange : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  String _formatAmount(Transaction transaction) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    
    if (transaction.type == TransactionType.credit) {
      return "+ ${currencyFormat.format(transaction.amount)}";
    } else if (transaction.type == TransactionType.debit) {
      return "- ${currencyFormat.format(transaction.amount)}";
    } else if (transaction.type == TransactionType.pending) {
      return "~ ${currencyFormat.format(transaction.amount)}";
    } else {
      return currencyFormat.format(transaction.amount);
    }
  }
}