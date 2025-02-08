import 'package:tgm/domain/budget/budget.dart';
import 'package:tgm/domain/budget/budget_repository.dart';
import 'package:tgm/domain/overview/member_info.dart';
import 'package:tgm/domain/overview/overview_service.dart';
import 'package:tgm/ui/html.dart';

class OverviewComponents {
  static HTML main() {
    final List<MemberInfo> memberInfos = OverviewService.getAllMemberInfos();
    memberInfos.sort((a, b) => b.workouts - a.workouts);
    final Budget budget = BudgetRepository.get();
    return HTML("""
<h1> Overview </h1>
<div style="font-size: 32px; display: flex; align-items: center; gap: 8px; padding-bottom: 8px;">&#128176;<p style="padding: 0; margin: 0;"><strong>${budget.value} &#8364;</strong></p></div>
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
