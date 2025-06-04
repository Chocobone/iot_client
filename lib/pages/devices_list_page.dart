import 'package:flutter/material.dart';
import '../models/device.dart';
import '../util/smart_device_box.dart';
import 'robot_vacuum_status_page.dart';

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
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        title: Text(
          'Devices',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).colorScheme.onSurface,
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
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_circle_outline,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Add Device',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
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
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Card(
                    color: Theme.of(context).colorScheme.surface,
                    elevation: 2,
                    child: ListTile(
                      leading: Image.asset(
                        device.iconPath,
                        width: 40,
                        height: 40,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      title: Text(
                        device.name,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        device.powerOn ? 'Connected' : 'Disconnected',
                        style: TextStyle(
                          color: device.powerOn
                              ? Colors.green
                              : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                      trailing: Switch(
                        value: device.powerOn,
                        onChanged: (value) => onDevicePowerChanged(index, value),
                        activeColor: Colors.green,
                      ),
                      onTap: () {
                        if (device.name.toLowerCase().contains('vacuum')) {
                          showDialog(
                            context: context,
                            builder: (context) => RobotVacuumStatusPage(device: device),
                          );
                        }
                      },
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
      "Smart TV": "lib/icons/TV.png",
      "Robot Vaccum": "lib/icons/robot-vaccum.png",
    };

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.95),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Text(
          'Add New Device',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                labelText: 'Device Name',
                hintText: 'Enter device name',
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                hintStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              onChanged: (value) => deviceName = value,
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: selectedType,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                labelText: 'Device Type',
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              items: deviceTypes.keys.map((type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(
                    type,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
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
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              if (deviceName.isNotEmpty) {
                onDeviceAdded(
                  Device(
                    name: deviceName,
                    iconPath: deviceTypes[selectedType]!,
                  ),
                );
                Navigator.pop(context);
              }
            },
            child: Text(
              'Add',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 