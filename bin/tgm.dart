import 'dart:io';

import 'package:tgm/main.dart';
import 'package:tgm/global.dart';

void main(List<String> arguments) async {
  final String? dataPath = Platform.environment["DATA_PATH"];
  if (dataPath == null) {
    throw "'DATA_PATH' not set";
  }
  Global.dataPath = dataPath;
  await run();
}
