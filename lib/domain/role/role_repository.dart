import 'dart:convert';
import 'dart:io';

import 'package:tgm/domain/role/role.dart';
import 'package:tgm/global.dart';

class RoleRepository {
  static final File _db = File("${Global.dataPath}/roles.json");
  static File _getDb() {
    if (!_db.existsSync()) {
      _db.createSync();
      _db.writeAsStringSync("[]");
    }
    return _db;
  }

  static List<Role> getAll() {
    final List<dynamic> entities = json.decode(_getDb().readAsStringSync());
    return entities
        .map((it) => Role(
              it["id"],
              it["name"],
              it["memberId"],
            ))
        .toList();
  }

  static void add(Role t) {
    final all = getAll();
    all.add(t);
    _saveAll(all);
  }

  static void _saveAll(List<Role> transactions) {
    final entities = transactions
        .map((it) => {
              "id": it.id,
              "name" : it.name,
              "memberId": it.memberId,
            })
        .toList();
    _getDb().writeAsStringSync(json.encode(entities));
  }

  static void delete(String id) {
    var all = getAll();
    all = all.where((it) => it.id != id).toList();
    _saveAll(all);
  }
}
