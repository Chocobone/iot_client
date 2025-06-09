import 'package:flutter/material.dart';
import '../models/device.dart';
import '../util/smart_device_box.dart';
import '../services/vacuum_service.dart';
import 'robot_vacuum_status_page.dart';

class DevicesListPage extends StatefulWidget {
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
  State<DevicesListPage> createState() => _DevicesListPageState();
}

class _DevicesListPageState extends State<DevicesListPage> {
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
              itemCount: widget.devices.length + 1,
              itemBuilder: (context, index) {
                if (index == widget.devices.length) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: OutlinedButton(
                      onPressed: () => _showAddDeviceDialog(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.2),
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

                final device = widget.devices[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
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
                      subtitle: device.isVacuum && device.vacuumStatus != null
                          ? Text(
                              device.vacuumStatus!.attributes.status,
                              style: TextStyle(
                                color: device.getStatusColor(),
                              ),
                            )
                          : Text(
                              device.powerOn ? 'Connected' : 'Disconnected',
                              style: TextStyle(
                                color: device.powerOn
                                    ? Colors.green
                                    : Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(0.5),
                              ),
                            ),
                      trailing: GestureDetector(
                        onTap: () {
                          if (device.isVacuum) {
                            _handleVacuumAction(context, device, index);
                          } else {
                            widget.onDevicePowerChanged(index, !device.powerOn);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: device.isVacuum
                                ? device.getStatusColor()
                                : (device.powerOn
                                    ? Colors.green
                                    : Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(0.2)),
                          ),
                          child: Icon(
                            device.isVacuum
                                ? (device.isCleaning
                                    ? Icons.pause
                                    : Icons.play_arrow)
                                : (device.powerOn
                                    ? Icons.power_settings_new
                                    : Icons.power_off),
                            color: device.powerOn
                                ? Colors.white
                                : Theme.of(context).colorScheme.onSurface,
                            size: 24,
                          ),
                        ),
                      ),
                      onTap: () {
                        if (device.isVacuum) {
                          showDialog(
                            context: context,
                            builder: (context) => RobotVacuumStatusPage(
                              device: device,
                              vacuumService: _vacuumService,
                            ),
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

  Future<void> _handleVacuumAction(
      BuildContext context, Device device, int index) async {
    // 현재 상태 확인
    final currentStatus = await _vacuumService.getVacuumStatus();
    if (currentStatus == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('로봇청소기 상태를 확인할 수 없습니다.')),
        );
      }
      return;
    }

    bool success = false;
    if (currentStatus.isDocked) {
      // 도킹 상태일 때 청소 시작
      success = await _vacuumService.startVacuum();
    } else if (currentStatus.isCleaning) {
      // 청소 중일 때 일시정지 후 귀환
      success = await _vacuumService.pauseVacuum();
      if (success) {
        await Future.delayed(const Duration(seconds: 1));
        success = await _vacuumService.returnToDock();
      }
    }

    if (success) {
      // 상태 업데이트
      final newStatus = await _vacuumService.getVacuumStatus();
      if (newStatus != null) {
        device.updateVacuumStatus(newStatus);
        widget.onDevicePowerChanged(index, device.powerOn);
      }
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('명령 실행에 실패했습니다.')),
      );
    }
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
