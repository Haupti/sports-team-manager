import 'package:tgm/domain/member_repository.dart';
import 'package:tgm/domain/overview/member_info.dart';
import 'package:tgm/domain/transaction/transaction_repository.dart';
import 'package:tgm/domain/workout/workout_repository.dart';

class OverviewService {
  static List<MemberInfo> getAllMemberInfos() {
    final transactions = TransactionRepository.getAll();
    final members = MemberRepository.getAll();
    final workouts = WorkoutRepository.getAll();

    List<MemberInfo> infos = [];

    for (final member in members) {
      final workoutsOfMember =
          workouts.where((it) => it.memberId == member.id).toList();
      final sum = transactions.fold<double>(
          0.0, (prev, transaction) => prev + transaction.typedAmount);
      infos.add(MemberInfo(member, sum, workoutsOfMember.length));
    }

    return infos.toList();
  }
}
