class FormData {
  final Map<String, String> _data;

  FormData(this._data);

  static FormData from(String raw) {
    Map<String, String> data = {};
    for (final line in raw.split("&")) {
      final parts = line.split("=");
      data[parts[0]] = parts[1];
    }
    return FormData(data);
  }

  String getStringValue(String name) {
    return _data[name]!;
  }

  double getDoubleValue(String name) {
    return double.parse(_data[name]!);
  }
}
