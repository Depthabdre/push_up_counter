import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../app/injection_container.dart';
import '../bloc/workout_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _highScore = 0;
  int _totalReps = 0;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final prefs = sl<SharedPreferences>();
    setState(() {
      _highScore = prefs.getInt('CACHED_HIGH_SCORE') ?? 0;
      _totalReps = prefs.getInt('CACHED_TOTAL_REPS') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              // THE TITLE
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [theme.primaryColor, Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: const Text(
                  'IRON REP',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 64,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                    letterSpacing: -2.0,
                    shadows: [
                      Shadow(
                        color: Colors.black54,
                        offset: Offset(2, 4),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 60),

              // THE STATS BOARD
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard('HIGH SCORE', '$_highScore', theme),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard('LIFETIME', '$_totalReps', theme),
                  ),
                ],
              ),

              const Spacer(),

              // INSTRUCTIONS
              const Text(
                'PLACE PHONE ON FLOOR.\nLOWER CHEST TO SCREEN.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 30),

              // THE GIANT START BUTTON
              ElevatedButton(
                onPressed: () {
                  // 1. Tell the BLoC to start the sensors and audio
                  context.read<WorkoutBloc>().add(StartWorkout());
                  // 2. Go to the workout screen
                  context.push('/workout').then((_) {
                    // Reload stats when they come back from a workout!
                    _loadStats();
                  });
                },
                child: const Text('START WORKOUT'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [theme.cardColor, theme.cardColor.withValues(alpha: 0.5)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.primaryColor.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              color: Colors.grey[200], // Whitish gray 200
              fontSize: 48,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
