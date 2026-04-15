import 'package:get_it/get_it.dart';
import 'presentation/bloc/workout_bloc.dart';
import 'data/datasources/workout_local_datasource.dart';
import 'data/repositories/workout_repository_impl.dart';

final sl = GetIt.instance;

Future<void> initWorkoutFeature() async {
  // --- BLoC ---
  // Notice: No UseCases! BLoC talks directly to the Repository.
  sl.registerFactory(
    () => WorkoutBloc(repository: sl(), sensorHelper: sl(), audioPlayer: sl()),
  );

  // --- Data Layer ---
  sl.registerLazySingleton<WorkoutRepository>(
    () => WorkoutRepositoryImpl(localDataSource: sl()),
  );

  sl.registerLazySingleton<WorkoutLocalDataSource>(
    () => WorkoutLocalDataSourceImpl(sharedPreferences: sl()),
  );
}
