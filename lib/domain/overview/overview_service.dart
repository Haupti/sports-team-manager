import 'package:tgm/domain/member_repository.dart';
import 'package:tgm/domain/overview/member_info.dart';
import 'package:tgm/domain/transaction/transaction.dart';
import 'package:tgm/domain/transaction/transaction_repository.dart';
import 'package:tgm/domain/workout/workout_repository.dart';

class OverviewService {
  static List<MemberInfo> getAllMemberInfos() {
    final List<Transaction> transactions = TransactionRepository.getAll();
    final members = MemberRepository.getAll();
    final workouts = WorkoutRepository.getAll();

    List<MemberInfo> infos = [];

    for (final member in members) {
      final workoutsOfMember =
          workouts.where((it) => it.memberId == member.id).toList();
      final sum = transactions.fold<double>(
          0.0,
          (prev, transaction) => transaction.memberId == member.id
              ? prev + transaction.typedAmount
              : prev);
      infos.add(MemberInfo(member, sum, workoutsOfMember.length));
    }

    return infos.toList();
  }
}
