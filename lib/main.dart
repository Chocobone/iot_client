import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/schedule_page.dart';
import 'pages/settings_page.dart';
import 'pages/devices_list_page.dart';
import 'models/device.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void toggleDarkMode(bool value) {
    setState(() {
      _isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _isDarkMode
          ? ThemeData.dark().copyWith(
              useMaterial3: true,
              colorScheme: ColorScheme.dark(
                primary: Colors.grey[800]!,
                secondary: Colors.grey[700]!,
                background: Colors.grey[900]!,
                surface: const Color.fromARGB(44, 164, 167, 189),
                onBackground: Colors.white,
                onPrimary: Colors.white,
              ),
            )
          : ThemeData.light().copyWith(
              useMaterial3: true,
              colorScheme: ColorScheme.light(
                primary: Colors.grey[900]!,
                secondary: Colors.grey[700]!,
                background: Colors.grey[300]!,
                surface: const Color.fromARGB(44, 164, 167, 189),
                onBackground: Colors.grey[800]!,
                onPrimary: Colors.white,
              ),
            ),
      home: MainPage(
        isDarkMode: _isDarkMode,
        onDarkModeChanged: toggleDarkMode,
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onDarkModeChanged;

  const MainPage({
    super.key,
    required this.isDarkMode,
    required this.onDarkModeChanged,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  // Shared devices list
  List<Device> devices = [
    Device(
      name: "Smart Light",
      iconPath: "lib/icons/light-bulb.png",
      isConnected: false,
      powerOn: false,
    ),
    Device(
      name: "Smart AC",
      iconPath: "lib/icons/air-conditioner.png",
      isConnected: false,
      powerOn: false,
    ),
    Device(
      name: "Smart fan",
      iconPath: "lib/icons/fan.png",
      isConnected: true,
      powerOn: true,
      locations: ["Bedroom", "Livingroom"],
    ),
    Device(
      name: "Robot Vacuum",
      iconPath: "lib/icons/robot-vaccum.png",
      isConnected: false,
      powerOn: false,
    ),
  ];

  // Method to update device power state
  void updateDevicePower(int index, bool powerOn) {
    setState(() {
      devices[index].powerOn = powerOn;
    });
  }

  // Method to add new device
  void addDevice(Device device) {
    setState(() {
      devices.add(device);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.devices),
            label: 'Devices',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  // List of pages with shared device state
  List<Widget> get _pages => [
        HomePage(
          devices: devices,
          onDevicePowerChanged: updateDevicePower,
          onDeviceAdded: addDevice,
        ),
        DevicesListPage(
          devices: devices,
          onDevicePowerChanged: updateDevicePower,
          onDeviceAdded: addDevice,
        ),
        const SchedulePage(),
        SettingsPage(
          isDarkMode: widget.isDarkMode,
          onDarkModeChanged: widget.onDarkModeChanged,
        ),
      ];
}
