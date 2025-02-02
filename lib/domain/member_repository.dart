import 'package:tgm/domain/member.dart';

// TODO
class MemberRepository {
  static List<Member> _members = [];

  static List<Member> getAll() {
    return _members;
  }

  static add(Member member) {
    _members.add(member);
  }

  static void delete(String memberId) {
    _members = _members.where((it) => it.id != memberId).toList();
  }
}
