import 'dart:convert';
import 'dart:io';

import 'package:tgm/domain/login/authentication.dart';
import 'package:tgm/global.dart';

class User {
  final String secret;
  final int level;
  User(this.secret, this.level);
}

class UserRepository {
  static final List<User> _users = _toUsersList(
      json.decode(File("${Global.dataPath}/users.json").readAsStringSync()));

  static List<User> _toUsersList(List<dynamic> list) {
    List<User> users = [];
    for (final json in list) {
      users.add(User(json["secret"], json["level"]));
    }
    return users;
  }

  static Level getLevel(String secret) {
    final matches = _users.where((it) {
      return it.secret == secret;
    });
    if (matches.isEmpty) {
      return Level.unauthorized;
    }
    return Level.byKey(matches.first.level);
  }
}
