import 'dart:convert';
import 'dart:io';

import 'package:tgm/api/form_data.dart';
import 'package:tgm/domain/budget/budget.dart';
import 'package:tgm/domain/budget/budget_repository.dart';
import 'package:tgm/domain/logger.dart';
import 'package:tgm/domain/member.dart';
import 'package:tgm/domain/member_repository.dart';
import 'package:tgm/domain/role/role.dart';
import 'package:tgm/domain/role/role_repository.dart';
import 'package:tgm/domain/transaction/transaction.dart';
import 'package:tgm/domain/transaction/transaction_repository.dart';
import 'package:tgm/domain/workout/workout.dart';
import 'package:tgm/domain/workout/workout_info.dart';
import 'package:tgm/domain/workout/workout_repository.dart';

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
    if (formData.getStringValue("member-id") == "--") {
      return null;
    }
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
      Logger.error("[ADD-TRANSACTION]: error: $e");
      return null;
    }
  }

  static Future<FormData> _formData(HttpRequest request) async {
    final String body = await utf8.decodeStream(request);
    return FormData.from(body);
  }

  static Future<void> removeTransaction(HttpRequest request) async {
    final formData = await _formData(request);
    TransactionRepository.delete(formData.getStringValue("id"));
  }

  static Future<WorkoutInfo> addWorkout(HttpRequest request) async {
    final formData = await _formData(request);
    final memberId = formData.getStringValue("member-id");
    final workout = Workout.create(memberId);
    WorkoutRepository.add(workout);
    return WorkoutInfo(
        workout,
        MemberRepository.getById(memberId) ??
            Logger.fallback("[ADD-WORKOUT]: $memberId not found",
                Member.deleted(memberId)));
  }

  static Future<void> removeRole(HttpRequest request) async {
    final formData = await _formData(request);
    RoleRepository.delete(formData.getStringValue("id"));
  }

  static Future<RoleInfo> addRole(HttpRequest request) async {
    final formData = await _formData(request);
    final memberId = formData.getStringValue("member-id");
    final name = formData.getStringValue("name");
    final role = Role.create(name, memberId);
    RoleRepository.add(role);
    return RoleInfo(
        role,
        MemberRepository.getById(memberId) ??
            Logger.fallback(
                "[ADD-ROLE]: $memberId not found", Member.deleted(memberId)));
  }

  static Future<void> setBudget(HttpRequest request) async {
    final formData = await _formData(request);
    BudgetRepository.set(
        Budget(double.parse(formData.getStringValue("value"))));
  }
}
