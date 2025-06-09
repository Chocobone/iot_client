import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/device.dart';
import '../services/vacuum_service.dart';
import '../pages/robot_vacuum_status_page.dart';

class SmartDeviceBox extends StatelessWidget {
  final Device device;
  final Function(bool)? onChanged;
  final VacuumService vacuumService;

  SmartDeviceBox({
    super.key,
    required this.device,
    required this.onChanged,
    required this.vacuumService,
  });

  Future<void> _handleVacuumAction(BuildContext context) async {
    if (!device.isVacuum) {
      onChanged?.call(!device.powerOn);
      return;
    }

    // 현재 상태 확인
    final currentStatus = await vacuumService.getVacuumStatus();
    if (currentStatus == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로봇청소기 상태를 확인할 수 없습니다.')),
      );
      return;
    }

    bool success = false;
    if (currentStatus.isDocked) {
      // 도킹 상태일 때 청소 시작
      success = await vacuumService.startVacuum();
    } else if (currentStatus.isCleaning) {
      // 청소 중일 때 일시정지 후 귀환
      success = await vacuumService.pauseVacuum();
      if (success) {
        await Future.delayed(const Duration(seconds: 1));
        success = await vacuumService.returnToDock();
      }
    }

    if (success) {
      // 상태 업데이트
      final newStatus = await vacuumService.getVacuumStatus();
      if (newStatus != null) {
        device.updateVacuumStatus(newStatus);
        onChanged?.call(device.powerOn);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('명령 실행에 실패했습니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: device.isVacuum
          ? () {
              showDialog(
                context: context,
                builder: (context) => RobotVacuumStatusPage(
                  device: device,
                  vacuumService: vacuumService,
                ),
              );
            }
          : null,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: device.powerOn
                ? isDarkMode
                    ? Colors.grey[800]
                    : const Color.fromARGB(44, 164, 167, 189)
                : Colors.grey[900],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // icon
                Image.asset(
                  device.iconPath,
                  height: 65,
                  color: device.powerOn
                      ? isDarkMode
                          ? Colors.white
                          : Colors.grey[800]
                      : Colors.white,
                ),

                // device name + button
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              device.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: device.powerOn
                                    ? isDarkMode
                                        ? Colors.white
                                        : Colors.grey[800]
                                    : Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (device.isVacuum && device.vacuumStatus != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  device.vacuumStatus!.attributes.status,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: device.powerOn
                                        ? isDarkMode
                                            ? Colors.white70
                                            : Colors.grey[600]
                                        : Colors.white70,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _handleVacuumAction(context),
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: device.isVacuum
                              ? device.getStatusColor()
                              : (device.powerOn
                                  ? isDarkMode
                                      ? Colors.blue
                                      : Colors.blue[300]
                                  : Colors.grey[700]),
                        ),
                        child: Icon(
                          device.isVacuum
                              ? (device.isCleaning
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded)
                              : (device.powerOn
                                  ? Icons.power_settings_new_rounded
                                  : Icons.power_off_rounded),
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
