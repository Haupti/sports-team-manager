import 'package:tgm/domain/budget/budget_repository.dart';
import 'package:tgm/domain/overview/member_info.dart';
import 'package:tgm/domain/overview/overview_service.dart';
import 'package:tgm/ui/html.dart';

class OverviewComponents {
  static HTML main() {
    final List<MemberInfo> memberInfos = OverviewService.getAllMemberInfos();
    final double budget = BudgetRepository.getCurrent();
    return HTML("""
<h1> Overview </h1>
<p><strong> Current budget $budget </strong></p>
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
