import 'dart:math';

import 'package:tgm/domain/member.dart';

class Role {
  final String id;
  final String name;
  final String memberId;

  Role(this.id, this.name, this.memberId);
  Role.create(this.name, this.memberId)
      : id =
            "role-${Random().nextInt(999999)}-${DateTime.now().millisecondsSinceEpoch}";
}

class RoleInfo {
  final Role role;
  final Member bearer;
  RoleInfo(this.role, this.bearer);
}
