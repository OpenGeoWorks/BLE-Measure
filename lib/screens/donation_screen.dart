// lib/screens/donation_screen.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// OnCrowdr campaign for OPENGEOWORKS Apps.
const String kDonationUrl =
    'https://www.oncrowdr.com/explore/c/68fb6ba66143287a1bfa0583';

class DonationScreen extends StatelessWidget {
  const DonationScreen({super.key});

  Future<void> _openDonationLink(BuildContext context) async {
    final uri = Uri.parse(kDonationUrl);
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && context.mounted) {
        _showError(context);
      }
    } catch (_) {
      if (context.mounted) {
        _showError(context);
      }
    }
  }

  void _showError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Could not open donation link. Please try again.'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donation'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 24),
                      Center(
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.indigo.shade100,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Icon(
                            Icons.favorite,
                            size: 44,
                            color: Colors.indigo.shade700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Support OPENGEOWORKS',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'BLE Distance Tracker is part of the OPENGEOWORKS initiative. '
                        'Your donation helps fund development and research in '
                        'Surveying & Geo-informatics, including tools for distance '
                        'sensing and positioning using off-the-shelf Bluetooth devices.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'All contributions go towards sustaining this project and '
                        'related academic work at the University of Lagos.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.5,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => _openDonationLink(context),
                icon: const Icon(Icons.open_in_browser, size: 22),
                label: const Text('Donate now'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
