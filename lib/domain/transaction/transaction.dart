import 'dart:math';

enum TransactionType {
  fine,
  settlement;

  static TransactionType? from(String value) {
    switch (value) {
      case "fine":
        return TransactionType.fine;
      case "settlement":
        return TransactionType.settlement;
      default:
        return null;
    }
  }
}

class Transaction {
  final DateTime timestamp;
  final String id;
  final String memberId;
  final double amount;
  final String reason;
  final TransactionType type;
  Transaction(this.id, this.timestamp, this.memberId, this.amount, this.reason,
      this.type);

  Transaction.createFine(this.memberId, this.amount, this.reason)
      : timestamp = DateTime.now(),
        type = TransactionType.fine,
        id =
            "transaction-${Random().nextInt(999999999)}-${DateTime.now().millisecondsSinceEpoch}";
  Transaction.createSettlement(this.memberId, this.amount)
      : timestamp = DateTime.now(),
        type = TransactionType.settlement,
        reason = "",
        id =
            "transaction-${Random().nextInt(999999999)}-${DateTime.now().millisecondsSinceEpoch}";

  double get typedAmount => type == TransactionType.fine ? amount : -1 * amount;

  static String translateReason(String stringValue) {
    switch (stringValue) {
      case "too-late":
        return "Arrived late";
      case "wrong-registration":
        return "Incorrect registration";
      case "no-registration":
        return "No registration";
      case "too-late-match-day":
        return "Arrived late at match day";
      case "wrong-registration-match-day":
        return "Wrong registration for match day";
      case "no-registration-match-day":
        return "No registration for match day";
      default:
        return stringValue;
    }
  }
}
