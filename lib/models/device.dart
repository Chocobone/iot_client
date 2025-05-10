import 'package:flutter/material.dart';

class Device {
  final String name;
  final String iconPath;
  bool isConnected;
  bool powerOn;
  final List<String> locations;

  Device({
    required this.name,
    required this.iconPath,
    this.isConnected = false,
    this.powerOn = false,
    this.locations = const [],
  });

  Device copyWith({
    String? name,
    String? iconPath,
    bool? isConnected,
    bool? powerOn,
    List<String>? locations,
  }) {
    return Device(
      name: name ?? this.name,
      iconPath: iconPath ?? this.iconPath,
      isConnected: isConnected ?? this.isConnected,
      powerOn: powerOn ?? this.powerOn,
      locations: locations ?? this.locations,
    );
  }
} 