import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';

import 'app_router.dart';
import '../core/device/sensor_helper.dart';
import '../core/device/audio_player.dart';
import '../features/workout/workout_injection.dart' as workout_di;

final sl = GetIt.instance;

Future<void> init() async {
  // 1. Core / Device Hardware
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Initialize Audio & Sensors
  sl.registerLazySingleton<SensorHelper>(() => SensorHelperImpl());
  sl.registerLazySingleton<AppAudioPlayer>(
    () => AppAudioPlayerImpl(FlutterTts(), AudioPlayer()),
  );

  // 2. Feature: Workout
  await workout_di.initWorkoutFeature();

  // 3. Router (Needs WorkoutBloc from the feature)
  sl.registerLazySingleton<AppRouter>(() => AppRouter());
}
