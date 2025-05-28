import 'package:flutter/material.dart';
import 'package:fitquest/screens/home/home_screen.dart';
import 'package:fitquest/screens/profile/profile_screen.dart';
import 'package:fitquest/screens/settings/settings_screen.dart';
import 'package:fitquest/screens/social/social_screen.dart';
import 'package:fitquest/screens/surprise/ar_discovery_screen.dart';
import 'package:fitquest/screens/surprise/surprise_discovery_screen.dart';
import 'package:fitquest/screens/surprise/surprise_details_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String social = '/social';
  static const String arDiscovery = '/ar-discovery';
  static const String surpriseDiscovery = '/surprise-discovery';
  static const String surpriseDetails = '/surprise-details';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case social:
        return MaterialPageRoute(builder: (_) => const SocialScreen());
      case arDiscovery:
        return MaterialPageRoute(builder: (_) => const ARDiscoveryScreen());
      case surpriseDiscovery:
        return MaterialPageRoute(builder: (_) => const SurpriseDiscoveryScreen());
      case surpriseDetails:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => SurpriseDetailsScreen(surpriseId: args['id'] as String),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
} 