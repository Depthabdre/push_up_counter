import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Import your future pages here
import '../features/workout/presentation/pages/home_page.dart';
import '../features/workout/presentation/pages/active_workout_page.dart';

class AppRouter {
  late final GoRouter router = GoRouter(
    initialLocation: '/splash',

    routes: [
      // 1. SPLASH SCREEN
      GoRoute(
        path: '/splash',
        builder: (context, state) => const GymSplashScreen(),
      ),

      // 2. HOME SCREEN (Dashboard showing high scores and Start button)
      GoRoute(path: '/home', builder: (context, state) => const HomePage()),

      // 3. ACTIVE WORKOUT SCREEN (The giant counter on the floor)
      GoRoute(
        path: '/workout',
        builder: (context, state) => const ActiveWorkoutPage(),
      ),
    ],
  );
}

// --- MINIMAL GYM SPLASH SCREEN ---
class GymSplashScreen extends StatefulWidget {
  const GymSplashScreen({super.key});

  @override
  State<GymSplashScreen> createState() => _GymSplashScreenState();
}

class _GymSplashScreenState extends State<GymSplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simply wait 2 seconds and go to the Home screen (No Auth checking needed!)
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        context.go('/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Icon Image
            Image.asset('assets/images/app_icon.png', width: 140, height: 140),
            const SizedBox(
              height: 48,
            ), // Added spacing to componsate for text removal
            const Text(
              'DROP AND GIVE ME 20',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
