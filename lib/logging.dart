import 'dart:io';

import 'package:tgm/global.dart';

class FileLogger {
  static File logfile = () {
    final file = File("${Global.dataPath}/error.logs");
    if (!file.existsSync()) {
      file.createSync();
    }
    return file;
  }();

  static void logError(Error exception) {
    logfile.writeAsStringSync(
        "[${DateTime.now().toIso8601String()}] ERROR: '${exception.toString()}'\n",
        mode: FileMode.append);
  }

  static void logException(Exception exception) {
    logfile.writeAsStringSync(
        "[${DateTime.now().toIso8601String()}] EXCEPTION: '${exception.toString()}'\n",
        mode: FileMode.append);
  }
}
