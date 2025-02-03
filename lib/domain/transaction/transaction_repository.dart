import 'package:tgm/domain/transaction/transaction.dart';

class TransactionRepository {
  static List<Transaction> _transactions = [];

  static List<Transaction> getAll() {
    return _transactions;
  }

  static void add(Transaction t) {
    _transactions.add(t);
  }

  static void delete(String id) {
    _transactions = _transactions.where((it) => id != it.id).toList();
  }
}
