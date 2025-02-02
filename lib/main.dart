import 'dart:io';

import 'package:tgm/api/api_service.dart';
import 'package:tgm/domain/transaction/transaction_info_service.dart';
import 'package:tgm/ui/component/member_manager.dart';
import 'package:tgm/ui/component/overview.dart';
import 'package:tgm/ui/component/transactions.dart';
import 'package:tgm/ui/component/utilities.dart';
import 'package:tgm/ui/html.dart';
import 'package:tgm/ui/page/base_page.dart';

Future<void> run() async {
  final server = await HttpServer.bind(InternetAddress.anyIPv4, 3000);
  await for (HttpRequest request in server) {
    switch ((request.method, request.uri.path)) {
      case ("GET", "/"):
        request.respond(basePage(OverviewComponents.main()));
        break;
      case ("GET", "/member-manager"):
        request.respond(basePage(MemberManagerComponents.main()));
        break;
      case ("GET", "/transactions"):
        request.respond(basePage(TransactionComponents.history()));
        break;
      case ("GET", "/transactions-manager"):
        request.respond(basePage(TransactionComponents.manageTransactions()));
        break;
      case ("POST", "/api/add-member"):
        final member = await ApiService.addMember(request);
        request.respond(MemberManagerComponents.memberToRow(member));
        break;
      case ("POST", "/api/delete-member"):
        await ApiService.removeMember(request);
        request.respond(UtilityComponents.empty());
        break;
      case ("POST", "/api/add-transaction"):
        final transaction = await ApiService.addTransaction(request);
        if (transaction == null) {
          request.respondClientError();
        } else {
          final info = TransactionInfoService.toInfo(transaction);
          request.respond(TransactionComponents.transactionToRow(info));
        }
        break;
    }
  }
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
}
