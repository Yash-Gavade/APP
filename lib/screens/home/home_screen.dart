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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const HomeContent(),
    const WorkoutPlanScreen(),
    const MapChallengeScreen(),
    const TrackerScreen(),
    const ProfileScreen(),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.fitness_center_outlined),
            selectedIcon: Icon(Icons.fitness_center),
            label: 'Workouts',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: 'Challenges',
          ),
          NavigationDestination(
            icon: Icon(Icons.track_changes_outlined),
            selectedIcon: Icon(Icons.track_changes),
            label: 'Track',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ChatbotScreen()),
          );
        },
        child: const Icon(Icons.chat),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context).userProfile;
    
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            floating: true,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back,',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  user?.name ?? 'Fitness Warrior',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                  // TODO: Show notifications
                },
              ),
            ],
          ),
          
          // Content
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Daily Progress
                const DailyProgressCard(),
                const SizedBox(height: 16),
                
                // Next Workout
                const NextWorkoutCard(),
                const SizedBox(height: 16),
                
                // Mood Tracker
                const MoodTrackerCard(),
                const SizedBox(height: 16),
                
                // Recent Achievements
                const AchievementCard(),
                const SizedBox(height: 16),
                
                // Quick Actions
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quick Actions',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _QuickActionButton(
                              icon: Icons.fitness_center,
                              label: 'Start Workout',
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/workout-plan',
                                );
                              },
                            ),
                            _QuickActionButton(
                              icon: Icons.map,
                              label: 'Find Challenge',
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/map-challenge',
                                );
                              },
                            ),
                            _QuickActionButton(
                              icon: Icons.chat,
                              label: 'Chat with AI',
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/chatbot',
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 32,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
} 