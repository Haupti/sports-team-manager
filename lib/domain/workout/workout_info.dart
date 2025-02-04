import 'package:tgm/domain/member.dart';
import 'package:tgm/domain/workout/workout.dart';

class WorkoutInfo {
  final Workout workout;
  final Member member;
  WorkoutInfo(this.workout, this.member);

  String get memberName => member.name;
  DateTime get timestamp => workout.timestamp;
}
