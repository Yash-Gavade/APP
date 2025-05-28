import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitquest/services/surprise_service.dart';
import 'package:fitquest/models/surprise_model.dart';
import 'package:lottie/lottie.dart';

class SurpriseDetailsScreen extends StatefulWidget {
  final String surpriseId;

  const SurpriseDetailsScreen({
    super.key,
    required this.surpriseId,
  });

  @override
  State<SurpriseDetailsScreen> createState() => _SurpriseDetailsScreenState();
}

class _SurpriseDetailsScreenState extends State<SurpriseDetailsScreen> {
  bool _isLoading = true;
  SurpriseModel? _surprise;

  @override
  void initState() {
    super.initState();
    _loadSurpriseDetails();
  }

  Future<void> _loadSurpriseDetails() async {
    try {
      final surprise = await Provider.of<SurpriseService>(context, listen: false)
          .getSurpriseDetails(widget.surpriseId);
      if (mounted) {
        setState(() {
          _surprise = surprise;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading surprise details: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Surprise Details'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _surprise == null
              ? const Center(child: Text('Surprise not found'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (_surprise!.isUnlocked)
                        Lottie.asset(
                          'assets/animations/unlock.json',
                          height: 200,
                          repeat: false,
                        )
                      else
                        Icon(
                          Icons.lock_outline,
                          size: 100,
                          color: Colors.grey[400],
                        ),
                      const SizedBox(height: 24),
                      Text(
                        _surprise!.title,
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _surprise!.description,
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      if (!_surprise!.isUnlocked)
                        ElevatedButton.icon(
                          onPressed: () async {
                            try {
                              await Provider.of<SurpriseService>(context,
                                      listen: false)
                                  .unlockSurprise(_surprise!.id);
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Surprise unlocked!')),
                              );
                              _loadSurpriseDetails(); // Refresh details
                            } catch (e) {
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error unlocking surprise: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.lock_open),
                          label: const Text('Unlock Surprise'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                          ),
                        ),
                    ],
                  ),
                ),
    );
  }
} 