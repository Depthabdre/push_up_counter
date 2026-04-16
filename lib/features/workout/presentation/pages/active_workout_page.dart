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
        backgroundColor: theme
            .scaffoldBackgroundColor, // Replaced pure black with the nice new midnight blue
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
              alignment: Alignment.center,
              children: [
                // THE BACKGROUND FLASH EFFECT
                // If chest is near, the whole screen glows warmly
                AnimatedContainer(
                  duration: const Duration(
                    milliseconds: 100,
                  ), // Sped up for fast reps
                  curve: Curves.easeOut,
                  decoration: BoxDecoration(
                    gradient: isChestNear
                        ? RadialGradient(
                            colors: [
                              theme.colorScheme.secondary.withValues(
                                alpha: 0.4,
                              ), // Bright sunny glow
                              theme.primaryColor.withValues(alpha: 0.1),
                              Colors.transparent,
                            ],
                            radius: 1.5,
                          )
                        : null,
                    color: isChestNear ? null : Colors.transparent,
                  ),
                ),

                // Animated Rings when interacting
                AnimatedScale(
                  duration: const Duration(milliseconds: 150), // Sped up
                  scale: isChestNear ? 0.8 : 1.0,
                  curve: Curves.elasticOut,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150), // Sped up
                    width: 280, // Slightly smaller base ring
                    height: 280,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isChestNear
                            ? theme
                                  .colorScheme
                                  .secondary // Sunny yellow
                            : theme.colorScheme.tertiary.withValues(
                                alpha: 0.3,
                              ), // Calm teal resting state
                        width: isChestNear ? 12 : 3, // Thicker ring inside
                      ),
                      boxShadow: isChestNear
                          ? [
                              BoxShadow(
                                color: theme.colorScheme.secondary.withValues(
                                  alpha: 0.6,
                                ),
                                blurRadius: 60,
                                spreadRadius: 15,
                              ),
                            ]
                          : [
                              BoxShadow(
                                color: theme.colorScheme.tertiary.withValues(
                                  alpha: 0.1,
                                ),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                            ], // Calm resting glow
                    ),
                  ),
                ),

                SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),

                      // THE MASSIVE COUNTER
                      AnimatedSwitcher(
                        duration: const Duration(
                          milliseconds: 100,
                        ), // Very fast number change
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                              return ScaleTransition(
                                scale: animation,
                                child: child,
                              );
                            },
                        child: Text(
                          '$currentReps',
                          key: ValueKey<int>(currentReps),
                          style: TextStyle(
                            fontSize: 160,
                            fontWeight:
                                FontWeight.w800, // Clean weight, not italic
                            height: 1.0,
                            letterSpacing: -5.0,
                            // Number turns bright sunny yellow when chest is near
                            color: isChestNear
                                ? theme.colorScheme.secondary
                                : Colors.white,
                            shadows: [
                              Shadow(
                                color: isChestNear
                                    ? theme.colorScheme.secondary.withValues(
                                        alpha: 0.5,
                                      )
                                    : Colors.transparent,
                                blurRadius: isChestNear ? 30 : 0,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                      AnimatedOpacity(
                        duration: const Duration(
                          milliseconds: 100,
                        ), // Instant feedback
                        opacity: isChestNear ? 1.0 : 0.0,
                        child: Text(
                          'PUMP IT!',
                          style: TextStyle(
                            color: theme.colorScheme.secondary,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 5.0,
                          ),
                        ),
                      ),

                      const Spacer(),

                      // FINISH BUTTON
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32.0,
                          vertical: 40.0,
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // Tell BLoC to stop sensors, save data, and calculate high scores
                              context.read<WorkoutBloc>().add(FinishWorkout());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white.withValues(
                                alpha: 0.1,
                              ), // Subtle semi-transparent
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 0,
                              shadowColor: Colors.transparent, // No red glow
                            ),
                            child: const Text(
                              'FINISH WORKOUT',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2.0,
                              ),
                            ),
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
