import 'package:flutter/material.dart';

enum DeviceType { smartLight, smartAC, smartTV, robotVacuum }

abstract class Device {
  final String name;
  final String iconPath;
  final DeviceType type;
  bool isConnected;
  bool powerOn;
  final List<String> locations;

  Device({
    required this.name,
    required this.iconPath,
    required this.type,
    this.isConnected = false,
    this.powerOn = false,
    this.locations = const [],
  });

  Device copyWith({
    String? name,
    String? iconPath,
    DeviceType? type,
    bool? isConnected,
    bool? powerOn,
    List<String>? locations,
  });
}

class SmartLight extends Device {
  SmartLight({
    required String name,
    required String iconPath,
    bool isConnected = false,
    bool powerOn = false,
    List<String> locations = const [],
  }) : super(
         name: name,
         iconPath: iconPath,
         type: DeviceType.smartLight,
         isConnected: isConnected,
         powerOn: powerOn,
         locations: locations,
       );

  @override
  Device copyWith({
    String? name,
    String? iconPath,
    DeviceType? type,
    bool? isConnected,
    bool? powerOn,
    List<String>? locations,
  }) {
    return SmartLight(
      name: name ?? this.name,
      iconPath: iconPath ?? this.iconPath,
      isConnected: isConnected ?? this.isConnected,
      powerOn: powerOn ?? this.powerOn,
      locations: locations ?? this.locations,
    );
  }
}

class SmartAC extends Device {
  SmartAC({
    required String name,
    required String iconPath,
    bool isConnected = false,
    bool powerOn = false,
    List<String> locations = const [],
  }) : super(
         name: name,
         iconPath: iconPath,
         type: DeviceType.smartAC,
         isConnected: isConnected,
         powerOn: powerOn,
         locations: locations,
       );

  @override
  Device copyWith({
    String? name,
    String? iconPath,
    DeviceType? type,
    bool? isConnected,
    bool? powerOn,
    List<String>? locations,
  }) {
    return SmartAC(
      name: name ?? this.name,
      iconPath: iconPath ?? this.iconPath,
      isConnected: isConnected ?? this.isConnected,
      powerOn: powerOn ?? this.powerOn,
      locations: locations ?? this.locations,
    );
  }
}

class SmartTV extends Device {
  SmartTV({
    required String name,
    required String iconPath,
    bool isConnected = false,
    bool powerOn = false,
    List<String> locations = const [],
  }) : super(
         name: name,
         iconPath: iconPath,
         type: DeviceType.smartTV,
         isConnected: isConnected,
         powerOn: powerOn,
         locations: locations,
       );

  @override
  Device copyWith({
    String? name,
    String? iconPath,
    DeviceType? type,
    bool? isConnected,
    bool? powerOn,
    List<String>? locations,
  }) {
    return SmartTV(
      name: name ?? this.name,
      iconPath: iconPath ?? this.iconPath,
      isConnected: isConnected ?? this.isConnected,
      powerOn: powerOn ?? this.powerOn,
      locations: locations ?? this.locations,
    );
  }
}

class RobotVacuum extends Device {
  RobotVacuum({
    required String name,
    required String iconPath,
    bool isConnected = false,
    bool powerOn = false,
    List<String> locations = const [],
  }) : super(
         name: name,
         iconPath: iconPath,
         type: DeviceType.robotVacuum,
         isConnected: isConnected,
         powerOn: powerOn,
         locations: locations,
       );

  @override
  Device copyWith({
    String? name,
    String? iconPath,
    DeviceType? type,
    bool? isConnected,
    bool? powerOn,
    List<String>? locations,
  }) {
    return RobotVacuum(
      name: name ?? this.name,
      iconPath: iconPath ?? this.iconPath,
      isConnected: isConnected ?? this.isConnected,
      powerOn: powerOn ?? this.powerOn,
      locations: locations ?? this.locations,
    );
  }

  // API Methods
  Future<void> start() async {
    // TODO: Implement API call to start vacuum
    // Example: await apiClient.post('/vacuum/start', {'deviceId': name});
    powerOn = true;
  }

  Future<void> stop() async {
    // TODO: Implement API call to stop vacuum
    // Example: await apiClient.post('/vacuum/stop', {'deviceId': name});
    powerOn = false;
  }

  Future<Map<String, dynamic>> status() async {
    // TODO: Implement API call to get vacuum status
    // Example: final response = await apiClient.get('/vacuum/status', {'deviceId': name});
    // return {
    //   'cleaningArea': response.data['area'],
    //   'batteryLevel': response.data['battery'],
    //   'cleaningTime': response.data['time'],
    // };
    return {'cleaningArea': 0, 'batteryLevel': 0, 'cleaningTime': 0};
  }

  Future<void> dock() async {
    // TODO: Implement API call to return vacuum to dock
    // Example: await apiClient.post('/vacuum/dock', {'deviceId': name});
    powerOn = false;
  }
}
