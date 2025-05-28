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

class _SurpriseDetailsScreenState extends State<SurpriseDetailsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  SurpriseModel? _surprise;
  bool _isLoading = true;

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
    super.dispose();
  }

  Future<void> _loadSurprise() async {
    try {
      final surpriseService = Provider.of<SurpriseService>(context, listen: false);
      // TODO: Implement getSurprise method in SurpriseService
      // _surprise = await surpriseService.getSurprise(widget.surpriseId);
      
      if (_surprise != null) {
        _controller.repeat();
      }
    } catch (e) {
      print('Error loading surprise: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
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
          child: Text('The surprise details are no longer available.'),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(_surprise!.title),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Background Image or Gradient
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary,
                        ],
                      ),
                    ),
                  ),
                  
                  // Animation
                  Center(
                    child: Lottie.asset(
                      'assets/animations/surprise_claimed.json',
                      controller: _controller,
                      width: 150,
                      height: 150,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Content
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Type Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    _surprise!.type.toString().split('.').last.toUpperCase(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Description
                Text(
                  _surprise!.description,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
                
                // Rewards Section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rewards',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        
                        // XP Reward
                        ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondaryContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.star,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          title: const Text('Experience Points'),
                          subtitle: Text('+${_surprise!.xpReward} XP'),
                        ),
                        
                        // Other Rewards
                        if (_surprise!.rewards.isNotEmpty) ...[
                          const Divider(),
                          ..._surprise!.rewards.entries.map((entry) {
                            return ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  _getRewardIcon(entry.key),
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              title: Text(_formatRewardKey(entry.key)),
                              subtitle: Text(_formatRewardValue(entry.value)),
                            );
                          }),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Requirements Section
                if (_surprise!.requiredBadges?.isNotEmpty ?? false) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Requirements',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _surprise!.requiredBadges!.map((badge) {
                              return Chip(
                                label: Text(badge),
                                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                                labelStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                
                // Metadata Section
                if (_surprise!.metadata?.isNotEmpty ?? false) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Details',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          ..._surprise!.metadata!.entries.map((entry) {
                            return ListTile(
                              title: Text(_formatMetadataKey(entry.key)),
                              subtitle: Text(_formatMetadataValue(entry.value)),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ],
              ]),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getRewardIcon(String key) {
    switch (key.toLowerCase()) {
      case 'badge':
        return Icons.emoji_events;
      case 'item':
        return Icons.card_giftcard;
      case 'feature':
        return Icons.lock_open;
      case 'challenge':
        return Icons.fitness_center;
      default:
        return Icons.star;
    }
  }

  String _formatRewardKey(String key) {
    return key.split('_').map((word) {
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  String _formatRewardValue(dynamic value) {
    if (value is String) return value;
    if (value is num) return value.toString();
    if (value is bool) return value ? 'Unlocked' : 'Locked';
    if (value is List) return value.join(', ');
    if (value is Map) return value.toString();
    return value.toString();
  }

  String _formatMetadataKey(String key) {
    return key.split('_').map((word) {
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  String _formatMetadataValue(dynamic value) {
    if (value is DateTime) {
      return '${value.day}/${value.month}/${value.year}';
    }
    return value.toString();
  }
} 