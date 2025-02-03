import 'package:tgm/domain/workout/workout.dart';

class WorkoutRepository {
  static List<Workout> _workouts = [];

  static List<Workout> getAll() {
    return _workouts;
  }

  static void add(Workout t) {
    _workouts.add(t);
  }

  static void delete(String id) {
    _workouts = _workouts.where((it) => id != it.memberId).toList();
  }
}
