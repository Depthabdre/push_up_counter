part of 'workout_bloc.dart';

abstract class WorkoutState extends Equatable {
  const WorkoutState();
  @override
  List<Object> get props => [];
}

class WorkoutInitial extends WorkoutState {
  final int highScore;
  const WorkoutInitial(this.highScore);
  @override
  List<Object> get props => [highScore];
}

class WorkoutActive extends WorkoutState {
  final int currentReps;
  final bool isChestNear; // Used to flash the screen green
  const WorkoutActive({required this.currentReps, required this.isChestNear});
  @override
  List<Object> get props => [currentReps, isChestNear];
}

class WorkoutFinished extends WorkoutState {
  final int finalReps;
  final bool isNewRecord;
  const WorkoutFinished(this.finalReps, this.isNewRecord);
}
