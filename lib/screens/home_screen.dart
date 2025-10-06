import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/distance_provider.dart';

class HomeScreen extends StatefulWidget {
  final String targetDeviceId;

  const HomeScreen({super.key, required this.targetDeviceId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Start tracking when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<DistanceProvider>(context, listen: false);
      provider.startTracking(widget.targetDeviceId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DistanceProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("BLE Distance Tracker"),
        actions: [
          IconButton(
            icon: const Icon(Icons.stop_circle_outlined),
            tooltip: "Stop Tracking",
            onPressed: () {
              provider.stopTracking();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Status indicator
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: provider.isTracking
                    ? Colors.green.shade100
                    : Colors.orange.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    provider.isTracking
                        ? Icons.bluetooth_searching
                        : Icons.bluetooth_disabled,
                    color: provider.isTracking
                        ? Colors.green.shade800
                        : Colors.orange.shade800,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    provider.isTracking ? "Tracking Active" : "Not Tracking",
                    style: TextStyle(
                      color: provider.isTracking
                          ? Colors.green.shade800
                          : Colors.orange.shade800,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Error message
            if (provider.errorMessage != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error, color: Colors.red.shade800),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        provider.errorMessage!,
                        style: TextStyle(color: Colors.red.shade800),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 24),

            // Device info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Icon(Icons.bluetooth, size: 48, color: Colors.blue),
                    const SizedBox(height: 8),
                    Text(
                      "Target Device",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.targetDeviceId,
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Distance and RSSI display
            Expanded(
              child: provider.distance == null
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text("Searching for device..."),
                          SizedBox(height: 8),
                          Text(
                            "Make sure the target device is nearby and advertising",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // RSSI Card
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                const Icon(Icons.signal_cellular_alt,
                                    size: 32, color: Colors.orange),
                                const SizedBox(height: 8),
                                Text(
                                  "Signal Strength",
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "${provider.rssi?.toStringAsFixed(1)} dBm",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Distance Card
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                const Icon(Icons.straighten,
                                    size: 32, color: Colors.blue),
                                const SizedBox(height: 8),
                                Text(
                                  "Estimated Distance",
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "${provider.distance} meters",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Info text
                        const Text(
                          "Distance is calculated using RSSI values\nand may vary based on environmental factors",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
