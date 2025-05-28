import 'package:flutter/material.dart';

class AchievementCard extends StatelessWidget {
  const AchievementCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Achievements',
                  style: theme.textTheme.titleLarge,
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Navigate to achievements screen
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Achievement List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                return _AchievementItem(
                  icon: _getAchievementIcon(index),
                  title: _getAchievementTitle(index),
                  description: _getAchievementDescription(index),
                  date: _getAchievementDate(index),
                  xp: _getAchievementXP(index),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  IconData _getAchievementIcon(int index) {
    switch (index) {
      case 0:
        return Icons.local_fire_department;
      case 1:
        return Icons.fitness_center;
      case 2:
        return Icons.emoji_events;
      default:
        return Icons.star;
    }
  }

  String _getAchievementTitle(int index) {
    switch (index) {
      case 0:
        return '7 Day Streak';
      case 1:
        return 'Workout Warrior';
      case 2:
        return 'Early Bird';
      default:
        return 'Achievement';
    }
  }

  String _getAchievementDescription(int index) {
    switch (index) {
      case 0:
        return 'Completed workouts for 7 days in a row';
      case 1:
        return 'Completed 10 workouts this month';
      case 2:
        return 'Completed a workout before 8 AM';
      default:
        return 'Achievement description';
    }
  }

  String _getAchievementDate(int index) {
    switch (index) {
      case 0:
        return '2 hours ago';
      case 1:
        return 'Yesterday';
      case 2:
        return '3 days ago';
      default:
        return 'Recently';
    }
  }

  int _getAchievementXP(int index) {
    switch (index) {
      case 0:
        return 500;
      case 1:
        return 1000;
      case 2:
        return 250;
      default:
        return 100;
    }
  }
}

class _AchievementItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String date;
  final int xp;

  const _AchievementItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.date,
    required this.xp,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          // Achievement Icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: theme.colorScheme.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          
          // Achievement Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          
          // XP Badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.star,
                  size: 16,
                  color: theme.colorScheme.secondary,
                ),
                const SizedBox(width: 4),
                Text(
                  '+$xp XP',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSecondaryContainer,
                    fontWeight: FontWeight.bold,
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