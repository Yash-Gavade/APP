import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitquest/services/surprise_service.dart';
import 'package:lottie/lottie.dart';

class SurpriseDiscoveryScreen extends StatefulWidget {
  const SurpriseDiscoveryScreen({super.key});

  @override
  State<SurpriseDiscoveryScreen> createState() => _SurpriseDiscoveryScreenState();
}

class _SurpriseDiscoveryScreenState extends State<SurpriseDiscoveryScreen> {
  bool _isLoading = false;
  List<Map<String, dynamic>> _nearbySurprises = [];

  @override
  void initState() {
    super.initState();
    _loadNearbySurprises();
  }

  Future<void> _loadNearbySurprises() async {
    setState(() => _isLoading = true);
    try {
      final surprises = await Provider.of<SurpriseService>(context, listen: false)
          .getNearbySurprises();
      setState(() {
        _nearbySurprises = surprises;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading surprises: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover Surprises'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadNearbySurprises,
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
                      Lottie.asset(
                        'assets/animations/no_surprises.json',
                        height: 200,
                        repeat: true,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No surprises nearby',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, '/ar-discovery');
                        },
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Try AR Discovery'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _nearbySurprises.length,
                  itemBuilder: (context, index) {
                    final surprise = _nearbySurprises[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(surprise['icon'] ?? ''),
                          child: surprise['icon'] == null
                              ? const Icon(Icons.card_giftcard)
                              : null,
                        ),
                        title: Text(surprise['title'] ?? 'Unknown Surprise'),
                        subtitle: Text(surprise['description'] ?? ''),
                        trailing: surprise['isUnlocked'] == true
                            ? const Icon(Icons.check_circle, color: Colors.green)
                            : ElevatedButton(
                                onPressed: () => _unlockSurprise(surprise['id']),
                                child: const Text('Unlock'),
                              ),
                        onTap: () {
                          // Show surprise details
                          Navigator.pushNamed(
                            context,
                            '/surprise-details',
                            arguments: surprise,
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }

  Future<void> _unlockSurprise(String surpriseId) async {
    try {
      await Provider.of<SurpriseService>(context, listen: false)
          .unlockSurprise(surpriseId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Surprise unlocked!')),
      );
      _loadNearbySurprises(); // Refresh the list
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error unlocking surprise: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
} 