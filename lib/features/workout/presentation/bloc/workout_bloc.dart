import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/workout_repository_impl.dart';
import '../../../../core/device/sensor_helper.dart';
import '../../../../core/device/audio_player.dart';

part 'workout_event.dart';
part 'workout_state.dart';

class WorkoutBloc extends Bloc<WorkoutEvent, WorkoutState> {
  final WorkoutRepository repository;
  final SensorHelper sensorHelper;
  final AppAudioPlayer audioPlayer;

  StreamSubscription<bool>? _proximitySubscription;
  Timer? _struggleTimer;

  bool _isCurrentlyNear = false;
  int _repCount = 0;

  WorkoutBloc({
    required this.repository,
    required this.sensorHelper,
    required this.audioPlayer,
  }) : super(const WorkoutInitial(0)) {
    // Setup Audio
    audioPlayer.init();

    on<StartWorkout>(_onStartWorkout);
    on<ProximityChanged>(_onProximityChanged);
    on<StruggleTimerTicked>(_onStruggleTimerTicked);
    on<FinishWorkout>(_onFinishWorkout);
  }

  Future<void> _onStartWorkout(
    StartWorkout event,
    Emitter<WorkoutState> emit,
  ) async {
    _repCount = 0;
    _isCurrentlyNear = false;

    await audioPlayer.playHypeSound('audio/boxing_bell.mp3');
    emit(WorkoutActive(currentReps: 0, isChestNear: false));

    // Listen to the phone sensor
    _proximitySubscription = sensorHelper.proximityStream.listen((isNear) {
      add(ProximityChanged(isNear));
    });
  }

  void _onProximityChanged(ProximityChanged event, Emitter<WorkoutState> emit) {
    if (state is! WorkoutActive) return;

    final bool chestCameClose = event.isNear;

    // Logic: Far -> Near (Dipping down)
    if (chestCameClose && !_isCurrentlyNear) {
      _isCurrentlyNear = true;
      emit(WorkoutActive(currentReps: _repCount, isChestNear: true));
    }
    // Logic: Near -> Far (Pushing up - REP COMPLETED!)
    else if (!chestCameClose && _isCurrentlyNear) {
      _isCurrentlyNear = false;
      _repCount++;

      _handleAudioFeedback(_repCount);
      _restartStruggleTimer(); // Reset the 5-second timer

      emit(WorkoutActive(currentReps: _repCount, isChestNear: false));
    }
  }

  void _handleAudioFeedback(int reps) {
    if (reps % 10 == 0) {
      audioPlayer.playHypeSound('audio/ronnie_yeah_buddy.mp3');
    } else {
      audioPlayer.speakNumber(reps);
    }
  }

  void _restartStruggleTimer() {
    _struggleTimer?.cancel();
    // If they haven't done a rep in 5 seconds, trigger the struggle event
    _struggleTimer = Timer(const Duration(seconds: 5), () {
      add(StruggleTimerTicked());
    });
  }

  void _onStruggleTimerTicked(
    StruggleTimerTicked event,
    Emitter<WorkoutState> emit,
  ) {
    if (state is WorkoutActive && _repCount > 0) {
      // Yell at them to keep going!
      audioPlayer.playHypeSound('audio/coach_push.mp3');
    }
  }

  Future<void> _onFinishWorkout(
    FinishWorkout event,
    Emitter<WorkoutState> emit,
  ) async {
    _proximitySubscription?.cancel();
    _struggleTimer?.cancel();

    // Fetch previous high score to check if they beat it
    final result = await repository.getHighScore();
    int previousHigh = result.fold((l) => 0, (r) => r);

    bool isNewRecord = _repCount > previousHigh;

    // Save the new workout
    await repository.saveWorkout(_repCount);

    if (isNewRecord) {
      await audioPlayer.playHypeSound('audio/crowd_cheer.mp3');
    }

    emit(WorkoutFinished(_repCount, isNewRecord));
  }

  @override
  Future<void> close() {
    _proximitySubscription?.cancel();
    _struggleTimer?.cancel();
    return super.close();
  }
}
