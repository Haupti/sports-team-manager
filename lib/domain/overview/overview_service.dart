import 'package:tgm/domain/member_repository.dart';
import 'package:tgm/domain/overview/member_info.dart';

class OverviewService {
  static List<MemberInfo> getAllMemberInfos() {
// TODO
    return MemberRepository.getAll()
        .map((it) => MemberInfo(it, 0.0, 0))
        .toList();
  }
}
