# Bluetooth Distance Measurement App

A Flutter application that measures distance between devices using Bluetooth Low Energy (BLE) technology. The app provides comprehensive device discovery with detailed information extraction and real-time distance tracking.

## Features

### 🔍 Enhanced Device Discovery
The app provides detailed information about discovered BLE devices:

#### Device Identification
- **Device ID**: MAC address (Bluetooth address) - unique 48-bit identifier (e.g., `6A:2F:01:17:2E:AE`)
- **Device Names**: Extracted from advertising packets when available
- **RSSI**: Received Signal Strength Indicator in dBm for signal strength analysis

#### Smart Device Classification
The app automatically categorizes devices based on service UUIDs and manufacturer data:
- **Apple Device** - Recognized by manufacturer codes
- **Samsung Device** - Samsung Electronics devices
- **Smartphone** - Phone-related service UUIDs
- **Audio Device** - Headphones, speakers, audio peripherals
- **Fitness Tracker** - Health and fitness monitoring devices
- **Smart Watch** - Wearable devices
- **Heart Rate Monitor** - Medical monitoring devices
- **Medical Device** - Healthcare equipment
- **IoT Device** - Internet of Things devices
- **Unknown Device** - Fallback for unrecognized devices

#### Manufacturer Detection
Extracts manufacturer information using Company Identifier Codes (CIC):
- Apple (0x004C, 0x0013, and extensive range)
- Samsung Electronics (0x0009, 0x0012, 0x0015)
- Microsoft (0x0006)
- Qualcomm (0x000A and extensive range)
- Broadcom, Texas Instruments, Nordic Semiconductor, and many more

### 📊 Real-Time Distance Tracking
- **Live RSSI Monitoring**: Continuous signal strength measurement
- **Distance Calculation**: Uses RSSI-based distance estimation with configurable parameters
- **Signal Smoothing**: Moving average window for stable readings
- **Real-time Updates**: Live distance and signal strength display

### 🎨 User Interface Features
- **Color-coded Device Types**: Visual identification with distinct colors
- **Comprehensive Device Cards**: Detailed information display
- **Status Indicators**: Bluetooth state, scanning status, tracking status
- **Error Handling**: Clear error messages and diagnostic tools
- **Responsive Design**: Optimized for mobile devices

## Technical Implementation

### Architecture
- **Provider Pattern**: State management using Provider package
- **Stream-based Scanning**: Real-time BLE device discovery
- **Modular Design**: Separated concerns with dedicated managers and providers

### Core Components

#### BleManager
- `BleDeviceInfo` class with comprehensive device information
- `_extractManufacturerName()` - Decodes manufacturer codes
- `_determineDeviceType()` - Identifies device types from service UUIDs
- `_extractAdditionalData()` - Extracts advertising packet data
- `scanDevicesComprehensive()` - Enhanced scanning with deduplication
- `testBleScanning()` - Diagnostic capabilities

#### DistanceProvider
- Real-time RSSI tracking with moving average smoothing
- Automatic scan restart on interruption
- Error handling and state management
- Stream-based architecture for live updates

#### DistanceCalculator
- RSSI-to-distance conversion using path loss model
- Configurable transmission power and path loss exponent
- Accurate distance estimation with environmental considerations

### Service UUID Detection
The app identifies device types by analyzing service UUIDs:
- **Heart Rate**: 0x180D, 0x2A37
- **Fitness/Health**: 0x1812, 0x1816, 0x1818, 0x1819
- **Phone**: 0x1800, 0x1801, 0x110E, 0x110F
- **Audio**: 0x110A, 0x110B, 0x110C, 0x110D
- **Medical**: 0x1808, 0x1809, 0x180A, 0x180B
- **IoT**: 0x1815, 0x181A

## Usage

### Getting Started
1. **Grant Permissions**: Allow location and Bluetooth permissions when prompted
2. **Enable Bluetooth**: Ensure Bluetooth is turned on
3. **Start Scanning**: Tap the play button to begin device discovery
4. **Select Device**: Tap on a discovered device to start distance tracking
5. **Monitor Distance**: View real-time distance and signal strength readings

### Features
- **Device Discovery**: Comprehensive scanning with detailed device information
- **Distance Tracking**: Real-time distance measurement with signal smoothing
- **Diagnostic Tools**: Built-in BLE diagnostics for troubleshooting
- **Error Handling**: Clear error messages and status indicators

## Requirements

- **Flutter**: 3.0+ (SDK 3.5.4+)
- **Android**: 6.0+ (API level 23+)
- **iOS**: 11.0+
- **Hardware**: Physical device (BLE scanning has limited support on emulators)
- **Permissions**: Location and Bluetooth permissions required

## Dependencies

- `flutter_blue_plus: ^1.35.5` - BLE functionality and device management
- `provider: ^6.1.5` - State management and reactive programming
- `permission_handler: ^12.0.1` - Permission management
- `cupertino_icons: ^1.0.8` - iOS-style icons

## Important Notes

### Platform Considerations
- **Android Emulators**: Limited BLE support - test on physical devices for best results
- **iOS Simulators**: BLE functionality may be restricted - use physical devices
- **Location Services**: Required for BLE scanning on Android devices

### Accuracy Considerations
- **Environmental Factors**: Distance accuracy depends on environment (walls, interference)
- **Device Variations**: Different devices may have varying transmission power
- **Signal Fluctuations**: RSSI values can vary due to multipath propagation
- **Calibration**: Distance calculation uses standard path loss model (may need device-specific calibration)

### Troubleshooting
- Use the built-in diagnostic tool (bug icon) to check BLE status
- Ensure target devices are in discoverable/advertising mode
- Check that location services are enabled
- Verify Bluetooth permissions are granted
- Test on physical devices rather than emulators

## Project Structure

```
lib/
├── ble/
│   ├── ble_manager.dart          # BLE device management and scanning
│   └── distance_calculator.dart  # RSSI to distance conversion
├── providers/
│   └── distance_provider.dart    # State management for distance tracking
├── screens/
│   ├── device_list_screen.dart   # Device discovery and selection
│   └── home_screen.dart         # Distance tracking interface
└── main.dart                    # App entry point
```
