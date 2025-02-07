import 'dart:io';

import 'package:tgm/domain/login/cookie_data.dart';
import 'package:tgm/domain/login/user_repository.dart';

class Authentication {
  int level;
  Authentication(this.level);

  static Authentication from(HttpHeaders headers) {
    final cookie = headers.value("Cookie");
    if (cookie == null) {
      return Authentication(0);
    }
    final cookieData = CookieData(cookie);
    final username = cookieData.getStringValueOrNull("username");
    final password = cookieData.getStringValueOrNull("password");
    if (username == null || password == null) {
      return Authentication(0);
    }
    final level = UserRepository.getLevel("$username:$password");
    return Authentication(
      level,
    );
  }

  static Authentication fromAuthString(String authString) {
    final level = UserRepository.getLevel(authString);
    return Authentication(level);
  }
}
