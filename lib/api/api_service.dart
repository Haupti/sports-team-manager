import 'dart:convert';
import 'dart:io';

import 'package:tgm/api/form_data.dart';
import 'package:tgm/domain/member.dart';
import 'package:tgm/domain/member_repository.dart';

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

  static Future<FormData> _formData(HttpRequest request) async {
    final String body = await utf8.decodeStream(request);
    print(body);
    return FormData.from(body);
  }
}
