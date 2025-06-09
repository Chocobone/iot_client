import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../util/smart_device_box.dart';
import '../models/device.dart';
import '../services/vacuum_service.dart';

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
  final VacuumService _vacuumService = VacuumService();
  bool _isServerConnected = false;

  @override
  void initState() {
    super.initState();
    _checkServerConnection();
    _startPeriodicStatusCheck();
  }

  Future<void> _checkServerConnection() async {
    final isConnected = await _vacuumService.checkServerHealth();
    setState(() {
      _isServerConnected = isConnected;
    });
    if (!isConnected) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('서버에 연결할 수 없습니다.')),
        );
      }
    }
  }

  void _startPeriodicStatusCheck() {
    Future.delayed(const Duration(seconds: 5), () async {
      if (!mounted) return;

      // 서버 연결 상태 확인
      await _checkServerConnection();

      // 로봇청소기 상태 업데이트
      if (_isServerConnected) {
        for (int i = 0; i < widget.devices.length; i++) {
          final device = widget.devices[i];
          if (device.isVacuum) {
            final status = await _vacuumService.getVacuumStatus();
            if (status != null) {
              device.updateVacuumStatus(status);
              widget.onDevicePowerChanged(i, device.powerOn);
            }
          }
        }
      }

      // 다음 주기 실행
      _startPeriodicStatusCheck();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
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
                    color: Theme.of(context).colorScheme.onSurface,
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
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    'Carle YU',
                    style: GoogleFonts.bebasNeue(
                      fontSize: 72,
                      color: Theme.of(context).colorScheme.onSurface,
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
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
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
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // grid
            Expanded(
              child: GridView.builder(
                itemCount: widget.devices.length,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 25),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1 / 1.3,
                ),
                itemBuilder: (context, index) {
                  final device = widget.devices[index];
                  return SmartDeviceBox(
                    device: device,
                    onChanged: (value) =>
                        widget.onDevicePowerChanged(index, value),
                    vacuumService: _vacuumService,
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
      "Smart TV": "lib/icons/TV.png",
      "Robot Vaccum": "lib/icons/robot-vaccum.png",
    };

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor:
            Theme.of(context).colorScheme.surface.withOpacity(0.95),
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
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.2),
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
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.2),
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
