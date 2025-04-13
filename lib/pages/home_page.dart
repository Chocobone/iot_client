import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../util/smart_device_box.dart';
import '../models/device.dart';

class HomePage extends StatefulWidget {
  final List<Device> devices;
  final Function(int, bool) onDevicePowerChanged;
  final Function(Device) onDeviceAdded;

  const HomePage({
    super.key,
    required this.devices,
    required this.onDevicePowerChanged,
    required this.onDeviceAdded,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // padding constants
  final double horizontalPadding = 40;
  final double verticalPadding = 25;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // app bar
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.person,
                    size: 45,
                    color: Theme.of(context).colorScheme.onBackground,
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            // welcome home
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome Home,",
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  Text(
                    'Carle YU',
                    style: GoogleFonts.bebasNeue(
                      fontSize: 72,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Divider(
                thickness: 1,
                color: Theme.of(context).colorScheme.onBackground.withOpacity(0.2),
              ),
            ),

            const SizedBox(height: 25),

            // smart devices grid
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Text(
                "Smart Devices",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // grid
            Expanded(
              child: GridView.builder(
                itemCount: widget.devices.length + 1,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 25),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1 / 1.3,
                ),
                itemBuilder: (context, index) {
                  final device = widget.devices[index];
                  return SmartDeviceBox(
                    smartDeviceName: device.name,
                    iconPath: device.iconPath,
                    powerOn: device.powerOn,
                    onChanged: (value) => widget.onDevicePowerChanged(index, value),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showAddDeviceDialog() {
    String deviceName = '';
    String selectedType = "Smart Light";
    Map<String, String> deviceTypes = {
      "Smart Light": "lib/icons/light-bulb.png",
      "Smart AC": "lib/icons/air-conditioner.png",
      "Smart TV": "lib/icons/light-bulb.png",
      "Robot Vacuum": "lib/icons/robot_vacuum.png",
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
                  color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onBackground.withOpacity(0.2),
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
                    color: Theme.of(context).colorScheme.onBackground.withOpacity(0.2),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
              ),
              items: deviceTypes.keys.map((type) {
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
                widget.onDeviceAdded(
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
