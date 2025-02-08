import 'dart:collection';

import 'package:tgm/domain/member.dart';
import 'package:tgm/domain/member_repository.dart';
import 'package:tgm/domain/role/role.dart';
import 'package:tgm/domain/role/role_repository.dart';

class RoleService {
  static List<RoleInfo> getAll() {
    final List<Member> members = MemberRepository.getAll();
    final HashMap<String, Member> associatedMembers = HashMap.from({});
    for (final m in members) {
      associatedMembers[m.id] = m;
    }
    final List<Role> roles = RoleRepository.getAll();

    final List<RoleInfo> roleInfos = [];
    for (final role in roles) {
      roleInfos.add(RoleInfo(role,
          associatedMembers[role.memberId] ?? Member.deleted(role.memberId)));
    }

    return roleInfos;
  }
}
