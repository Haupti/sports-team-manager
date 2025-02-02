import 'dart:io';

import 'package:tgm/api/api_service.dart';
import 'package:tgm/ui/component/member_manager.dart';
import 'package:tgm/ui/component/overview.dart';
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
      case ("POST", "/api/add-member"):
        final member = await ApiService.addMember(request);
        request.respond(MemberManagerComponents.memberToRow(member));
        break;
      case ("POST", "/api/delete-member"):
        await ApiService.removeMember(request);
        request.respond(UtilityComponents.empty());
        break;
    }
  }
}

extension on HttpRequest {
  void respond(HTML html) {
    response.headers.add("Content-Type", "text/html");
    response.write(html.render());
    response.close();
  }
}
