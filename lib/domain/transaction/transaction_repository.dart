import 'dart:convert';
import 'dart:io';

import 'package:tgm/domain/transaction/transaction.dart';
import 'package:tgm/global.dart';

class TransactionRepository {
  static final File _db = File("${Global.dataPath}/transactions.json");
  static File _getDb() {
    if (!_db.existsSync()) {
      _db.createSync();
    }
    return _db;
  }

  static List<Transaction> getAll() {
    final List<dynamic> entities = json.decode(_getDb().readAsStringSync());
    return entities
        .map((it) => Transaction(
            it["id"],
            DateTime.parse(it["timestamp"]),
            it["memberId"],
            it["amount"],
            it["reason"],
            TransactionType.from(it["type"])!))
        .toList();
  }

  static void add(Transaction t) {
    final all = getAll();
    all.add(t);
    _saveAll(all);
  }

  static void _saveAll(List<Transaction> transactions) {
    final entities = transactions.map((it) => {
          "id": it.id,
          "timestamp": it.timestamp.toString(),
          "memberId": it.memberId,
          "amout": it.amount,
          "reason": it.reason,
          "type": it.type.key,
        });
    _getDb().writeAsStringSync(json.encode(entities));
  }

  static void delete(String id) {
    var all = getAll();
    all = all.where((it) => it.id != id).toList();
    _saveAll(all);
  }
}
