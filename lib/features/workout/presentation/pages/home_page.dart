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
      body: Stack(
        children: [
          // Background ambient glowing orb for a modern joyful feel!
          Positioned(
            top: -150,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.primaryColor.withValues(alpha: 0.15),
                boxShadow: [
                  BoxShadow(
                    color: theme.primaryColor.withValues(alpha: 0.2),
                    blurRadius: 100,
                    spreadRadius: 50,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -100,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.secondary.withValues(alpha: 0.1),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.secondary.withValues(alpha: 0.15),
                    blurRadius: 100,
                    spreadRadius: 50,
                  ),
                ],
              ),
            ),
          ),
          // Main Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  // THE TITLE
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [theme.primaryColor, theme.colorScheme.secondary],
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
                        // Removed aggressive italics for a cleaner, modern look
                        letterSpacing: -1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Time to shine ✨',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: theme.colorScheme.secondary,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 50),

                  // THE STATS BOARD
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'HIGH SCORE',
                          '$_highScore',
                          theme,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard('LIFETIME', '$_totalReps', theme),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // INSTRUCTIONS (Friendly & Encouraging)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: theme.cardColor.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.place_outlined,
                          color: Colors.white70,
                          size: 28,
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Place phone on the floor and lower your chest to the screen to count!',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      // Premium glowing shadow effect on button
                      shadowColor: theme.primaryColor.withValues(alpha: 0.5),
                      elevation: 12,
                    ),
                    child: const Text('START WORKOUT'),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: theme.cardColor.withValues(
          alpha: 0.8,
        ), // Smooth clear background
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 54,
              fontWeight: FontWeight.w800, // Clean heavy weight
            ),
          ),
        ],
      ),
    );
  }
}
