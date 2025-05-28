import 'package:flutter/material.dart';

class MoodTrackerCard extends StatefulWidget {
  const MoodTrackerCard({super.key});

  @override
  State<MoodTrackerCard> createState() => _MoodTrackerCardState();
}

class _MoodTrackerCardState extends State<MoodTrackerCard> {
  double _moodValue = 0.5;
  final TextEditingController _noteController = TextEditingController();
  bool _isExpanded = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _updateMood(double value) {
    setState(() => _moodValue = value);
  }

  void _saveMood() {
    // TODO: Save mood and note to database
    setState(() => _isExpanded = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Mood saved successfully!'),
      ),
    );
  }

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
                  'How are you feeling?',
                  style: theme.textTheme.titleLarge,
                ),
                IconButton(
                  icon: Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                  ),
                  onPressed: () {
                    setState(() => _isExpanded = !_isExpanded);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Mood Slider
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _MoodEmoji(emoji: '😢', isSelected: _moodValue < 0.2),
                    _MoodEmoji(emoji: '😕', isSelected: _moodValue >= 0.2 && _moodValue < 0.4),
                    _MoodEmoji(emoji: '😐', isSelected: _moodValue >= 0.4 && _moodValue < 0.6),
                    _MoodEmoji(emoji: '🙂', isSelected: _moodValue >= 0.6 && _moodValue < 0.8),
                    _MoodEmoji(emoji: '😄', isSelected: _moodValue >= 0.8),
                  ],
                ),
                const SizedBox(height: 8),
                SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: theme.colorScheme.primary,
                    inactiveTrackColor: theme.colorScheme.surfaceVariant,
                    thumbColor: theme.colorScheme.primary,
                    overlayColor: theme.colorScheme.primary.withOpacity(0.1),
                    valueIndicatorColor: theme.colorScheme.primary,
                    valueIndicatorTextStyle: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                  child: Slider(
                    value: _moodValue,
                    onChanged: _updateMood,
                    divisions: 4,
                    label: _getMoodLabel(_moodValue),
                  ),
                ),
              ],
            ),
            
            // Expandable Note Section
            if (_isExpanded) ...[
              const SizedBox(height: 16),
              TextField(
                controller: _noteController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Add a note about your mood...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveMood,
                  child: const Text('Save Mood'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getMoodLabel(double value) {
    if (value < 0.2) return 'Very Low';
    if (value < 0.4) return 'Low';
    if (value < 0.6) return 'Neutral';
    if (value < 0.8) return 'Good';
    return 'Great';
  }
}

class _MoodEmoji extends StatelessWidget {
  final String emoji;
  final bool isSelected;

  const _MoodEmoji({
    required this.emoji,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isSelected
            ? Theme.of(context).colorScheme.primaryContainer
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        emoji,
        style: const TextStyle(fontSize: 24),
      ),
    );
  }
} 