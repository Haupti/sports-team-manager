import 'dart:convert';
import 'dart:io';

import 'package:tgm/api/form_data.dart';
import 'package:tgm/domain/member.dart';
import 'package:tgm/domain/member_repository.dart';
import 'package:tgm/domain/transaction/transaction.dart';
import 'package:tgm/domain/transaction/transaction_repository.dart';

class ApiService {
  static Future<Member> addMember(HttpRequest request) async {
    final formData = await _formData(request);
    final Member member = Member.create(formData.getStringValue("name"));
    MemberRepository.add(member);
    return member;
  }

  static removeMember(HttpRequest request) async {
    final formData = await _formData(request);
    MemberRepository.delete(formData.getStringValue("id"));
  }

  static Future<Transaction?> addTransaction(HttpRequest request) async {
    final formData = await _formData(request);
    final type = formData.getStringValue("type");
    Transaction t;
    try {
      switch (type) {
        case "fine":
          t = Transaction.createFine(
              formData.getStringValue("member-id"),
              formData.getDoubleValue("amount"),
              Transaction.translateReason(formData.getStringValue("reason")));
        case "settlement":
          t = Transaction.createSettlement(formData.getStringValue("member-id"),
              formData.getDoubleValue("amount"));
        default:
          throw "unknown type";
      }
      TransactionRepository.add(t);
      return t;
    } catch (e) {
      return null;
    }
  }

  static Future<FormData> _formData(HttpRequest request) async {
    final String body = await utf8.decodeStream(request);
    print(body);
    return FormData.from(body);
  }
}
