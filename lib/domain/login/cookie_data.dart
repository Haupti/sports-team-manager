import 'dart:collection';

class CookieData {
  final HashMap<String, String> parsed;
  CookieData._internal(this.parsed);
  static CookieData? from(String raw) {
    final result = CookieData._parse(raw);
    if (result == null) {
      return null;
    }
    return CookieData._internal(result);
  }

  String getStringValue(String valueName) {
    return parsed[valueName]!;
  }

  String? getStringValueOrNull(String valueName) {
    return parsed[valueName];
  }

  static HashMap<String, String>? _parse(String raw) {
    final Iterable<List<String>> pairs =
        raw.split(";").map((it) => it.trim().split("="));
    final HashMap<String, String> dataParsed = HashMap.from({});
    for (final pair in pairs) {
      if (pair.length != 2) {
        return null;
      }
      dataParsed[pair[0]] = pair[1];
    }
    return dataParsed;
  }
}
