import 'package:tgm/domain/role/role.dart';
import 'package:tgm/domain/role/role_service.dart';
import 'package:tgm/ui/html.dart';

class InfoComponents {
  static HTML infoPage() {
    final List<RoleInfo> roleInfos = RoleService.getAll();
    return HTML("""
<h1> Team Info </h1>
<h2> Roles </h2>
<table>
  <tr>
    <th>Role</th>
    <th>Bearer</th>
  </tr>
  ${roleInfos.map((it) => """
<tr>
  <td>${it.role.name}</td>
  <td>${it.bearer.name}</td>
</tr>
    """).join("\n")}
</table>
""");
  }
}
