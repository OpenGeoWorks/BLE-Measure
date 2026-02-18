// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/distance_provider.dart';
import 'screens/device_list_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => DistanceProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BLE Distance Tracker',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const DeviceListScreen(),
    );
  }
}
