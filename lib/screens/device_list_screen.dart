import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import '../ble/ble_manager.dart';
import 'home_screen.dart';

class DeviceListScreen extends StatefulWidget {
  const DeviceListScreen({super.key});

  @override
  State<DeviceListScreen> createState() => _DeviceListScreenState();
}

class _DeviceListScreenState extends State<DeviceListScreen> {
  List<BleDeviceInfo> devices = [];
  bool isScanning = false;
  bool isBluetoothOn = false;
  bool hasPermissions = false;
  String? errorMessage;
  final BleManager bleManager = BleManager();

  @override
  void initState() {
    super.initState();
    _checkBluetoothState();
    _requestPermissions();
  }

  Future<void> _checkBluetoothState() async {
    try {
      // Check if Bluetooth is available
      if (await FlutterBluePlus.isSupported == false) {
        setState(() {
          errorMessage = "Bluetooth is not supported on this device";
        });
        return;
      }

      // Check if Bluetooth is on
      FlutterBluePlus.adapterState.listen((state) {
        setState(() {
          isBluetoothOn = state == BluetoothAdapterState.on;
          if (!isBluetoothOn) {
            errorMessage = "Please turn on Bluetooth";
          } else {
            errorMessage = null;
          }
        });
      });

      // Get initial state
      final state = await FlutterBluePlus.adapterState.first;
      setState(() {
        isBluetoothOn = state == BluetoothAdapterState.on;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Error checking Bluetooth state: $e";
      });
    }
  }

  Future<void> _requestPermissions() async {
    try {
      // Request location permission (required for BLE scanning on Android)
      final locationStatus = await Permission.location.request();

      // Request Bluetooth permissions
      final bluetoothScanStatus = await Permission.bluetoothScan.request();
      final bluetoothConnectStatus =
          await Permission.bluetoothConnect.request();

      setState(() {
        hasPermissions = locationStatus.isGranted &&
            bluetoothScanStatus.isGranted &&
            bluetoothConnectStatus.isGranted;

        if (!hasPermissions) {
          errorMessage =
              "Location and Bluetooth permissions are required for BLE scanning";
        }
      });
    } catch (e) {
      setState(() {
        errorMessage = "Error requesting permissions: $e";
      });
    }
  }

  Future<void> startScan() async {
    if (!isBluetoothOn) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please turn on Bluetooth first")),
      );
      return;
    }

    if (!hasPermissions) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please grant required permissions first")),
      );
      await _requestPermissions();
      return;
    }

    setState(() {
      devices = [];
      isScanning = true;
      errorMessage = null;
    });

    try {
      // Use the comprehensive scan method for maximum device detection
      bleManager
          .scanDevicesComprehensive(timeout: const Duration(seconds: 20))
          .listen((deviceInfo) {
        setState(() {
          // Check if device already exists to avoid duplicates
          final existingIndex =
              devices.indexWhere((d) => d.id == deviceInfo.id);
          if (existingIndex >= 0) {
            // Update existing device with latest RSSI
            devices[existingIndex] = deviceInfo;
          } else {
            // Add new device
            devices.add(deviceInfo);
          }
        });
      }, onError: (error) {
        if (mounted) {
          setState(() {
            errorMessage = "Scan error: $error";
            isScanning = false;
          });
        }
      });

      // Handle scan completion
      bleManager.isScanning.listen((scanning) {
        if (!scanning && mounted) {
          setState(() {
            isScanning = false;
          });

          if (devices.isEmpty) {
            setState(() {
              errorMessage = "No devices found. Please ensure:\n"
                  "• Bluetooth is enabled on nearby devices\n"
                  "• Devices are in discoverable mode\n"
                  "• You're testing on a physical device (not emulator)\n"
                  "• Location services are enabled";
            });
          } else {
            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Found ${devices.length} device(s)"),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        }
      });
    } catch (e) {
      setState(() {
        errorMessage = "Failed to start scan: $e";
        isScanning = false;
      });
    }
  }

  Future<void> stopScan() async {
    setState(() {
      isScanning = false;
    });

    try {
      await bleManager.stopScan();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Scan stopped")),
      );
    } catch (e) {
      setState(() {
        errorMessage = "Failed to stop scan: $e";
      });
    }
  }

  Future<void> _runDiagnostics() async {
    try {
      final diagnostics = await bleManager.testBleScanning();

      String message = "BLE Diagnostics:\n";
      message += "• BLE Supported: ${diagnostics['bleSupported']}\n";
      message += "• Bluetooth ON: ${diagnostics['bluetoothOn']}\n";
      message += "• Adapter State: ${diagnostics['adapterState']}\n";

      if (diagnostics['scanStartSuccess'] != null) {
        message += "• Scan Start Success: ${diagnostics['scanStartSuccess']}\n";
        if (diagnostics['devicesFound'] != null) {
          message += "• Devices Found: ${diagnostics['devicesFound']}\n";
          if (diagnostics['deviceIds'] != null) {
            message += "• Device IDs: ${diagnostics['deviceIds'].join(', ')}\n";
          }
        }
        if (diagnostics['scanError'] != null) {
          message += "• Scan Error: ${diagnostics['scanError']}\n";
        }
      }

      if (diagnostics['error'] != null) {
        message += "• Error: ${diagnostics['error']}\n";
      }

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('BLE Diagnostics'),
            content: SingleChildScrollView(
              child: Text(message),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Diagnostic error: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    bleManager.stopScan();
    super.dispose();
  }

  String _getDeviceDisplayName(BleDeviceInfo device) {
    if (device.name != null && device.name!.isNotEmpty) {
      return device.name!;
    }

    // If no name, show device type and manufacturer if available
    if (device.manufacturerName != null) {
      return "${device.deviceType} (${device.manufacturerName})";
    }

    return device.deviceType;
  }

  Color _getDeviceTypeColor(String deviceType) {
    switch (deviceType.toLowerCase()) {
      case 'apple device':
        return Colors.blue;
      case 'samsung device':
        return Colors.green;
      case 'smartphone':
        return Colors.purple;
      case 'audio device':
        return Colors.orange;
      case 'fitness tracker':
      case 'smart watch':
        return Colors.teal;
      case 'heart rate monitor':
        return Colors.red;
      case 'medical device':
        return Colors.pink;
      case 'iot device':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text("Nearby BLE Devices"),
            if (isScanning) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      "SCANNING",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        backgroundColor: isScanning ? Colors.blue.shade50 : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.bug_report),
            onPressed: _runDiagnostics,
            tooltip: 'Run BLE Diagnostics',
          ),
        ],
      ),
      body: Column(
        children: [
          // Status indicators
          if (errorMessage != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.red.shade100,
              child: Text(
                errorMessage!,
                style: TextStyle(color: Colors.red.shade800),
                textAlign: TextAlign.center,
              ),
            ),

          // Bluetooth status
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            color:
                isBluetoothOn ? Colors.green.shade100 : Colors.orange.shade100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isBluetoothOn ? Icons.bluetooth : Icons.bluetooth_disabled,
                  color: isBluetoothOn ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 8),
                Text(
                  isBluetoothOn ? "Bluetooth: ON" : "Bluetooth: OFF",
                  style: TextStyle(
                    color: isBluetoothOn
                        ? Colors.green.shade800
                        : Colors.orange.shade800,
                  ),
                ),
              ],
            ),
          ),

          // Device list
          Expanded(
            child: isScanning
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text("Scanning for devices..."),
                      ],
                    ),
                  )
                : devices.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isScanning
                                  ? Icons.bluetooth_searching
                                  : Icons.bluetooth_disabled,
                              size: 64,
                              color: isScanning ? Colors.blue : Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              isScanning ? "Scanning..." : "No devices found",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isScanning ? Colors.blue : Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              isScanning
                                  ? "Searching for nearby BLE devices..."
                                  : "Tap the play button to start scanning",
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade100,
                                borderRadius: BorderRadius.circular(8),
                                border:
                                    Border.all(color: Colors.orange.shade300),
                              ),
                              child: const Column(
                                children: [
                                  Text(
                                    "⚠️ Emulator Notice",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Android emulators have limited BLE support.\n"
                                    "For best results, test on a physical device.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: devices.length,
                        itemBuilder: (_, i) {
                          final device = devices[i];
                          final displayName = _getDeviceDisplayName(device);
                          final deviceTypeColor =
                              _getDeviceTypeColor(device.deviceType);

                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: deviceTypeColor,
                                child: Icon(
                                  Icons.bluetooth,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              title: Text(
                                displayName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("ID: ${device.id}"),
                                  Text("RSSI: ${device.rssi} dBm"),
                                  if (device.manufacturerName != null)
                                    Text(
                                        "Manufacturer: ${device.manufacturerName}"),
                                  if (device.serviceUuids.isNotEmpty)
                                    Text(
                                        "Services: ${device.serviceUuids.length} found"),
                                ],
                              ),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: deviceTypeColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: deviceTypeColor),
                                ),
                                child: Text(
                                  device.deviceType,
                                  style: TextStyle(
                                    color: deviceTypeColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        HomeScreen(targetDeviceId: device.id),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: isScanning ? stopScan : startScan,
        backgroundColor: isScanning ? Colors.red : Colors.blue,
        child: Icon(
          isScanning ? Icons.stop : Icons.play_arrow,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
