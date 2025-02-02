import 'package:tgm/domain/member.dart';
import 'package:tgm/domain/transaction/transaction.dart';

class TransactionInfo {
  final Member member;
  final Transaction transaction;
  TransactionInfo(this.member, this.transaction);

  String get memberName => member.name;
  DateTime get timestamp => transaction.timestamp;
  String get reason => transaction.reason;
  TransactionType get type => transaction.type;
}
