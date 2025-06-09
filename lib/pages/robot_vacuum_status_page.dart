import 'package:flutter/material.dart';
import '../models/device.dart';
import '../services/vacuum_service.dart';
import 'dart:async';

class RobotVacuumStatusPage extends StatefulWidget {
  final Device device;
  final VacuumService vacuumService;

  const RobotVacuumStatusPage({
    super.key,
    required this.device,
    required this.vacuumService,
  });

  @override
  State<RobotVacuumStatusPage> createState() => _RobotVacuumStatusPageState();
}

class _RobotVacuumStatusPageState extends State<RobotVacuumStatusPage> {
  bool _isLoading = false;
  Timer? _statusTimer;

  @override
  void initState() {
    super.initState();
    // 1초마다 상태 업데이트
    _statusTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateStatus();
    });
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    super.dispose();
  }

  Future<void> _updateStatus() async {
    final newStatus = await widget.vacuumService.getVacuumStatus();
    if (newStatus != null && mounted) {
      widget.device.updateVacuumStatus(newStatus);
      setState(() {});
    }
  }

  Future<void> _handleAction(Future<bool> Function() action) async {
    setState(() => _isLoading = true);
    try {
      final success = await action();
      if (success) {
        await Future.delayed(const Duration(milliseconds: 500));
        await _updateStatus();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('명령 실행에 실패했습니다.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = widget.device.vacuumStatus;
    if (status == null) {
      return AlertDialog(
        title: const Text('Error'),
        content: const Text('로봇청소기 상태를 가져올 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      );
    }

    return AlertDialog(
      title: Text(widget.device.name),
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[900]
          : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 8,
      content: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[850]
              : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[800]
                  : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: widget.device.getStatusColor(),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: widget.device
                                    .getStatusColor()
                                    .withOpacity(0.5),
                                blurRadius: 4,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '상태: ${status.attributes.status}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '배터리: ${status.attributes.batteryLevel}%',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white70
                            : Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '팬 속도: ${status.attributes.fanSpeed}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white70
                            : Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading
                        ? null
                        : () => _handleAction(
                              () => widget.vacuumService.startVacuum(),
                            ),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('START'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading
                        ? null
                        : () => _handleAction(
                              () => widget.vacuumService.pauseVacuum(),
                            ),
                    icon: const Icon(Icons.stop),
                    label: const Text('STOP'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading
                        ? null
                        : () => _handleAction(
                              () async {
                                final success =
                                    await widget.vacuumService.pauseVacuum();
                                if (success) {
                                  await Future.delayed(
                                      const Duration(seconds: 1));
                                  return await widget.vacuumService
                                      .returnToDock();
                                }
                                return false;
                              },
                            ),
                    icon: const Icon(Icons.home),
                    label: const Text('RETURN'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (_isLoading)
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.blue,
                  ),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          child: const Text(
            '닫기',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
