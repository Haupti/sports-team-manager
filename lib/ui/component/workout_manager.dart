import 'package:tgm/domain/date_utils.dart';
import 'package:tgm/domain/member_repository.dart';
import 'package:tgm/domain/workout/workout_info.dart';
import 'package:tgm/domain/workout/workout_info_service.dart';
import 'package:tgm/ui/html.dart';

class WorkoutManagerComponents {
  static HTML main() {
    final members = MemberRepository.getAll();
    return HTML("""
<h1> Workouts </h1>
<form
  id="workouts-form"
  hx-post="/api/add-workout"
  hx-swap="afterend"
  hx-target="#workout-history-heading"
  hx-on::after-request="\$('#workouts-form').trigger('reset')"
>
    <label for="affected-member">Affected Member</label>
    <select id="affected-member" name="member-id" style="width: 100%;">
        <option value="--">please select</option>
        ${members.map((it) => """<option value="${it.id}">${it.name}</option>""").join("\n")}
    </select>
    <input style="margin-top: 8px;" type="submit" value="Submit"/>
</form>
${workoutHistory().render()}
""");
  }

  static HTML overview() {
    final infos = WorkoutInfoService.getAll();
    return HTML("""
<h1> Workout-History </h1>
<table>
  <tr id="workout-history-heading">
    <td>Name</td>
    <td>Date</td>
  </tr>
  ${infos.map((it) => infoToRow(it).render()).join("\n")}
</table>
""");
  }

  static HTML workoutHistory() {
    final infos = WorkoutInfoService.getAll();
    return HTML("""
<h2> History </h2>
<table>
  <tr id="workout-history-heading">
    <td>Name</td>
    <td>Date</td>
  </tr>
  ${infos.map((it) => infoToRow(it).render()).join("\n")}
</table>
""");
  }

  static HTML infoToRow(WorkoutInfo info) {
    return HTML("""
<tr>
  <td>${info.memberName}</td>
  <td>${info.timestamp.prettyDate()}</td>
</tr>
""");
  }
}
