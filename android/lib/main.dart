import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fitquest/services/auth_service.dart';
import 'package:fitquest/services/settings_service.dart';
import 'package:fitquest/utils/routes.dart';
import 'package:fitquest/l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  final prefs = await SharedPreferences.getInstance();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthService(),
        ),
        ChangeNotifierProvider(
          create: (_) => SettingsService(prefs),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsService>(context);

    return MaterialApp(
      title: 'FitQuest',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: settings.theme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(settings.language),
      onGenerateRoute: AppRoutes.onGenerateRoute,
      initialRoute: AppRoutes.splash,
    );
  }
}

class AchievementModel {
  final String id;
  final String title;
  final String description;
  final String icon;
  final int xpReward;
  final String activityType; // e.g., 'running', 'walking'
  final int requirement;
  final int progress;
  final bool isUnlocked;
  final bool isSecret;
  final DateTime? unlockedAt;

  AchievementModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.xpReward,
    required this.activityType,
    required this.requirement,
    required this.progress,
    this.isUnlocked = false,
    this.isSecret = false,
    this.unlockedAt,
  });

  factory AchievementModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AchievementModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      icon: data['icon'] ?? '',
      xpReward: data['xpReward'] ?? 0,
      activityType: data['activityType'] ?? '',
      requirement: data['requirement'] ?? 0,
      progress: data['progress'] ?? 0,
      isUnlocked: data['isUnlocked'] ?? false,
      isSecret: data['isSecret'] ?? false,
      unlockedAt: data['unlockedAt'] != null
          ? (data['unlockedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'icon': icon,
      'xpReward': xpReward,
      'activityType': activityType,
      'requirement': requirement,
      'progress': progress,
      'isUnlocked': isUnlocked,
      'isSecret': isSecret,
      'unlockedAt': unlockedAt != null ? Timestamp.fromDate(unlockedAt!) : null,
    };
  }
}

class BadgeModel {
  final String id;
  final String title;
  final String description;
  final String icon;
  final String activityType; // e.g., 'running'
  final String achievementId;
  final int level;
  final DateTime? earnedAt;

  BadgeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.activityType,
    required this.achievementId,
    required this.level,
    this.earnedAt,
  });

  factory BadgeModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BadgeModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      icon: data['icon'] ?? '',
      activityType: data['activityType'] ?? '',
      achievementId: data['achievementId'] ?? '',
      level: data['level'] ?? 1,
      earnedAt: data['earnedAt'] != null
          ? (data['earnedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'icon': icon,
      'activityType': activityType,
      'achievementId': achievementId,
      'level': level,
      'earnedAt': earnedAt != null ? Timestamp.fromDate(earnedAt!) : null,
    };
  }
}

class UserModel {
  final int points;
  final List<String> unlockedAchievements;
  final List<String> unlockedBadges;
  // ...existing code...

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      // ...existing fields...
      points: data['points'] ?? 0,
      unlockedAchievements: List<String>.from(data['unlockedAchievements'] ?? []),
      unlockedBadges: List<String>.from(data['unlockedBadges'] ?? []),
      // ...existing code...
    );
  }

  Map<String, dynamic> toMap() {
    return {
      // ...existing fields...
      'points': points,
      'unlockedAchievements': unlockedAchievements,
      'unlockedBadges': unlockedBadges,
      // ...existing code...
    };
  }
}

class AIService {
  // Suggest next achievement
  String suggestNextAchievement(UserModel user, List<AchievementModel> allAchievements) {
    // Analyze user progress and recommend
    return "Try to complete your 10K steps badge today!";
  }

  // Pop up with surprise hints
  void maybeShowSurprise(BuildContext context) {
    // Example: show a dialog at random or based on logic
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('🎉 Surprise!'),
        content: Text('Hey! There\'s a surprise in the park today. Go check it out!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Awesome!'),
          ),
        ],
      ),
    );
  }
}

class AchievementsScreen extends StatefulWidget {
  @override
  _AchievementsScreenState createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  final List<String> activities = ['Running', 'Walking', 'Cycling', 'Swimming', 'Yoga', 'Strength'];
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    // Fetch achievements for selected activity
    // final achievements = ...;

    return Scaffold(
      appBar: AppBar(title: Text('Achievements')),
      body: Column(
        children: [
          // Tabs
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: activities.length,
              itemBuilder: (context, i) => GestureDetector(
                onTap: () => setState(() => selectedTab = i),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: selectedTab == i ? Colors.blue : Colors.transparent,
                        width: 3,
                      ),
                    ),
                  ),
                  child: Text(
                    activities[i],
                    style: TextStyle(
                      fontWeight: selectedTab == i ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Achievements Grid
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.8,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: 9, // achievements.length,
              itemBuilder: (context, i) {
                // final achievement = achievements[i];
                final isUnlocked = i % 2 == 0; // Example
                return GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => BadgeDetailDialog(
                        // achievement: achievement,
                        isUnlocked: isUnlocked,
                      ),
                    );
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: isUnlocked ? Colors.white : Colors.grey[300],
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        if (isUnlocked)
                          BoxShadow(
                            color: Colors.amber.withOpacity(0.3),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                      ],
                    ),
                    child: Center(
                      child: isUnlocked
                          ? Lottie.asset('assets/animations/unlock.json')
                          : Icon(Icons.lock_outline, size: 48, color: Colors.grey),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BadgeDetailDialog extends StatelessWidget {
  final bool isUnlocked;
  // final AchievementModel achievement;
  const BadgeDetailDialog({super.key, required this.isUnlocked});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isUnlocked)
              Lottie.asset('assets/animations/confetti.json', repeat: false)
            else
              Icon(Icons.lock_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              isUnlocked ? "Badge Unlocked!" : "Locked",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 8),
            Text(
              isUnlocked
                  ? "Congratulations! You've unlocked this badge."
                  : "Complete the requirement to unlock.",
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close"),
            ),
          ],
        ),
      ),
    );
  }
}

class ProgressRing extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  const ProgressRing({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircularProgressIndicator(
          value: progress,
          strokeWidth: 8,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
        ),
        Text('${(progress * 100).toInt()}%'),
      ],
    );
  }
}

class ShopScreen extends StatelessWidget {
  final List<ShopItem> items = [
    ShopItem('2X Boost', 100, 'assets/icons/badges/boost.png'),
    ShopItem('AR Surprise', 200, 'assets/icons/badges/surprise.png'),
    ShopItem('Theme Pack', 150, 'assets/icons/badges/theme.png'),
    // Add more items...
  ];

  @override
  Widget build(BuildContext context) {
    // You'd get the user's points from your UserModel/provider
    int userPoints = 500; // Example

    return Scaffold(
      appBar: AppBar(title: Text('Shop')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Your Points: $userPoints', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, i) {
                final item = items[i];
                return Card(
                  child: ListTile(
                    leading: Image.asset(item.iconPath, width: 40, height: 40),
                    title: Text(item.name),
                    subtitle: Text('${item.price} points'),
                    trailing: ElevatedButton(
                      onPressed: userPoints >= item.price ? () {
                        // Deduct points, grant item, show animation, etc.
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Purchased ${item.name}!'))
                        );
                      } : null,
                      child: Text('Buy'),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ShopItem {
  final String name;
  final int price;
  final String iconPath;
  ShopItem(this.name, this.price, this.iconPath);
} 