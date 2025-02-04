import 'package:tgm/domain/member.dart';

class MemberRepository {
  static List<Member> _members = [];

  static List<Member> getAll() {
    return _members;
  }

  static Member? getById(String id) {
    return _members.where((it) => it.id == id).firstOrNull;
  }

  static add(Member member) {
    _members.add(member);
  }

  static void delete(String memberId) {
    _members = _members.where((it) => it.id != memberId).toList();
  }
}
