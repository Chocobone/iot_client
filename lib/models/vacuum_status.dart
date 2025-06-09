class VacuumStatus {
  final String entityId;
  final String state;
  final VacuumAttributes attributes;
  final DateTime lastChanged;
  final DateTime lastUpdated;

  VacuumStatus({
    required this.entityId,
    required this.state,
    required this.attributes,
    required this.lastChanged,
    required this.lastUpdated,
  });

  factory VacuumStatus.fromJson(Map<String, dynamic> json) {
    return VacuumStatus(
      entityId: json['entity_id'],
      state: json['state'],
      attributes: VacuumAttributes.fromJson(json['attributes']),
      lastChanged: DateTime.parse(json['last_changed']),
      lastUpdated: DateTime.parse(json['last_updated']),
    );
  }

  bool get isDocked => state == 'docked';
  bool get isCleaning => state == 'cleaning';
  bool get isPaused => state == 'paused';
}

class VacuumAttributes {
  final List<String> fanSpeedList;
  final int batteryLevel;
  final String batteryIcon;
  final String fanSpeed;
  final String status;
  final String friendlyName;
  final int supportedFeatures;

  VacuumAttributes({
    required this.fanSpeedList,
    required this.batteryLevel,
    required this.batteryIcon,
    required this.fanSpeed,
    required this.status,
    required this.friendlyName,
    required this.supportedFeatures,
  });

  factory VacuumAttributes.fromJson(Map<String, dynamic> json) {
    return VacuumAttributes(
      fanSpeedList: List<String>.from(json['fan_speed_list']),
      batteryLevel: json['battery_level'],
      batteryIcon: json['battery_icon'],
      fanSpeed: json['fan_speed'],
      status: json['status'],
      friendlyName: json['friendly_name'],
      supportedFeatures: json['supported_features'],
    );
  }
}
