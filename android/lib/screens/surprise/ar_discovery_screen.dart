import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:fitquest/services/ar_service.dart';
import 'package:fitquest/services/location_service.dart';
import 'package:fitquest/services/surprise_service.dart';
import 'package:fitquest/utils/routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ARDiscoveryScreen extends StatefulWidget {
  const ARDiscoveryScreen({super.key});

  @override
  State<ARDiscoveryScreen> createState() => _ARDiscoveryScreenState();
}

class _ARDiscoveryScreenState extends State<ARDiscoveryScreen> {
  late ARService _arService;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeAR();
  }

  Future<void> _initializeAR() async {
    try {
      final locationService = Provider.of<LocationService>(context, listen: false);
      final surpriseService = Provider.of<SurpriseService>(context, listen: false);
      
      _arService = ARService(surpriseService, locationService);
      await _arService.startCamera();
      
      if (mounted) {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = e.toString();
        });
      }
    }
  }

  @override
  void dispose() {
    _arService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(l10n.loading),
            ],
          ),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.error),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(_error!),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _error = null;
                  });
                  _initializeAR();
                },
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // AR View
          ArCoreView(
            onArCoreViewCreated: _arService.initializeAR,
            enableTapRecognizer: true,
          ),
          
          // UI Overlay
          SafeArea(
            child: Column(
              children: [
                // Top Bar
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        l10n.discoverSurprises,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.help_outline, color: Colors.white),
                        onPressed: () => _showHelpDialog(context),
                      ),
                    ],
                  ),
                ),
                
                const Spacer(),
                
                // Bottom Info
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.arDiscoveryHint,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.surpriseList,
                          );
                        },
                        icon: const Icon(Icons.list),
                        label: Text(l10n.viewAllSurprises),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.howToDiscover),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HelpItem(
              icon: Icons.camera_alt,
              text: l10n.arHelpCamera,
            ),
            const SizedBox(height: 16),
            _HelpItem(
              icon: Icons.location_on,
              text: l10n.arHelpLocation,
            ),
            const SizedBox(height: 16),
            _HelpItem(
              icon: Icons.touch_app,
              text: l10n.arHelpTap,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.gotIt),
          ),
        ],
      ),
    );
  }
}

class _HelpItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _HelpItem({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 16),
        Expanded(
          child: Text(text),
        ),
      ],
    );
  }
} 