# Bluetooth Distance Measurement App

A Flutter application that measures distance between devices using Bluetooth Low Energy (BLE) technology.

## Features

### Enhanced Device Identification
The app now provides much more detailed information about discovered BLE devices:

#### What the ID Represents
- **ID**: This is the device's **MAC address** (Bluetooth address) - a unique 48-bit identifier in hexadecimal format (e.g., `6A:2F:01:17:2E:AE`)
- **RSSI**: Received Signal Strength Indicator in dBm, indicating signal strength and approximate distance

#### Device Information Extraction
Instead of just showing "Unknown Device", the app now extracts:

1. **Device Names**: When available from advertising packets
2. **Manufacturer Information**: Extracted from manufacturer data using Company Identifier Codes (CIC)
3. **Device Types**: Automatically categorized based on service UUIDs and manufacturer data:
   - Apple Device
   - Samsung Device
   - Smartphone
   - Audio Device (Headphones, Speakers)
   - Fitness Tracker
   - Smart Watch
   - Heart Rate Monitor
   - Medical Device
   - IoT Device
   - Unknown Device (fallback)

4. **Service Information**: Number of BLE services available
5. **Additional Data**: TX Power Level, Connectable status, Manufacturer data length

#### Visual Enhancements
- **Color-coded device types** for easy identification
- **Enhanced UI** with cards showing detailed device information
- **Manufacturer badges** when available
- **Service count** indicators

## Technical Implementation

### BLE Manager Enhancements
The `BleManager` class now includes:

- `BleDeviceInfo` class with comprehensive device information
- `_extractManufacturerName()` method that decodes manufacturer codes
- `_determineDeviceType()` method that identifies device types from service UUIDs
- `_extractAdditionalData()` method for additional advertising packet data
- `scanDevicesEnhanced()` method that returns enriched device information

### Manufacturer Code Support
The app recognizes manufacturer codes for major companies:
- Apple (0x004C, 0x0013, and many others)
- Samsung Electronics (0x0009, 0x0012, 0x0015)
- Microsoft (0x0006)
- Qualcomm (0x000A and many others)
- And many more...

### Service UUID Detection
The app identifies device types by analyzing service UUIDs:
- Heart Rate (0x180D, 0x2A37)
- Fitness/Health (0x1812, 0x1816, 0x1818, 0x1819)
- Phone (0x1800, 0x1801, 0x110E, 0x110F)
- Audio (0x110A, 0x110B, 0x110C, 0x110D)
- And more...

## Usage

1. **Grant Permissions**: Location and Bluetooth permissions are required
2. **Enable Bluetooth**: Turn on Bluetooth on your device
3. **Start Scanning**: Tap the play button to begin scanning
4. **View Devices**: See detailed information about each discovered device
5. **Select Device**: Tap on a device to proceed to distance measurement

## Requirements

- Flutter 3.0+
- Android 6.0+ (API level 23+) or iOS 11.0+
- Physical device (BLE scanning has limited support on emulators)
- Location and Bluetooth permissions

## Dependencies

- `flutter_blue_plus`: BLE functionality
- `permission_handler`: Permission management

## Notes

- **Emulator Limitation**: Android emulators have limited BLE support. For best results, test on a physical device.
- **Permission Requirements**: Location permission is required for BLE scanning on Android.
- **Device Names**: Not all devices broadcast their names. The app will show device type and manufacturer when names are unavailable.
