import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gymfit/config/theme_config.dart';

class WorkoutTimerScreen extends StatefulWidget {
  final String workoutName;
  const WorkoutTimerScreen({super.key, required this.workoutName});

  @override
  State<WorkoutTimerScreen> createState() => _WorkoutTimerScreenState();
}

class _WorkoutTimerScreenState extends State<WorkoutTimerScreen> {
  Timer? _timer;
  int _seconds = 0;
  bool _isRunning = false;
  bool _isResting = false;
  int _restSeconds = 0;
  int _currentSet = 1;
  int _totalSets = 3;
  int _repsCompleted = 0;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _toggleTimer() {
    if (_isRunning) {
      _timer?.cancel();
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_isResting) {
            if (_restSeconds > 0) {
              _restSeconds--;
            } else {
              _isResting = false;
            }
          } else {
            _seconds++;
          }
        });
      });
    }
    setState(() {
      _isRunning = !_isRunning;
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _seconds = 0;
      _isRunning = false;
      _isResting = false;
      _restSeconds = 0;
    });
  }

  void _startRest(int seconds) {
    setState(() {
      _isResting = true;
      _restSeconds = seconds;
    });
    if (!_isRunning) {
      _toggleTimer();
    }
  }

  void _completeSet() {
    if (_currentSet < _totalSets) {
      setState(() {
        _currentSet++;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Set $_currentSet/$_totalSets completed!'),
          backgroundColor: ThemeConfig.successColor,
          duration: const Duration(seconds: 2),
        ),
      );
      _startRest(60); // Auto-start 60s rest
    } else {
      _showWorkoutComplete();
    }
  }

  void _showWorkoutComplete() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🎉 Workout Complete!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Great job completing ${widget.workoutName}!'),
            const SizedBox(height: 16),
            Text('Duration: ${_formatTime(_seconds)}'),
            Text('Sets Completed: $_totalSets'),
            Text('Total Reps: $_repsCompleted'),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Finish'),
          ),
        ],
      ),
    );
  }

  String _formatTime(int totalSeconds) {
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workoutName),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('End Workout?'),
                  content: const Text('Are you sure you want to end this workout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ThemeConfig.errorColor,
                      ),
                      child: const Text('End'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Timer Display
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _isResting
                    ? [Colors.orange, Colors.deepOrange]
                    : [ThemeConfig.primaryColor, ThemeConfig.secondaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                Text(
                  _isResting ? 'REST TIME' : 'WORKOUT TIME',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _formatTime(_isResting ? _restSeconds : _seconds),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _toggleTimer,
                      icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                      label: Text(_isRunning ? 'Pause' : 'Start'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: ThemeConfig.primaryColor,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      ),
                    ),
                    const SizedBox(width: 16),
                    OutlinedButton.icon(
                      onPressed: _resetTimer,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reset'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white),
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Sets Progress
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Current Set',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                '$_currentSet / $_totalSets',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: ThemeConfig.primaryColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          LinearProgressIndicator(
                            value: _currentSet / _totalSets,
                            backgroundColor: Colors.grey[200],
                            valueColor: const AlwaysStoppedAnimation<Color>(ThemeConfig.primaryColor),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Rep Counter
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            'Reps This Set',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _repsCompleted.toString(),
                            style: const TextStyle(
                              fontSize: 64,
                              fontWeight: FontWeight.bold,
                              color: ThemeConfig.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton.filled(
                                onPressed: () {
                                  if (_repsCompleted > 0) {
                                    setState(() {
                                      _repsCompleted--;
                                    });
                                  }
                                },
                                icon: const Icon(Icons.remove),
                                iconSize: 32,
                                style: IconButton.styleFrom(
                                  backgroundColor: ThemeConfig.errorColor,
                                ),
                              ),
                              const SizedBox(width: 32),
                              IconButton.filled(
                                onPressed: () {
                                  setState(() {
                                    _repsCompleted++;
                                  });
                                },
                                icon: const Icon(Icons.add),
                                iconSize: 32,
                                style: IconButton.styleFrom(
                                  backgroundColor: ThemeConfig.successColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Rest Timers
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Quick Rest',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildRestButton('30s', 30),
                              _buildRestButton('60s', 60),
                              _buildRestButton('90s', 90),
                              _buildRestButton('2m', 120),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Complete Set Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _completeSet,
                      icon: const Icon(Icons.check_circle),
                      label: Text(
                        _currentSet < _totalSets ? 'Complete Set' : 'Finish Workout',
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: ThemeConfig.successColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRestButton(String label, int seconds) {
    return ElevatedButton(
      onPressed: () => _startRest(seconds),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: Text(label),
    );
  }
}
