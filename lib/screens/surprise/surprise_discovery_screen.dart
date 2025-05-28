import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:fitquest/services/surprise_service.dart';
import 'package:fitquest/models/surprise_model.dart';
import 'package:fitquest/utils/routes.dart';
import 'package:lottie/lottie.dart';

class SurpriseDiscoveryScreen extends StatefulWidget {
  final String surpriseId;
  final LatLng location;

  const SurpriseDiscoveryScreen({
    super.key,
    required this.surpriseId,
    required this.location,
  });

  @override
  State<SurpriseDiscoveryScreen> createState() => _SurpriseDiscoveryScreenState();
}

class _SurpriseDiscoveryScreenState extends State<SurpriseDiscoveryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late GoogleMapController _mapController;
  SurpriseModel? _surprise;
  bool _isLoading = true;
  bool _isDiscovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _loadSurprise();
  }

  @override
  void dispose() {
    _controller.dispose();
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _loadSurprise() async {
    try {
      final surpriseService = Provider.of<SurpriseService>(context, listen: false);
      final nearbySurprises = await surpriseService
          .getNearbySurprises(widget.location, 100)
          .first;
      
      _surprise = nearbySurprises.firstWhere(
        (s) => s.id == widget.surpriseId,
      );
      
      if (_surprise != null) {
        _controller.forward();
      }
    } catch (e) {
      print('Error loading surprise: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _discoverSurprise() async {
    if (_surprise == null) return;

    setState(() => _isLoading = true);

    try {
      final surpriseService = Provider.of<SurpriseService>(context, listen: false);
      await surpriseService.discoverSurprise(_surprise!.id);
      
      if (mounted) {
        setState(() => _isDiscovered = true);
        _controller.repeat();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _claimSurprise() async {
    if (_surprise == null) return;

    try {
      final surpriseService = Provider.of<SurpriseService>(context, listen: false);
      await surpriseService.claimSurprise(_surprise!.id);
      
      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.surpriseDetails,
          arguments: {'surpriseId': _surprise!.id},
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_surprise == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Surprise Not Found')),
        body: const Center(
          child: Text('The surprise you\'re looking for is no longer available.'),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // Map
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: widget.location,
              zoom: 17,
            ),
            onMapCreated: (controller) => _mapController = controller,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            markers: {
              Marker(
                markerId: const MarkerId('surprise'),
                position: widget.location,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueViolet,
                ),
              ),
            },
            circles: {
              Circle(
                circleId: const CircleId('search_area'),
                center: widget.location,
                radius: _surprise!.radius,
                fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                strokeColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                strokeWidth: 2,
              ),
            },
          ),
          
          // Content Overlay
          SafeArea(
            child: Column(
              children: [
                // App Bar
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  title: Text(_surprise!.title),
                ),
                
                // Surprise Info
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Animation
                          if (_isDiscovered)
                            Lottie.asset(
                              'assets/animations/surprise_found.json',
                              controller: _controller,
                              width: 200,
                              height: 200,
                            )
                          else
                            Lottie.asset(
                              'assets/animations/surprise_search.json',
                              controller: _controller,
                              width: 200,
                              height: 200,
                            ),
                          
                          const SizedBox(height: 24),
                          
                          // Status Message
                          Text(
                            _surprise!.statusMessage,
                            style: Theme.of(context).textTheme.headlineSmall,
                            textAlign: TextAlign.center,
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // AI Hint
                          if (_surprise!.aiHint != null) ...[
                            Text(
                              _surprise!.aiHint!,
                              style: Theme.of(context).textTheme.bodyLarge,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                          ],
                          
                          // Action Button
                          if (!_isDiscovered)
                            ElevatedButton.icon(
                              onPressed: _isLoading ? null : _discoverSurprise,
                              icon: const Icon(Icons.search),
                              label: const Text('Discover Surprise'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 16,
                                ),
                              ),
                            )
                          else
                            ElevatedButton.icon(
                              onPressed: _isLoading ? null : _claimSurprise,
                              icon: const Icon(Icons.card_giftcard),
                              label: const Text('Claim Reward'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 16,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
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