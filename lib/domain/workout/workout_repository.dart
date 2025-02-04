import 'dart:convert';
import 'dart:io';

import 'package:tgm/domain/workout/workout.dart';
import 'package:tgm/global.dart';

class WorkoutRepository {
  static final File _db = File("${Global.dataPath}/workouts.json");
  static File _getDb() {
    if (!_db.existsSync()) {
      _db.createSync();
      _db.writeAsStringSync("[]");
    }
    return _db;
  }

  static List<Workout> getAll() {
    final List<dynamic> content = json.decode(_getDb().readAsStringSync());
    return content
        .map((it) =>
            Workout(it["id"], it["memberId"], DateTime.parse(it["timestamp"])))
        .toList();
  }

  static void add(Workout t) {
    final all = getAll();
    all.add(t);
    _saveAll(all);
  }

  static void _saveAll(List<Workout> workouts) {
    final entities = workouts
        .map((it) => {
              "id": it.id,
              "memberId": it.memberId,
              "timestamp": it.timestamp.toString(),
            })
        .toList();
    _getDb().writeAsStringSync(json.encode(entities));
  }

  static void delete(String id) {
    List<Workout> all = getAll();
    all = all.where((it) => id != it.memberId).toList();
    _saveAll(all);
  }
}
