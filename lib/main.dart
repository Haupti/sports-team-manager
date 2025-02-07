import 'dart:convert';
import 'dart:io';

import 'package:tgm/api/api_service.dart';
import 'package:tgm/api/form_data.dart';
import 'package:tgm/domain/login/authentication.dart';
import 'package:tgm/domain/transaction/transaction_info_service.dart';
import 'package:tgm/global.dart';
import 'package:tgm/ui/component/member_manager.dart';
import 'package:tgm/ui/component/overview.dart';
import 'package:tgm/ui/component/transactions.dart';
import 'package:tgm/ui/component/utilities.dart';
import 'package:tgm/ui/component/workout_manager.dart';
import 'package:tgm/ui/html.dart';
import 'package:tgm/ui/page/base_page.dart';
import 'package:tgm/ui/page/login_page.dart';

Future<void> run() async {
  final server = await HttpServer.bind(InternetAddress.anyIPv4, 3000);
  await for (HttpRequest request in server) {
    switch ((request.method, request.uri.path)) {
      case ("POST", "/api/login"):
        await handleAuthRequest(request);
        continue;
    }

    final auth = Authentication.from(request.headers);
    if (auth.level < 1) {
      request.respond(loginPage());
      continue;
    }
    switch ((request.method, request.uri.path)) {
      case ("GET", "/"):
        request.respond(basePage(OverviewComponents.main(), auth));
        break;
      case ("GET", "/workouts"):
        request.respond(basePage(WorkoutManagerComponents.overview(), auth));
        break;
      case ("GET", "/transactions"):
        request.respond(basePage(TransactionComponents.history(), auth));
        break;
      case ("POST", "/api/add-transaction"):
        if (auth.level < 2) {
          request.forbidden();
        } else {
          final transaction = await ApiService.addTransaction(request);
          if (transaction == null) {
            request.respondClientError();
          } else {
            final info = TransactionInfoService.toInfo(transaction);
            request
                .respond(TransactionComponents.transactionToManagableRow(info));
          }
        }
        break;
      case ("POST", "/api/add-workout"):
        if (auth.level < 2) {
          request.forbidden();
        } else {
          final workoutInfo = await ApiService.addWorkout(request);
          request.respond(WorkoutManagerComponents.infoToRow(workoutInfo));
        }
        break;
      case ("GET", "/transactions-manager"):
        if (auth.level < 2) {
          request.forbidden();
        } else {
          request.respond(basePage(TransactionComponents.manageTransactions(), auth));
        }
        break;
      case ("GET", "/workout-manager"):
        if (auth.level < 2) {
          request.forbidden();
        } else {
          request.respond(basePage(WorkoutManagerComponents.main(), auth));
        }
        break;
      case ("POST", "/api/add-member"):
        if (auth.level < 5) {
          request.forbidden();
        } else {
          final member = await ApiService.addMember(request);
          request.respond(MemberManagerComponents.memberToRow(member));
        }
        break;
      case ("GET", "/member-manager"):
        if (auth.level < 5) {
          request.forbidden();
        } else {
          request.respond(basePage(MemberManagerComponents.main(), auth));
        }
        break;
      case ("POST", "/api/delete-member"):
        if (auth.level < 5) {
          request.forbidden();
        } else {
          await ApiService.removeMember(request);
          request.respond(UtilityComponents.empty());
        }
        break;
      case ("POST", "/api/delete-transaction"):
        if (auth.level < 5) {
          request.forbidden();
        } else {
          await ApiService.removeTransaction(request);
          request.respond(UtilityComponents.empty());
        }
        break;
    }
  }
}

Future<void> handleAuthRequest(HttpRequest request) async {
  String content = await utf8.decodeStream(request);
  final data = FormData.from(content);
  final username = data.getStringValue("username");
  final password = data.getStringValue("password");
  final auth = Authentication.fromAuthString("$username:$password");
  request.response.statusCode = 200;
  if (auth.level >= 1) {
    request.response.headers.add("Set-Cookie",
        "username=$username; Domain=${Global.domain}; ${Global.domain == "localhost" ? "" : "Secure"}; Path=/; HttpOnly");
    request.response.headers.add("Set-Cookie",
        "password=$password; Domain=${Global.domain}; ${Global.domain == "localhost" ? "" : "Secure"}; Path=/; HttpOnly");
    request.response.headers.add("HX-Refresh", "true");
  }
  request.response.close();
}

extension on HttpRequest {
  void respond(HTML html) {
    response.headers.add("Content-Type", "text/html");
    response.statusCode = 200;
    response.write(html.render());
    response.close();
  }

  void respondClientError() {
    response.statusCode = 400;
    response.close();
  }

  void forbidden() {
    response.statusCode = 403;
    response.close();
  }
}
