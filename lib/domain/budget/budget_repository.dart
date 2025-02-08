import 'dart:convert';
import 'dart:io';

import 'package:tgm/domain/budget/budget.dart';
import 'package:tgm/global.dart';

class BudgetRepository {
  static final File _db = File("${Global.dataPath}/budget.json");
  static File _getDb() {
    if (!_db.existsSync()) {
      _db.createSync();
      _db.writeAsStringSync('{"value": 0.0}');
    }
    return _db;
  }

  static Budget get() {
    final Map<String, dynamic> entities =
        json.decode(_getDb().readAsStringSync());
    return Budget(entities["value"]);
  }

  static void set(Budget budget) {
    _save(budget);
  }

  static void _save(Budget budget) {
    Map<String, dynamic> entity = {"value": budget.value};
    _getDb().writeAsStringSync(json.encode(entity));
  }
}
