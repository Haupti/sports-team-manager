import 'dart:convert';
import 'dart:io';

import 'package:tgm/api/api_service.dart';
import 'package:tgm/api/form_data.dart';
import 'package:tgm/domain/login/authentication.dart';
import 'package:tgm/domain/role/role.dart';
import 'package:tgm/domain/transaction/transaction_info_service.dart';
import 'package:tgm/global.dart';
import 'package:tgm/logging.dart';
import 'package:tgm/ui/component/budget_components.dart';
import 'package:tgm/ui/component/member_manager.dart';
import 'package:tgm/ui/component/overview.dart';
import 'package:tgm/ui/component/role_components.dart';
import 'package:tgm/ui/component/transactions.dart';
import 'package:tgm/ui/component/utilities.dart';
import 'package:tgm/ui/component/workout_manager.dart';
import 'package:tgm/ui/html.dart';
import 'package:tgm/ui/page/base_page.dart';
import 'package:tgm/ui/page/login_page.dart';

Future<void> run() async {
  final server = await HttpServer.bind(InternetAddress.anyIPv4, Global.port);
  await for (HttpRequest request in server) {
    try {
      switch ((request.method, request.uri.path)) {
        case ("POST", "/api/login"):
          await handleAuthRequest(request);
          continue;
      }

      final auth = Authentication.from(request.headers);
      if (auth.isUnauthorized) {
        request.respond(loginPage());
        continue;
      }
      bool handled = await handleUiRequest(request, auth);
      if (handled) {
        continue;
      }
      handled = await handleApiRequest(request, auth);
      if (handled) {
        continue;
      }
      request.notFound();
    } on Exception catch (e) {
      FileLogger.logException(e);
      request.serverError();
    } on Error catch (e) {
      FileLogger.logError(e);
      request.serverError();
    }
  }
}

Future<bool> handleUiRequest(HttpRequest request, Authentication auth) async {
  switch ((request.method, request.uri.path)) {
    case ("GET", "/"):
      request.respond(basePage(OverviewComponents.main(), auth));
      return true;
    case ("GET", "/workouts"):
      request.respond(basePage(WorkoutManagerComponents.overview(), auth));
      return true;
    case ("GET", "/transactions"):
      request.respond(basePage(TransactionComponents.history(), auth));
      return true;
    case ("GET", "/roles"):
      request.respond(basePage(RoleComponents.roleInfoPage(), auth));
      return true;
    case ("GET", "/manage-budget"):
      if (!auth.isAdmin) {
        request.forbidden();
      } else {
        request.respond(basePage(BudgetComponents.managementView(), auth));
      }
      return true;
    case ("GET", "/transactions-manager"):
      if (!auth.isAtLeastMod) {
        request.forbidden();
      } else {
        request.respond(
            basePage(TransactionComponents.manageTransactions(auth), auth));
      }
      return true;
    case ("GET", "/workout-manager"):
      if (!auth.isAtLeastMod) {
        request.forbidden();
      } else {
        request.respond(basePage(WorkoutManagerComponents.main(), auth));
      }
      return true;
    case ("POST", "/api/add-member"):
      if (!auth.isAdmin) {
        request.forbidden();
      } else {
        final member = await ApiService.addMember(request);
        request.respond(MemberManagerComponents.memberToRow(member));
      }
      return true;
    case ("GET", "/member-manager"):
      if (!auth.isAdmin) {
        request.forbidden();
      } else {
        request.respond(basePage(MemberManagerComponents.main(), auth));
      }
      return true;
    case ("GET", "/role-manager"):
      if (!auth.isAdmin) {
        request.forbidden();
      } else {
        request.respond(basePage(RoleComponents.roleManagementPage(), auth));
      }
      return true;
  }
  return false;
}

Future<bool> handleApiRequest(HttpRequest request, Authentication auth) async {
  switch ((request.method, request.uri.path)) {
    case ("GET", "/logout"):
      handleLogoutRequest(request);
      return true;
    case ("POST", "/api/delete-member"):
      if (!auth.isAdmin) {
        request.forbidden();
      } else {
        await ApiService.removeMember(request);
        request.respond(UtilityComponents.empty());
      }
      return true;
    case ("POST", "/api/delete-transaction"):
      if (!auth.isAdmin) {
        request.forbidden();
      } else {
        await ApiService.removeTransaction(request);
        request.respond(UtilityComponents.empty());
      }
      return true;
    case ("POST", "/api/delete-role"):
      if (!auth.isAdmin) {
        request.forbidden();
      } else {
        await ApiService.removeRole(request);
        request.respond(UtilityComponents.empty());
      }
      return true;
    case ("POST", "/api/set-budget"):
      if (!auth.isAdmin) {
        request.forbidden();
      } else {
        await ApiService.setBudget(request);
        request.respond(UtilityComponents.empty());
      }
      return true;
    case ("POST", "/api/add-role"):
      if (!auth.isAdmin) {
        request.forbidden();
      } else {
        final RoleInfo info = await ApiService.addRole(request);
        request.respond(RoleComponents.roleInfoToManagableRow(info));
      }
      return true;
    case ("POST", "/api/add-transaction"):
      if (!auth.isAtLeastMod) {
        request.forbidden();
      } else {
        final transaction = await ApiService.addTransaction(request);
        if (transaction == null) {
          request.respondClientError();
        } else {
          final info = TransactionInfoService.toInfo(transaction);
          request.respond(auth.isAdmin
              ? TransactionComponents.transactionToManagableRow(info)
              : TransactionComponents.transactionToRow(info));
        }
      }
      return true;
    case ("POST", "/api/add-workout"):
      if (!auth.isAtLeastMod) {
        request.forbidden();
      } else {
        final workoutInfo = await ApiService.addWorkout(request);
        request.respond(WorkoutManagerComponents.infoToRow(workoutInfo));
      }
      return true;
  }
  return false;
}

Future<void> handleAuthRequest(HttpRequest request) async {
  String content = await utf8.decodeStream(request);
  final data = FormData.from(content);
  final username = data.getStringValue("username");
  final password = data.getStringValue("password");
  final auth = Authentication.fromAuthString("$username:$password");
  request.response.statusCode = 200;
  if (auth.isAtLeastUser) {
    request.response.headers.add("Set-Cookie",
        "username=$username; Domain=${Global.domain}; ${Global.domain == "localhost" ? "" : "Secure"}; Path=/; HttpOnly; SameSite=Lax;");
    request.response.headers.add("Set-Cookie",
        "password=$password; Domain=${Global.domain}; ${Global.domain == "localhost" ? "" : "Secure"}; Path=/; HttpOnly; SameSite=Lax;");
    request.response.headers.add("HX-Refresh", "true");
  }
  request.response.close();
}

void handleLogoutRequest(HttpRequest request) {
  request.response.statusCode = 200;
  request.response.headers.add("Set-Cookie",
      "username= ; Expires=Thu, 01 Jan 1970 00:00:01 GMT; Domain=${Global.domain}; ${Global.domain == "localhost" ? "" : "Secure"}; Path=/; HttpOnly; SameSite=Lax;");
  request.response.headers.add("Set-Cookie",
      "password= ; Expires=Thu, 01 Jan 1970 00:00:01 GMT; Domain=${Global.domain}; ${Global.domain == "localhost" ? "" : "Secure"}; Path=/; HttpOnly; SameSite=Lax;");
  request.response.headers.add("HX-Refresh", "true");
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

  void notFound() {
    response.headers.add("Content-Type", "text/html");
    response.statusCode = 404;
    response.write("<html><body><h1> 404 </h1></body></html>");
    response.close();
  }
  void serverError() {
    response.headers.add("Content-Type", "text/html");
    response.statusCode = 500;
    response.write("<html><body><h1> 500 </h1></body></html>");
    response.close();
  }
}
