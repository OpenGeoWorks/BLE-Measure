// lib/providers/distance_provider.dart

import 'dart:collection';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../ble/distance_calculator.dart';

class DistanceProvider with ChangeNotifier {
  StreamSubscription? _scanSub;
  StreamSubscription? _scanStateSub;
  double? distance;
  double? rssi;
  bool isTracking = false;
  String? errorMessage;

  final int _windowSize = 5;
  final Queue<double> _rssiWindow = Queue<double>();

  void _addRssi(double newRssi) {
    _rssiWindow.addLast(newRssi);
    if (_rssiWindow.length > _windowSize) {
      _rssiWindow.removeFirst();
    }

    rssi = _rssiWindow.reduce((a, b) => a + b) / _rssiWindow.length;
    distance = DistanceCalculator.calculate(rssi!);
    notifyListeners();
  }

  Future<void> startTracking(String targetDeviceId) async {
    try {
      // Clear previous state
      stopTracking();

      // Check if Bluetooth is on
      final adapterState = await FlutterBluePlus.adapterState.first;
      if (adapterState != BluetoothAdapterState.on) {
        errorMessage = "Bluetooth is not enabled";
        notifyListeners();
        return;
      }

      // Stop any existing scan
      await FlutterBluePlus.stopScan();

      // Start scanning
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 30));

      isTracking = true;
      errorMessage = null;
      notifyListeners();

      // Listen for scan results
      _scanSub = FlutterBluePlus.scanResults.listen((results) {
        for (final result in results) {
          if (result.device.remoteId.str == targetDeviceId) {
            _addRssi(result.rssi.toDouble());
            break;
          }
        }
      }, onError: (error) {
        errorMessage = "Scan error: $error";
        notifyListeners();
      });

      // Monitor scan state
      _scanStateSub = FlutterBluePlus.isScanning.listen((scanning) {
        if (!scanning && isTracking) {
          // Restart scan if it stopped unexpectedly
          _restartScan();
        }
      });
    } catch (e) {
      errorMessage = "Failed to start tracking: $e";
      isTracking = false;
      notifyListeners();
    }
  }

  Future<void> _restartScan() async {
    if (!isTracking) return;

    try {
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 30));
    } catch (e) {
      errorMessage = "Failed to restart scan: $e";
      notifyListeners();
    }
  }

  void stopTracking() {
    _scanSub?.cancel();
    _scanStateSub?.cancel();
    _scanSub = null;
    _scanStateSub = null;

    FlutterBluePlus.stopScan();

    isTracking = false;
    _rssiWindow.clear();
    rssi = null;
    distance = null;
    errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    stopTracking();
    super.dispose();
  }
}
