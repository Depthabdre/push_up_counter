import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:push_up_counter/app/app_router.dart';
import 'package:push_up_counter/app/app_theme.dart';
import 'package:push_up_counter/app/injection_container.dart';
import 'package:push_up_counter/features/workout/presentation/bloc/workout_bloc.dart';

void main() async {
  // 1. Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Lock the app to Portrait mode (You don't want the screen rotating while doing pushups)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // 3. Initialize Dependency Injection (GetIt)
  await init();

  // 4. Get the Router from DI
  final appRouter = sl<AppRouter>();

  // 5. Run the App
  runApp(MyApp(appRouter: appRouter));
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;

  const MyApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // This makes the Smart Coach BLoC available to the entire app
        BlocProvider<WorkoutBloc>(
          create: (_) => sl<WorkoutBloc>(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Iron Rep',
        theme: AppTheme.darkTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter.router,
      ),
    );
  }
}
