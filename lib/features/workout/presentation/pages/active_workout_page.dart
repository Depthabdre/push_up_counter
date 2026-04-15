import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/workout_bloc.dart';

class ActiveWorkoutPage extends StatelessWidget {
  const ActiveWorkoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope<bool>(
      canPop:
          false, // Prevent them from accidentally swiping back during a workout
      child: Scaffold(
        backgroundColor:
            Colors.black, // Pure black saves battery on OLED screens
        body: BlocConsumer<WorkoutBloc, WorkoutState>(
          listener: (context, state) {
            if (state is WorkoutFinished) {
              // When the workout finishes, show a cool popup then go home
              _showFinishDialog(context, state, theme);
            }
          },
          builder: (context, state) {
            int currentReps = 0;
            bool isChestNear = false;

            if (state is WorkoutActive) {
              currentReps = state.currentReps;
              isChestNear = state.isChestNear; // True when chest is close!
            }

            return Stack(
              children: [
                // THE BACKGROUND FLASH EFFECT
                // If chest is near, the whole screen glows slightly green
                AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  color: isChestNear
                      ? theme.primaryColor.withValues(alpha: 0.2)
                      : Colors.transparent,
                ),

                SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),

                      // THE MASSIVE COUNTER
                      Center(
                        child: Text(
                          '$currentReps',
                          style: TextStyle(
                            fontSize: 180,
                            fontWeight: FontWeight.w900,
                            height: 1.0,
                            // Number turns bright neon green when chest is near
                            color: isChestNear
                                ? theme.primaryColor
                                : Colors.white,
                          ),
                        ),
                      ),

                      const Spacer(),

                      // FINISH BUTTON
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: ElevatedButton(
                          onPressed: () {
                            // Tell BLoC to stop sensors, save data, and calculate high scores
                            context.read<WorkoutBloc>().add(FinishWorkout());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                theme.colorScheme.secondary, // Cyberpunk Red
                            shadowColor: theme.colorScheme.secondary.withValues(
                              alpha: 0.5,
                            ),
                          ),
                          child: const Text(
                            'FINISH & SAVE',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showFinishDialog(
    BuildContext context,
    WorkoutFinished state,
    ThemeData theme,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: theme.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            state.isNewRecord ? 'NEW RECORD! 🏆' : 'WORKOUT COMPLETE',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: state.isNewRecord
                  ? theme.colorScheme.secondary
                  : theme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'You completed ${state.finalReps} reps.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                context.pop(); // Go back to Home Screen
              },
              child: const Text('BACK TO BASE'),
            ),
          ],
        );
      },
    );
  }
}
