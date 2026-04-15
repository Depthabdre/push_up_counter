import 'package:shared_preferences/shared_preferences.dart';

abstract class WorkoutLocalDataSource {
  Future<int> getHighScore();
  Future<int> getTotalReps(); // Bonus: Track total lifetime pushups!
  Future<void> saveWorkout(int repsDoneToday);
}

const String CACHED_HIGH_SCORE = 'CACHED_HIGH_SCORE';
const String CACHED_TOTAL_REPS = 'CACHED_TOTAL_REPS';

class WorkoutLocalDataSourceImpl implements WorkoutLocalDataSource {
  final SharedPreferences sharedPreferences;

  WorkoutLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<int> getHighScore() async {
    return sharedPreferences.getInt(CACHED_HIGH_SCORE) ?? 0;
  }

  @override
  Future<int> getTotalReps() async {
    return sharedPreferences.getInt(CACHED_TOTAL_REPS) ?? 0;
  }

  @override
  Future<void> saveWorkout(int repsDoneToday) async {
    // 1. Update Lifetime Total
    int currentTotal = sharedPreferences.getInt(CACHED_TOTAL_REPS) ?? 0;
    await sharedPreferences.setInt(
      CACHED_TOTAL_REPS,
      currentTotal + repsDoneToday,
    );

    // 2. Update High Score (Only if they beat it)
    int currentHigh = sharedPreferences.getInt(CACHED_HIGH_SCORE) ?? 0;
    if (repsDoneToday > currentHigh) {
      await sharedPreferences.setInt(CACHED_HIGH_SCORE, repsDoneToday);
    }
  }
}
