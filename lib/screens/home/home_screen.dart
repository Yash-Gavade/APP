import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitquest/services/auth_service.dart';
import 'package:fitquest/screens/chatbot/chatbot_screen.dart';
import 'package:fitquest/screens/workout/workout_plan_screen.dart';
import 'package:fitquest/screens/tracker/tracker_screen.dart';
import 'package:fitquest/screens/profile/profile_screen.dart';
import 'package:fitquest/screens/map/map_challenge_screen.dart';
import 'package:fitquest/widgets/home/daily_progress_card.dart';
import 'package:fitquest/widgets/home/next_workout_card.dart';
import 'package:fitquest/widgets/home/mood_tracker_card.dart';
import 'package:fitquest/widgets/home/achievement_card.dart';
import 'package:fitquest/utils/routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const _HomeTab(),
    const ProfileScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home),
            label: l10n.home,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person),
            label: l10n.profile,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings),
            label: l10n.settings,
          ),
        ],
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final auth = Provider.of<AuthService>(context);
    final user = auth.userProfile;

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // TODO: Show notifications
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Welcome Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome, ${user.name}!',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Level ${user.level} • ${user.xp} XP',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Quick Actions
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              _ActionCard(
                title: l10n.workouts,
                icon: Icons.fitness_center,
                onTap: () {
                  // TODO: Navigate to workouts
                },
              ),
              _ActionCard(
                title: l10n.challenges,
                icon: Icons.emoji_events,
                onTap: () {
                  // TODO: Navigate to challenges
                },
              ),
              _ActionCard(
                title: l10n.progress,
                icon: Icons.trending_up,
                onTap: () {
                  // TODO: Navigate to progress
                },
              ),
              _ActionCard(
                title: l10n.stats,
                icon: Icons.bar_chart,
                onTap: () {
                  // TODO: Navigate to stats
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 