import 'dart:math';

class Workout {
  final String id;
  final String memberId;
  final DateTime timestamp;
  Workout(this.id, this.memberId, this.timestamp);
  Workout.create(this.memberId)
      : id =
            "workout-${Random().nextInt(999999999)}-${DateTime.now().millisecondsSinceEpoch}",
        timestamp = DateTime.now();
}
