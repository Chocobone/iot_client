import 'package:flutter/material.dart';
import '../models/device.dart';
import '../util/smart_device_box.dart';

class DevicesListPage extends StatelessWidget {
  final List<Device> devices;
  final Function(int, bool) onDevicePowerChanged;
  final Function(Device) onDeviceAdded;

  const DevicesListPage({
    super.key,
    required this.devices,
    required this.onDevicePowerChanged,
    required this.onDeviceAdded,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        title: Text(
          'Devices',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            onSelected: (value) {
              // Handle menu item selection
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'sort',
                  child: Text('Sort by'),
                ),
                const PopupMenuItem<String>(
                  value: 'filter',
                  child: Text('Filter'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: devices.length + 1,
              itemBuilder: (context, index) {
                if (index == devices.length) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: OutlinedButton(
                      onPressed: () => _showAddDeviceDialog(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: Theme.of(
                            context,
                          ).colorScheme.onBackground.withOpacity(0.2),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_circle_outline,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Add Device',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final device = devices[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Card(
                    color: Theme.of(context).colorScheme.surface,
                    elevation: 2,
                    child: ListTile(
                      leading: Image.asset(
                        device.iconPath,
                        width: 40,
                        height: 40,
                        color: Theme.of(context).colorScheme.onBackground,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.error_outline,
                            size: 40,
                            color: Theme.of(context).colorScheme.onBackground,
                          );
                        },
                        fit: BoxFit.contain,
                      ),
                      title: Text(
                        device.name,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        device.powerOn ? 'Connected' : 'Disconnected',
                        style: TextStyle(
                          color:
                              device.powerOn
                                  ? Colors.green
                                  : Theme.of(
                                    context,
                                  ).colorScheme.onBackground.withOpacity(0.5),
                        ),
                      ),
                      trailing: Switch(
                        value: device.powerOn,
                        onChanged:
                            (value) => onDevicePowerChanged(index, value),
                        activeColor: Colors.green,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddDeviceDialog(BuildContext context) {
    String deviceName = '';
    String selectedType = "Smart Light";
    Map<String, String> deviceTypes = {
      "Smart Light": "lib/icons/light-bulb.png",
      "Smart AC": "lib/icons/air-conditioner.png",
      "Smart TV": "lib/icons/light-bulb.png",
      "Robot Vacuum": "lib/icons/robot-vacuum.png",
    };

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Theme.of(
              context,
            ).colorScheme.surface.withOpacity(0.95),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Text(
              'Add New Device',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Device Name',
                    hintText: 'Enter device name',
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    hintStyle: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onBackground.withOpacity(0.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Theme.of(
                          context,
                        ).colorScheme.onBackground.withOpacity(0.2),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  ),
                  onChanged: (value) => deviceName = value,
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: selectedType,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Device Type',
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Theme.of(
                          context,
                        ).colorScheme.onBackground.withOpacity(0.2),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  ),
                  items:
                      deviceTypes.keys.map((type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(
                            type,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                        );
                      }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      selectedType = value;
                    }
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (deviceName.isNotEmpty) {
                    Device newDevice;
                    switch (selectedType) {
                      case "Smart Light":
                        newDevice = SmartLight(
                          name: deviceName,
                          iconPath: deviceTypes[selectedType]!,
                        );
                        break;
                      case "Smart AC":
                        newDevice = SmartAC(
                          name: deviceName,
                          iconPath: deviceTypes[selectedType]!,
                        );
                        break;
                      case "Smart TV":
                        newDevice = SmartTV(
                          name: deviceName,
                          iconPath: deviceTypes[selectedType]!,
                        );
                        break;
                      case "Robot Vacuum":
                        newDevice = RobotVacuum(
                          name: deviceName,
                          iconPath: deviceTypes[selectedType]!,
                        );
                        break;
                      default:
                        newDevice = SmartLight(
                          name: deviceName,
                          iconPath: deviceTypes[selectedType]!,
                        );
                    }
                    onDeviceAdded(newDevice);
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  'Add',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
    );
  }
}
