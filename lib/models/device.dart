import 'package:flutter/material.dart';
import 'vacuum_status.dart';

class Device {
  final String name;
  final String iconPath;
  bool isConnected;
  bool powerOn;
  final List<String> locations;
  VacuumStatus? vacuumStatus;

  Device({
    required this.name,
    required this.iconPath,
    this.isConnected = false,
    this.powerOn = false,
    this.locations = const [],
    this.vacuumStatus,
  });

  Device copyWith({
    String? name,
    String? iconPath,
    bool? isConnected,
    bool? powerOn,
    List<String>? locations,
    VacuumStatus? vacuumStatus,
  }) {
    return Device(
      name: name ?? this.name,
      iconPath: iconPath ?? this.iconPath,
      isConnected: isConnected ?? this.isConnected,
      powerOn: powerOn ?? this.powerOn,
      locations: locations ?? this.locations,
      vacuumStatus: vacuumStatus ?? this.vacuumStatus,
    );
  }

  bool get isVacuum => name.toLowerCase().contains('vacuum');
  bool get isDocked => vacuumStatus?.isDocked ?? false;
  bool get isCleaning => vacuumStatus?.isCleaning ?? false;
  bool get isPaused => vacuumStatus?.isPaused ?? false;

  void updateVacuumStatus(VacuumStatus status) {
    vacuumStatus = status;
    powerOn = status.isCleaning || status.isPaused;
  }

  Color getStatusColor() {
    if (!isVacuum || vacuumStatus == null) {
      return powerOn ? Colors.green : Colors.grey;
    }

    if (vacuumStatus!.isDocked ||
        vacuumStatus!.attributes.status == 'Charging') {
      return Colors.blue;
    } else if (vacuumStatus!.attributes.status == 'Returning home') {
      return Colors.blue;
    } else if (vacuumStatus!.isCleaning) {
      return Colors.green;
    } else {
      return Colors.orange;
    }
  }
}
