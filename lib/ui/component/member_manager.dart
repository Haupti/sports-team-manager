import 'package:tgm/domain/member.dart';
import 'package:tgm/domain/member_repository.dart';
import 'package:tgm/ui/html.dart';

class MemberManagerComponents {
  static HTML main() {
    final List<Member> members = MemberRepository.getAll();
    return HTML("""
<h1> Members </h1>
<table>
  <tr>
    <th>Delete</th>
    <th>Name</th>
    <th></th>
  </tr>
  ${members.map((it) => memberToRow(it).render()).join("\n")}
  <tr id="input-row">
    <td><label for="name-name" type="text">New Member:</label></td>
    <td><input id="name-input" name="name" type="text"/></td>
    <td>
      <button 
        hx-include=[name="name"]
        hx-post="/api/add-member"
        hx-swap="beforebegin" 
        hx-target="#input-row"
        hx-on::after-request="\$('#name-input').val('')"
        />
        Submit
      </button>
    </td>
  </tr>
</table>

""");
  }

  static HTML memberToRow(Member member) {
    return HTML("""
<tr id="member-row-${member.id}">
  <td>
    <button hx-post="/api/delete-member" hx-swap="outerHTML" hx-vals='{"id":"${member.id}"}' hx-target="#member-row-${member.id}">&#128465;</button>
  </td>
  <td>
    ${member.name}
  </td>
  <td>
  </td>
</tr>
""");
  }
}
