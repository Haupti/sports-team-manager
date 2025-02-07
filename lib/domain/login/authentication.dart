import 'dart:io';

import 'package:tgm/domain/login/cookie_data.dart';
import 'package:tgm/domain/login/user_repository.dart';

enum Level {
  unauthorized(0),
  user(1),
  mod(2),
  admin(5);

  final int key;
  const Level(this.key);

  static Level byKey(int key) {
    if (key <= 0) {
      return Level.unauthorized;
    }
    if (key == 1) {
      return Level.user;
    }
    if (key == 2) {
      return Level.mod;
    }
    if (key > 2) {
      return Level.admin;
    }
    return Level.unauthorized;
  }
}

class Authentication {
  Level level;
  Authentication(this.level);

  static Authentication from(HttpHeaders headers) {
    final cookie = headers.value("Cookie");
    if (cookie == null) {
      return Authentication(Level.unauthorized);
    }
    final cookieData = CookieData(cookie);
    final username = cookieData.getStringValueOrNull("username");
    final password = cookieData.getStringValueOrNull("password");
    if (username == null || password == null) {
      return Authentication(Level.unauthorized);
    }
    final level = UserRepository.getLevel("$username:$password");
    return Authentication(level);
  }

  static Authentication fromAuthString(String authString) {
    final level = UserRepository.getLevel(authString);
    return Authentication(level);
  }

  bool get isUserOnly => level == Level.user;
  bool get isUnauthorized => Level.unauthorized == level;
  bool get isAtLeastMod => level == Level.mod || level == Level.admin;
  bool get isAdmin => level == Level.admin;
  bool get isAtLeastUser => isUserOnly || isAtLeastMod;
}
