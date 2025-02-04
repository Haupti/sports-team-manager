import 'dart:math';

class Member {
  String id;
  String name;
  Member(this.id, this.name);
  static Member create(String name) {
    return Member(
        "member-${Random().nextInt(999999999)}-${DateTime.now().millisecondsSinceEpoch}",
        name);
  }

  static Member deleted(String id) {
    return Member(id, "deleted");
  }
}
