import 'package:tgm/domain/member_repository.dart';
import 'package:tgm/ui/html.dart';

class WorkoutManagerComponents {
  static HTML main() {
    final members = MemberRepository.getAll();
    return HTML("""
<h1> Workouts </h1>
<form hx-post="/api/add-workout" hx-swap="none">
    <label for="affected-member">Affected Member</label>
    <select id="affected-member" name="member-id" style="width: 100%;">
        <option value="--">please select</option>
        ${members.map((it) => """<option value="${it.id}">${it.name}</option>""").join("\n")}
    </select>
    <input style="margin-top: 8px;" type="submit" value="Submit"/>
</form>
""");
  }
}
