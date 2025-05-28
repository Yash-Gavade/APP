import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:fitquest/models/surprise_model.dart';
import 'package:fitquest/services/surprise_service.dart';
import 'package:fitquest/services/location_service.dart';

class ARService {
  final SurpriseService _surpriseService;
  final LocationService _locationService;
  ArCoreController? _arController;
  List<ArCoreNode> _arNodes = [];
  List<SurpriseModel> _nearbySurprises = [];

  ARService(this._surpriseService, this._locationService);

  Future<void> initializeAR() async {
    try {
      _arController = ArCoreController(
        onArCoreViewCreated: _onArCoreViewCreated,
        enableTapRecognizer: true,
      );
    } catch (e) {
      debugPrint('Error initializing AR: $e');
    }
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    _arController = controller;
    _arController?.onNodeTap = _onNodeTapped;
    _startSurpriseDetection();
  }

  Future<void> _startSurpriseDetection() async {
    try {
      final currentLocation = await _locationService.getCurrentLocation();
      if (currentLocation == null) return;

      // Get nearby surprises
      _nearbySurprises = await _surpriseService.getNearbySurprises(
        currentLocation,
        radius: 100, // 100 meters radius
        status: SurpriseStatus.hidden,
      );

      // Create AR nodes for each surprise
      for (final surprise in _nearbySurprises) {
        _addSurpriseNode(surprise);
      }
    } catch (e) {
      debugPrint('Error detecting surprises: $e');
    }
  }

  void _addSurpriseNode(SurpriseModel surprise) {
    if (_arController == null) return;

    final node = ArCoreNode(
      name: surprise.id,
      shape: ArCoreReferenceNode(
        objectUrl: 'assets/models/surprise.glb',
        position: Vector3(
          surprise.location.latitude,
          surprise.location.longitude,
          0,
        ),
      ),
    );

    _arNodes.add(node);
    _arController?.addArCoreNode(node);
  }

  void _onNodeTapped(List<String> nodeNames) {
    if (nodeNames.isEmpty) return;

    final surpriseId = nodeNames.first;
    final surprise = _nearbySurprises.firstWhere(
      (s) => s.id == surpriseId,
      orElse: () => null,
    );

    if (surprise != null) {
      _surpriseService.discoverSurprise(surprise.id);
    }
  }

  Future<void> startCamera() async {
    try {
      await _locationService.requestLocationPermission();
      await initializeAR();
    } catch (e) {
      debugPrint('Error starting camera: $e');
    }
  }

  void dispose() {
    for (final node in _arNodes) {
      _arController?.removeNode(nodeName: node.name);
    }
    _arNodes.clear();
    _arController?.dispose();
    _arController = null;
  }
} 