import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitquest/services/ar_service.dart';

class ARDiscoveryScreen extends StatefulWidget {
  const ARDiscoveryScreen({super.key});

  @override
  State<ARDiscoveryScreen> createState() => _ARDiscoveryScreenState();
}

class _ARDiscoveryScreenState extends State<ARDiscoveryScreen> {
  bool _isScanning = false;
  String? _currentSurprise;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AR Discovery'),
      ),
      body: Stack(
        children: [
          // AR View (placeholder for now)
          Center(
            child: Container(
              color: Colors.black87,
              child: const Center(
                child: Text(
                  'AR View Coming Soon',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          // Overlay UI
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_currentSurprise != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        'Found: $_currentSurprise',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _isScanning = !_isScanning;
                        if (_isScanning) {
                          _startScanning();
                        } else {
                          _stopScanning();
                        }
                      });
                    },
                    icon: Icon(_isScanning ? Icons.stop : Icons.search),
                    label: Text(_isScanning ? 'Stop Scanning' : 'Start Scanning'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _startScanning() {
    // TODO: Implement AR scanning
    // This would use the ARService to start scanning for surprises
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && _isScanning) {
        setState(() {
          _currentSurprise = 'Hidden Achievement!';
        });
      }
    });
  }

  void _stopScanning() {
    // TODO: Stop AR scanning
    setState(() {
      _currentSurprise = null;
    });
  }
} 