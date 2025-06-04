import 'package:flutter/material.dart';
import '../models/device.dart';

enum VacuumState { start, pause, returnToDock }

class RobotVacuumStatusPage extends StatefulWidget {
  final Device device;

  const RobotVacuumStatusPage({
    super.key,
    required this.device,
  });

  @override
  State<RobotVacuumStatusPage> createState() => _RobotVacuumStatusPageState();
}

class _RobotVacuumStatusPageState extends State<RobotVacuumStatusPage> {
  VacuumState _currentState = VacuumState.pause;
  double _batteryLevel = 75.0; // Example battery level
  String _cleaningArea = "Living Room"; // Example cleaning area
  Duration _cleaningTime = const Duration(minutes: 45); // Example cleaning time

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.device.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Status Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          _currentState == VacuumState.start
                              ? Icons.play_circle
                              : _currentState == VacuumState.pause
                                  ? Icons.pause_circle
                                  : Icons.home,
                          color: _currentState == VacuumState.start
                              ? Colors.green
                              : _currentState == VacuumState.pause
                                  ? Colors.orange
                                  : Colors.blue,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _currentState == VacuumState.start
                              ? 'Cleaning'
                              : _currentState == VacuumState.pause
                                  ? 'Paused'
                                  : 'Returning to Dock',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Battery Level
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Battery Level',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: _batteryLevel / 100,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _batteryLevel > 20 ? Colors.green : Colors.red,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('${_batteryLevel.toStringAsFixed(1)}%'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Cleaning Area
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Area',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _cleaningArea,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Cleaning Time
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cleaning Time',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_cleaningTime.inHours}h ${_cleaningTime.inMinutes % 60}m',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Control Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _currentState = VacuumState.start;
                    });
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Start'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _currentState = VacuumState.pause;
                    });
                  },
                  icon: const Icon(Icons.pause),
                  label: const Text('Pause'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _currentState = VacuumState.returnToDock;
                    });
                  },
                  icon: const Icon(Icons.home),
                  label: const Text('Return'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 