// lib/screens/about_screen.dart

import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Icon/Logo Area
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.indigo.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.bluetooth_searching,
                  size: 60,
                  color: Colors.indigo,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // App Name
            const Center(
              child: Text(
                'BLE Distance Tracker',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Project Overview Section
            const Text(
              'Project Overview',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'This application was developed as a final year project in the Department of '
              'Surveying & Geo-informatics, Faculty of Engineering, University of Lagos. '
              'The project explores the practical applications of Bluetooth Low Energy (BLE) '
              'technology for distance measurement and positioning.\n\n'
              'The BLE Distance Tracker enables users to discover nearby Bluetooth devices and '
              'estimate their distance using Received Signal Strength Indicator (RSSI) values. '
              'This research investigates the viability of using commercially available Bluetooth '
              'devices as cost-effective alternatives for proximity sensing and distance estimation.',
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),

            // Project Title
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.indigo.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.school, color: Colors.indigo.shade700),
                      const SizedBox(width: 8),
                      const Text(
                        'Project Title',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '"Accessing the Accuracy and Precision of Off-the-Shelf Bluetooth Devices for Distance Sensing"',
                    style: TextStyle(
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Key Achievements Section
            const Text(
              'Key Achievements',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildFeatureItem(
              Icons.bluetooth_connected,
              'Real-Time BLE Scanning',
              'Comprehensive scanning and detection of nearby Bluetooth Low Energy devices',
            ),
            _buildFeatureItem(
              Icons.analytics_outlined,
              'RSSI-Based Distance Estimation',
              'Algorithmic distance calculation using signal strength measurements',
            ),
            _buildFeatureItem(
              Icons.assessment,
              'Accuracy Assessment',
              'Evaluation of precision and accuracy for off-the-shelf Bluetooth devices',
            ),
            _buildFeatureItem(
              Icons.devices,
              'Device Classification',
              'Automatic identification and categorization of different device types',
            ),
            const SizedBox(height: 32),

            // Technical Architecture Section
            const Text(
              'Technical Architecture',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTechItem('Framework', 'Flutter (Dart)'),
                  _buildTechItem('BLE Library', 'flutter_blue_plus'),
                  _buildTechItem('State Management', 'Provider Pattern'),
                  _buildTechItem('Platform Support', 'Android & iOS'),
                  _buildTechItem(
                      'Architecture', 'MVVM with Repository Pattern'),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Project Team Section
            const Text(
              'Project Team',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildTeamMember(
              'Academic Supervisor',
              'Surv. Abiodun Olawale Alabi',
              Icons.person_outline,
            ),
            _buildTeamMember(
              'Assistant Academic Supervisor',
              'Mr Tosin Salami',
              Icons.person_outline,
            ),
            _buildTeamMember(
              'Student Developer',
              'Oluwatomiwa Adebisi',
              Icons.code,
            ),
            const SizedBox(height: 32),

            // Institution Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🎓 University of Lagos',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Faculty of Engineering',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    'Department of Surveying & Geo-informatics',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 12),
                  Text(
                    '© 2024 Final Year Project',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.indigo.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.indigo, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMember(String role, String name, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.indigo.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.indigo, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  role,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
