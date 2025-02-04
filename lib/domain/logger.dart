class Logger {
  static T fallback<T>(String logMsg, T obj) {
    print("FALLBACK USAGE: $logMsg");
    return obj;
  }
  static void info(String logMsg) {
    print("INFO: $logMsg");
  }
  static void warn(String logMsg) {
    print("WARN: $logMsg");
  }

  static void error(String logMsg) {
    print("ERROR: $logMsg");
  }
}
