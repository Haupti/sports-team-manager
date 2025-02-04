extension DateUtils on DateTime {
  String prettyDate() {
    return toIso8601String().split("T")[0];
  }
}
