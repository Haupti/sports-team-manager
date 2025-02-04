import 'package:tgm/domain/member.dart';
import 'package:tgm/domain/member_repository.dart';
import 'package:tgm/domain/workout/workout_info.dart';
import 'package:tgm/domain/workout/workout_repository.dart';

class WorkoutInfoService {
  static List<WorkoutInfo> getAll() {
    final member =
        MemberRepository.getAll().fold<Map<String, Member>>({}, (p, member) {
      p[member.id] = member;
      return p;
    });

    final workouts = WorkoutRepository.getAll();

    final List<WorkoutInfo> infos = [];
    for (final workout in workouts) {
      infos.add(WorkoutInfo(workout,
          member[workout.memberId] ?? Member.deleted(workout.memberId)));
    }

    return infos;
  }
}
