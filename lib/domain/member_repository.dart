import 'dart:convert';
import 'dart:io';

import 'package:tgm/domain/member.dart';
import 'package:tgm/global.dart';

class MemberRepository {
  static final File _db = File("${Global.dataPath}/members.json");
  static File _getDb() {
    if (!_db.existsSync()) {
      _db.createSync();
    }
    return _db;
  }

  static Member? getById(String id) {
    return getAll().where((it) => it.id == id).firstOrNull;
  }

  static List<Member> getAll() {
    final List<dynamic> entities = json.decode(_getDb().readAsStringSync());
    return entities.map((it) => Member(it["id"], it["name"])).toList();
  }

  static void add(Member t) {
    final all = getAll();
    all.add(t);
    _saveAll(all);
  }

  static void _saveAll(List<Member> members) {
    final entities = members.map((it) => {
          "id": it.id,
          "name": it.name,
        });
    _getDb().writeAsStringSync(json.encode(entities));
  }

  static void delete(String id) {
    var all = getAll();
    all = all.where((it) => it.id != id).toList();
    _saveAll(all);
  }
}
