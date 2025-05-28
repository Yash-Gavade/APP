import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:provider/provider.dart';
import 'package:fitquest/services/surprise_service.dart';
import 'package:fitquest/utils/routes.dart';

class ARDiscoveryScreen extends StatefulWidget {
  const ARDiscoveryScreen({super.key});

  @override
  State<ARDiscoveryScreen> createState() => _ARDiscoveryScreenState();
}

class _ARDiscoveryScreenState extends State<ARDiscoveryScreen> {
  ArCoreController? arController;
  bool _isLoading = true;
  List<Map<String, dynamic>> _nearbySurprises = [];

  @override
  void initState() {
    super.initState();
    _loadNearbySurprises();
  }

  @override
  void dispose() {
    arController?.dispose();
    super.dispose();
  }

  Future<void> _loadNearbySurprises() async {
    try {
      final surprises = await Provider.of<SurpriseService>(context, listen: false)
          .getNearbySurprises();
      if (mounted) {
        setState(() {
          _nearbySurprises = surprises;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading surprises: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    arController = controller;
    _addSurprisesToAR();
  }

  void _addSurprisesToAR() {
    if (arController == null) return;

    for (var i = 0; i < _nearbySurprises.length; i++) {
      final surprise = _nearbySurprises[i];
      final node = ArCoreNode(
        name: surprise['id'],
        shape: ArCoreSphere(
          materials: [
            ArCoreMaterial(
              color: surprise['isUnlocked'] ? Colors.green : Colors.blue,
            ),
          ],
          radius: 0.1,
        ),
        position: vector.Vector3(
          (i % 3) * 0.3 - 0.3, // Spread surprises in a grid
          (i ~/ 3) * 0.3 - 0.3,
          -1.0,
        ),
      );

      node.onTapDown = (_) {
        Navigator.pushNamed(
          context,
          AppRoutes.surpriseDetails,
          arguments: {'id': surprise['id']},
        );
      };

      arController!.addArCoreNode(node);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AR Discovery'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() => _isLoading = true);
              _loadNearbySurprises();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _nearbySurprises.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.search_off,
                        size: 64,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No surprises nearby',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, AppRoutes.surpriseDiscovery);
                        },
                        icon: const Icon(Icons.list),
                        label: const Text('View List'),
                      ),
                    ],
                  ),
                )
              : ArCoreView(
                  onArCoreViewCreated: _onArCoreViewCreated,
                  enableTapRecognizer: true,
                ),
    );
  }
} 