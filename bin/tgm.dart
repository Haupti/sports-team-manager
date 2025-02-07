import 'dart:io';

import 'package:tgm/main.dart';
import 'package:tgm/global.dart';

void main(List<String> arguments) async {
  final String? dataPath = Platform.environment["DATA_PATH"];
  if (dataPath == null) {
    throw "'DATA_PATH' not set";
  }
  Global.dataPath = dataPath;

  String? domain;
  if (arguments.isEmpty) {
    domain = "localhost";
  } else {
    domain = arguments[0];
  }
  Global.domain = domain;
  await run();
}
