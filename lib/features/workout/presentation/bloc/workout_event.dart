part of 'workout_bloc.dart';

abstract class WorkoutEvent extends Equatable {
  const WorkoutEvent();
  @override
  List<Object> get props => [];
}

class StartWorkout extends WorkoutEvent {}

class ProximityChanged extends WorkoutEvent {
  final bool isNear;
  const ProximityChanged(this.isNear);
}

class FinishWorkout extends WorkoutEvent {}

class StruggleTimerTicked
    extends WorkoutEvent {} // Triggered if they pause for 5 secs
