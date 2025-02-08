import 'package:tgm/domain/member.dart';
import 'package:tgm/domain/member_repository.dart';
import 'package:tgm/domain/role/role.dart';
import 'package:tgm/domain/role/role_service.dart';
import 'package:tgm/ui/html.dart';

class RoleComponents {
  static HTML roleInfoPage() {
    final List<RoleInfo> roleInfos = RoleService.getAll();
    return HTML("""
<h1> Roles </h1>
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

  static HTML roleInfoToManagableRow(RoleInfo info) {
    return HTML("""
<tr id="role-${info.role.id}">
  <td>
    <button
      hx-post="/api/delete-role"
      hx-swap="outerHTML"
      hx-target="#role-${info.role.id}"
      hx-vals='{"id":"${info.role.id}"}'
      >
      &#128465;
    </button>
  </td>
  <td>${info.role.name}</td>
  <td>${info.bearer.name}</td>
</tr>
      """);
  }

  static HTML roleManagementPage() {
    final List<RoleInfo> roleInfos = RoleService.getAll();
    final List<Member> members = MemberRepository.getAll();
    return HTML("""
<h1> Roles </h1>
<h2> Add role </h2>

<form hx-post="/api/add-role" hx-swap="beforeend" hx-target="#role-overview-table">
  <div>
    <label for="role-input"> Role</label>
    <input id="role-input" type="text" name="name" required/>
  </div>
  <div>
    <label for="user-input"> Role</label>
    <select id="user-input" name="member-id">
      <option value="--">--</option>
      ${members.map((it) => """
        <option value="${it.id}">${it.name}</option>
        """).join("\n")}
    </select>
  </div>
  <input type="submit" value="Submit"/>
</form>

<h2> Overview </h2>
<table id="role-overview-table">
  <tr>
    <th></th>
    <th>Role</th>
    <th>Bearer</th>
  </tr>
  ${roleInfos.map((it) => roleInfoToManagableRow(it).render()).join("\n")}
</table>
""");
  }
}
