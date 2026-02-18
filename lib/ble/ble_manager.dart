// lib/ble/ble_manager.dart

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleDeviceInfo {
  final String id; // MAC address
  final String? name;
  final int rssi;
  final String? manufacturerName;
  final List<String> serviceUuids;
  final Map<String, dynamic> additionalData;
  final String deviceType;

  BleDeviceInfo({
    required this.id,
    this.name,
    required this.rssi,
    this.manufacturerName,
    required this.serviceUuids,
    required this.additionalData,
    required this.deviceType,
  });

  @override
  String toString() {
    return 'BleDeviceInfo(id: $id, name: $name, rssi: $rssi, type: $deviceType)';
  }
}

class BleManager {
  BleManager() {
    // Optional: set log level for debugging
    FlutterBluePlus.setLogLevel(LogLevel.verbose);
  }

  /// Check if BLE is supported and available
  Future<bool> isSupported() async {
    return await FlutterBluePlus.isSupported;
  }

  /// Check if Bluetooth adapter is on
  Future<bool> isBluetoothOn() async {
    final state = await FlutterBluePlus.adapterState.first;
    return state == BluetoothAdapterState.on;
  }

  /// Extract manufacturer name from manufacturer data
  String? _extractManufacturerName(Map<int, List<int>> manufacturerData) {
    if (manufacturerData.isEmpty) return null;

    // Get the first manufacturer data entry
    final firstEntry = manufacturerData.entries.first;
    final data = firstEntry.value;

    if (data.length < 2) return null;

    // First 2 bytes are the Company Identifier Code (CIC)
    final companyId = (data[1] << 8) | data[0];

    // Common manufacturer codes
    const manufacturerCodes = {
      0x004C: 'Apple',
      0x0006: 'Microsoft',
      0x000F: 'Broadcom',
      0x000D: 'Texas Instruments',
      0x000E: 'Nordic Semiconductor',
      0x0007: 'LG Electronics',
      0x0008: 'Renesas Electronics',
      0x0009: 'Samsung Electronics',
      0x000A: 'Qualcomm',
      0x000B: 'Marvell Technology Group',
      0x000C: 'Mediatek',
      0x0010: 'CSR',
      0x0011: 'Zer01 TV',
      0x0012: 'Samsung Electronics',
      0x0013: 'Apple',
      0x0014: 'Plantronics',
      0x0015: 'Samsung Electronics',
      0x0016: 'Garmin',
      0x0017: 'Eclipse',
      0x0018: 'Colourful',
      0x0019: 'Aplix',
      0x001A: 'Aplix',
      0x001B: 'Wicentric',
      0x001C: 'RIM',
      0x001D: 'RIM',
      0x001E: 'Qualcomm',
      0x001F: 'Qualcomm',
      0x0020: 'Qualcomm',
      0x0021: 'Qualcomm',
      0x0022: 'Qualcomm',
      0x0023: 'Qualcomm',
      0x0024: 'Qualcomm',
      0x0025: 'Qualcomm',
      0x0026: 'Qualcomm',
      0x0027: 'Qualcomm',
      0x0028: 'Qualcomm',
      0x0029: 'Qualcomm',
      0x002A: 'Qualcomm',
      0x002B: 'Qualcomm',
      0x002C: 'Qualcomm',
      0x002D: 'Qualcomm',
      0x002E: 'Qualcomm',
      0x002F: 'Qualcomm',
      0x0030: 'Qualcomm',
      0x0031: 'Qualcomm',
      0x0032: 'Qualcomm',
      0x0033: 'Qualcomm',
      0x0034: 'Qualcomm',
      0x0035: 'Qualcomm',
      0x0036: 'Qualcomm',
      0x0037: 'Qualcomm',
      0x0038: 'Qualcomm',
      0x0039: 'Qualcomm',
      0x003A: 'Qualcomm',
      0x003B: 'Qualcomm',
      0x003C: 'Qualcomm',
      0x003D: 'Qualcomm',
      0x003E: 'Qualcomm',
      0x003F: 'Qualcomm',
      0x0040: 'Qualcomm',
      0x0041: 'Qualcomm',
      0x0042: 'Qualcomm',
      0x0043: 'Qualcomm',
      0x0044: 'Qualcomm',
      0x0045: 'Qualcomm',
      0x0046: 'Qualcomm',
      0x0047: 'Qualcomm',
      0x0048: 'Qualcomm',
      0x0049: 'Qualcomm',
      0x004A: 'Qualcomm',
      0x004B: 'Qualcomm',
      0x004D: 'Apple',
      0x004E: 'Apple',
      0x004F: 'Apple',
      0x0050: 'Apple',
      0x0051: 'Apple',
      0x0052: 'Apple',
      0x0053: 'Apple',
      0x0054: 'Apple',
      0x0055: 'Apple',
      0x0056: 'Apple',
      0x0057: 'Apple',
      0x0058: 'Apple',
      0x0059: 'Apple',
      0x005A: 'Apple',
      0x005B: 'Apple',
      0x005C: 'Apple',
      0x005D: 'Apple',
      0x005E: 'Apple',
      0x005F: 'Apple',
      0x0060: 'Apple',
      0x0061: 'Apple',
      0x0062: 'Apple',
      0x0063: 'Apple',
      0x0064: 'Apple',
      0x0065: 'Apple',
      0x0066: 'Apple',
      0x0067: 'Apple',
      0x0068: 'Apple',
      0x0069: 'Apple',
      0x006A: 'Apple',
      0x006B: 'Apple',
      0x006C: 'Apple',
      0x006D: 'Apple',
      0x006E: 'Apple',
      0x006F: 'Apple',
      0x0070: 'Apple',
      0x0071: 'Apple',
      0x0072: 'Apple',
      0x0073: 'Apple',
      0x0074: 'Apple',
      0x0075: 'Apple',
      0x0076: 'Apple',
      0x0077: 'Apple',
      0x0078: 'Apple',
      0x0079: 'Apple',
      0x007A: 'Apple',
      0x007B: 'Apple',
      0x007C: 'Apple',
      0x007D: 'Apple',
      0x007E: 'Apple',
      0x007F: 'Apple',
      0x0080: 'Apple',
      0x0081: 'Apple',
      0x0082: 'Apple',
      0x0083: 'Apple',
      0x0084: 'Apple',
      0x0085: 'Apple',
      0x0086: 'Apple',
      0x0087: 'Apple',
      0x0088: 'Apple',
      0x0089: 'Apple',
      0x008A: 'Apple',
      0x008B: 'Apple',
      0x008C: 'Apple',
      0x008D: 'Apple',
      0x008E: 'Apple',
      0x008F: 'Apple',
      0x0090: 'Apple',
      0x0091: 'Apple',
      0x0092: 'Apple',
      0x0093: 'Apple',
      0x0094: 'Apple',
      0x0095: 'Apple',
      0x0096: 'Apple',
      0x0097: 'Apple',
      0x0098: 'Apple',
      0x0099: 'Apple',
      0x009A: 'Apple',
      0x009B: 'Apple',
      0x009C: 'Apple',
      0x009D: 'Apple',
      0x009E: 'Apple',
      0x009F: 'Apple',
      0x00A0: 'Apple',
      0x00A1: 'Apple',
      0x00A2: 'Apple',
      0x00A3: 'Apple',
      0x00A4: 'Apple',
      0x00A5: 'Apple',
      0x00A6: 'Apple',
      0x00A7: 'Apple',
      0x00A8: 'Apple',
      0x00A9: 'Apple',
      0x00AA: 'Apple',
      0x00AB: 'Apple',
      0x00AC: 'Apple',
      0x00AD: 'Apple',
      0x00AE: 'Apple',
      0x00AF: 'Apple',
      0x00B0: 'Apple',
      0x00B1: 'Apple',
      0x00B2: 'Apple',
      0x00B3: 'Apple',
      0x00B4: 'Apple',
      0x00B5: 'Apple',
      0x00B6: 'Apple',
      0x00B7: 'Apple',
      0x00B8: 'Apple',
      0x00B9: 'Apple',
      0x00BA: 'Apple',
      0x00BB: 'Apple',
      0x00BC: 'Apple',
      0x00BD: 'Apple',
      0x00BE: 'Apple',
      0x00BF: 'Apple',
      0x00C0: 'Apple',
      0x00C1: 'Apple',
      0x00C2: 'Apple',
      0x00C3: 'Apple',
      0x00C4: 'Apple',
      0x00C5: 'Apple',
      0x00C6: 'Apple',
      0x00C7: 'Apple',
      0x00C8: 'Apple',
      0x00C9: 'Apple',
      0x00CA: 'Apple',
      0x00CB: 'Apple',
      0x00CC: 'Apple',
      0x00CD: 'Apple',
      0x00CE: 'Apple',
      0x00CF: 'Apple',
      0x00D0: 'Apple',
      0x00D1: 'Apple',
      0x00D2: 'Apple',
      0x00D3: 'Apple',
      0x00D4: 'Apple',
      0x00D5: 'Apple',
      0x00D6: 'Apple',
      0x00D7: 'Apple',
      0x00D8: 'Apple',
      0x00D9: 'Apple',
      0x00DA: 'Apple',
      0x00DB: 'Apple',
      0x00DC: 'Apple',
      0x00DD: 'Apple',
      0x00DE: 'Apple',
      0x00DF: 'Apple',
      0x00E0: 'Apple',
      0x00E1: 'Apple',
      0x00E2: 'Apple',
      0x00E3: 'Apple',
      0x00E4: 'Apple',
      0x00E5: 'Apple',
      0x00E6: 'Apple',
      0x00E7: 'Apple',
      0x00E8: 'Apple',
      0x00E9: 'Apple',
      0x00EA: 'Apple',
      0x00EB: 'Apple',
      0x00EC: 'Apple',
      0x00ED: 'Apple',
      0x00EE: 'Apple',
      0x00EF: 'Apple',
      0x00F0: 'Apple',
      0x00F1: 'Apple',
      0x00F2: 'Apple',
      0x00F3: 'Apple',
      0x00F4: 'Apple',
      0x00F5: 'Apple',
      0x00F6: 'Apple',
      0x00F7: 'Apple',
      0x00F8: 'Apple',
      0x00F9: 'Apple',
      0x00FA: 'Apple',
      0x00FB: 'Apple',
      0x00FC: 'Apple',
      0x00FD: 'Apple',
      0x00FE: 'Apple',
      0x00FF: 'Apple',
    };

    return manufacturerCodes[companyId];
  }

  /// Determine device type based on service UUIDs and manufacturer data
  String _determineDeviceType(
      List<String> serviceUuids, String? manufacturerName) {
    // Check for common service UUIDs to identify device types
    for (final uuid in serviceUuids) {
      final upperUuid = uuid.toUpperCase();

      // Heart Rate Monitor
      if (upperUuid.contains('180D') || upperUuid.contains('2A37')) {
        return 'Heart Rate Monitor';
      }

      // Fitness Tracker / Wearable
      if (upperUuid.contains('1812') ||
          upperUuid.contains('1816') ||
          upperUuid.contains('1818') ||
          upperUuid.contains('1819')) {
        return 'Fitness Tracker';
      }

      // Smartphone / Phone
      if (upperUuid.contains('1800') ||
          upperUuid.contains('1801') ||
          upperUuid.contains('110E') ||
          upperUuid.contains('110F')) {
        return 'Smartphone';
      }

      // Headphones / Audio Device
      if (upperUuid.contains('110A') ||
          upperUuid.contains('110B') ||
          upperUuid.contains('110C') ||
          upperUuid.contains('110D')) {
        return 'Audio Device';
      }

      // Smart Watch
      if (upperUuid.contains('1812') || upperUuid.contains('1814')) {
        return 'Smart Watch';
      }

      // Medical Device
      if (upperUuid.contains('1808') ||
          upperUuid.contains('1809') ||
          upperUuid.contains('180A') ||
          upperUuid.contains('180B')) {
        return 'Medical Device';
      }

      // IoT Device
      if (upperUuid.contains('1815') || upperUuid.contains('181A')) {
        return 'IoT Device';
      }
    }

    // Check manufacturer name for additional clues
    if (manufacturerName != null) {
      if (manufacturerName.toLowerCase().contains('apple')) {
        return 'Apple Device';
      }
      if (manufacturerName.toLowerCase().contains('samsung')) {
        return 'Samsung Device';
      }
      if (manufacturerName.toLowerCase().contains('xiaomi')) {
        return 'Xiaomi Device';
      }
    }

    return 'Unknown Device';
  }

  /// Extract additional data from advertising packets
  Map<String, dynamic> _extractAdditionalData(AdvertisementData advData) {
    final additionalData = <String, dynamic>{};

    // Extract TX Power Level
    if (advData.txPowerLevel != null) {
      additionalData['txPowerLevel'] = advData.txPowerLevel;
    }

    // Extract Connectable status
    additionalData['connectable'] = advData.connectable;

    // Extract Manufacturer Data
    if (advData.manufacturerData.isNotEmpty) {
      additionalData['manufacturerData'] = advData.manufacturerData;
      additionalData['manufacturerDataLength'] =
          advData.manufacturerData.length;
    }

    // Extract Service Data
    if (advData.serviceData.isNotEmpty) {
      additionalData['serviceData'] = advData.serviceData;
    }

    return additionalData;
  }

  /// Convert ScanResult to BleDeviceInfo with enhanced information
  BleDeviceInfo _convertToBleDeviceInfo(ScanResult result) {
    final advData = result.advertisementData;
    final device = result.device;

    // Extract manufacturer name
    final manufacturerName = advData.manufacturerData.isNotEmpty
        ? _extractManufacturerName(advData.manufacturerData)
        : null;

    // Get service UUIDs
    final serviceUuids =
        advData.serviceUuids.map((uuid) => uuid.toString()).toList();

    // Determine device type
    final deviceType = _determineDeviceType(serviceUuids, manufacturerName);

    // Extract additional data
    final additionalData = _extractAdditionalData(advData);

    return BleDeviceInfo(
      id: device.remoteId.str,
      name: advData.advName.isNotEmpty ? advData.advName : null,
      rssi: result.rssi,
      manufacturerName: manufacturerName,
      serviceUuids: serviceUuids,
      additionalData: additionalData,
      deviceType: deviceType,
    );
  }

  /// Test BLE scanning capabilities and return diagnostic information
  Future<Map<String, dynamic>> testBleScanning() async {
    final diagnostics = <String, dynamic>{};

    try {
      // Test BLE support
      diagnostics['bleSupported'] = await isSupported();

      // Test Bluetooth state
      diagnostics['bluetoothOn'] = await isBluetoothOn();

      // Test adapter state
      final adapterState = await FlutterBluePlus.adapterState.first;
      diagnostics['adapterState'] = adapterState.toString();

      // Test if we can start a scan
      if (diagnostics['bleSupported'] && diagnostics['bluetoothOn']) {
        try {
          await FlutterBluePlus.stopScan(); // Stop any existing scan
          await FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));
          diagnostics['scanStartSuccess'] = true;

          // Wait a moment and check if we get any results
          await Future.delayed(const Duration(seconds: 3));
          final results = await FlutterBluePlus.scanResults.first;
          diagnostics['devicesFound'] = results.length;
          diagnostics['deviceIds'] =
              results.map((r) => r.device.remoteId.str).toList();

          await FlutterBluePlus.stopScan();
        } catch (e) {
          diagnostics['scanStartSuccess'] = false;
          diagnostics['scanError'] = e.toString();
        }
      }
    } catch (e) {
      diagnostics['error'] = e.toString();
    }

    return diagnostics;
  }

  /// Comprehensive scanning method with better device detection
  Stream<BleDeviceInfo> scanDevicesComprehensive({
    Duration timeout = const Duration(seconds: 20),
  }) async* {
    final Set<String> seenDevices = <String>{};

    try {
      // Check if BLE is supported
      if (!await isSupported()) {
        throw Exception('BLE is not supported on this device');
      }

      // Check if Bluetooth is on
      if (!await isBluetoothOn()) {
        throw Exception('Bluetooth is not enabled');
      }

      // Stop any existing scan first
      await FlutterBluePlus.stopScan();

      // Start new scan with aggressive settings for maximum device detection
      await FlutterBluePlus.startScan(
        timeout: timeout,
        androidUsesFineLocation:
            true, // Use fine location for better scanning on Android
      );

      // Listen to scan results and deduplicate
      await for (final results in FlutterBluePlus.scanResults) {
        for (final result in results) {
          final deviceId = result.device.remoteId.str;

          if (!seenDevices.contains(deviceId)) {
            seenDevices.add(deviceId);
            yield _convertToBleDeviceInfo(result);
          }
        }
      }
    } catch (e) {
      throw Exception('Failed to start comprehensive BLE scan: $e');
    }
  }

  /// Starts scanning and returns a broadcast stream of BleDeviceInfo
  Stream<BleDeviceInfo> scanDevicesEnhanced({
    Duration timeout = const Duration(seconds: 15),
  }) async* {
    try {
      // Check if BLE is supported
      if (!await isSupported()) {
        throw Exception('BLE is not supported on this device');
      }

      // Check if Bluetooth is on
      if (!await isBluetoothOn()) {
        throw Exception('Bluetooth is not enabled');
      }

      // Stop any existing scan first
      await FlutterBluePlus.stopScan();

      // Start new scan with more aggressive settings for better device detection
      await FlutterBluePlus.startScan(
        timeout: timeout,
        androidUsesFineLocation:
            true, // Use fine location for better scanning on Android
      );

      // Return the enhanced scan results stream
      yield* FlutterBluePlus.scanResults
          .expand((results) => results)
          .map(_convertToBleDeviceInfo);
    } catch (e) {
      throw Exception('Failed to start BLE scan: $e');
    }
  }

  /// Starts scanning and returns a broadcast stream of ScanResults (original method)
  Stream<ScanResult> scanDevices({
    Duration timeout = const Duration(seconds: 15),
  }) async* {
    try {
      // Check if BLE is supported
      if (!await isSupported()) {
        throw Exception('BLE is not supported on this device');
      }

      // Check if Bluetooth is on
      if (!await isBluetoothOn()) {
        throw Exception('Bluetooth is not enabled');
      }

      // Stop any existing scan first
      await FlutterBluePlus.stopScan();

      // Start new scan with better settings
      await FlutterBluePlus.startScan(
        timeout: timeout,
        androidUsesFineLocation: true,
      );

      // Return the scan results stream
      yield* FlutterBluePlus.scanResults.expand((results) => results);
    } catch (e) {
      throw Exception('Failed to start BLE scan: $e');
    }
  }

  /// Stops ongoing BLE scan
  Future<void> stopScan() async {
    try {
      await FlutterBluePlus.stopScan();
    } catch (e) {
      // Ignore errors when stopping scan
      print('Warning: Error stopping scan: $e');
    }
  }

  /// Get current scan state
  Stream<bool> get isScanning => FlutterBluePlus.isScanning;

  /// Get adapter state changes
  Stream<BluetoothAdapterState> get adapterState =>
      FlutterBluePlus.adapterState;
}
