import 'dart:collection';

import 'package:tgm/domain/member.dart';
import 'package:tgm/domain/member_repository.dart';
import 'package:tgm/domain/transaction/transaction.dart';
import 'package:tgm/domain/transaction/transaction_info.dart';
import 'package:tgm/domain/transaction/transaction_repository.dart';

class TransactionInfoService {
  static List<TransactionInfo> getAllNewestFirst() {
    final trs = TransactionRepository.getAll();
    final ms = MemberRepository.getAll();
    final HashMap<String, Member> associatedMembers = HashMap.from({});
    for (final m in ms) {
      associatedMembers[m.id] = m;
    }

    final List<TransactionInfo> transactions = trs
        .map((it) => TransactionInfo(
              associatedMembers[it.memberId] ?? Member("deleted", "deleted"),
              it,
            ))
        .toList();
    transactions.sort((a, b) => a.timestamp.isBefore(b.timestamp) ? 1 : 0);
    return transactions;
  }

  static toInfo(Transaction transaction) {
    final Member member = MemberRepository.getAll().firstWhere(
        (it) => it.id == transaction.memberId,
        orElse: () => Member(transaction.memberId, "deleted"));
    return TransactionInfo(member, transaction);
  }
}
