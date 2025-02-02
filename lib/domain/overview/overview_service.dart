import 'package:tgm/domain/member_repository.dart';
import 'package:tgm/domain/overview/member_info.dart';
import 'package:tgm/domain/transaction/transaction_repository.dart';

class OverviewService {
  static List<MemberInfo> getAllMemberInfos() {
    final transactions = TransactionRepository.getAll();
    final members = MemberRepository.getAll();
    Map<String, MemberInfo> infos = {};
    for (final t in transactions) {
      if (infos[t.memberId] == null) {
        infos[t.memberId] = MemberInfo(
            members.firstWhere((it) => it.id == t.memberId), t.typedAmount, 0);
        continue;
      }

      infos[t.memberId]!.openFine += t.typedAmount;
    }

    return infos.values.toList();
  }
}
