import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../datasources/workout_local_datasource.dart';

abstract class WorkoutRepository {
  Future<Either<Failure, int>> getHighScore();
  Future<Either<Failure, void>> saveWorkout(int reps);
}

class WorkoutRepositoryImpl implements WorkoutRepository {
  final WorkoutLocalDataSource localDataSource;

  WorkoutRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, int>> getHighScore() async {
    try {
      final score = await localDataSource.getHighScore();
      return Right(score);
    } catch (e) {
      return Left(CacheFailure(message: "Failed to load high score"));
    }
  }

  @override
  Future<Either<Failure, void>> saveWorkout(int reps) async {
    try {
      await localDataSource.saveWorkout(reps);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: "Failed to save workout"));
    }
  }
}
