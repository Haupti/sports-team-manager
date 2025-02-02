import 'package:tgm/domain/overview/member_info.dart';
import 'package:tgm/domain/overview/overview_service.dart';
import 'package:tgm/ui/html.dart';

class OverviewComponents {
  static HTML main() {
    final List<MemberInfo> memberInfos = OverviewService.getAllMemberInfos();
    return HTML("""
<table>
  <tr>
    <th>
      Name
    </th>
    <th>
      Workouts
    </th>
    <th>
      Fine (Euro)
    </th>
  </tr>
  ${memberInfos.map((it) => infoToRow(it).render()).join("\n")}
</table>
""");
  }

  static HTML infoToRow(MemberInfo info) {
    return HTML("""
<tr>
  <td>${info.member.name}</td>
  <td>${info.workouts}</td>
  <td>${info.openFine}</td>
</tr>
""");
  }
}
