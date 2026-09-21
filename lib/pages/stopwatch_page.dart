import 'dart:async';

import 'package:flutter/material.dart';

class StopwatchPage extends StatefulWidget {
  const StopwatchPage({super.key});

  @override
  State<StopwatchPage> createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  final Stopwatch _stopwatch = Stopwatch();

  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startStopwatch() {
    _stopwatch.start();

    _timer ??= Timer.periodic(
      const Duration(milliseconds: 30),
      (_) {
        if (mounted) {
          setState(() {});
        }
      },
    );

    setState(() {});
  }

  void _pauseStopwatch() {
    _stopwatch.stop();

    _timer?.cancel();
    _timer = null;

    setState(() {});
  }

  void _resetStopwatch() {
    _stopwatch.reset();

    setState(() {});
  }

  String _formatTime() {
    final duration = _stopwatch.elapsed;

    final hours =
        duration.inHours.toString().padLeft(2, '0');

    final minutes =
        (duration.inMinutes % 60)
            .toString()
            .padLeft(2, '0');

    final seconds =
        (duration.inSeconds % 60)
            .toString()
            .padLeft(2, '0');

    final milliseconds =
        (duration.inMilliseconds % 1000)
            .toString()
            .padLeft(3, '0');

    return '$hours:$minutes:$seconds.$milliseconds';
  }

  @override
  Widget build(BuildContext context) {
    final isRunning = _stopwatch.isRunning;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stopwatch'),
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),

          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [
              const Icon(
                Icons.timer,
                size: 80,
              ),

              const SizedBox(height: 30),

              Text(
                _formatTime(),
                style: const TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  fontFeatures: [
                    FontFeature.tabularFigures(),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,

                children: [
                  FilledButton.icon(
                    onPressed: isRunning
                        ? _pauseStopwatch
                        : _startStopwatch,
                    icon: Icon(
                      isRunning
                          ? Icons.pause
                          : Icons.play_arrow,
                    ),
                    label: Text(
                      isRunning
                          ? 'Pause'
                          : 'Start',
                    ),
                  ),

                  const SizedBox(width: 12),

                  OutlinedButton.icon(
                    onPressed: _resetStopwatch,
                    icon: const Icon(
                      Icons.restart_alt,
                    ),
                    label: const Text('Reset'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}