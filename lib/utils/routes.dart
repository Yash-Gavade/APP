import 'package:flutter/material.dart';
import 'package:fitquest/screens/splash_screen.dart';
import 'package:fitquest/screens/auth/login_screen.dart';
import 'package:fitquest/screens/auth/register_screen.dart';
import 'package:fitquest/screens/home/home_screen.dart';
import 'package:fitquest/screens/chatbot/chatbot_screen.dart';
import 'package:fitquest/screens/workout/workout_plan_screen.dart';
import 'package:fitquest/screens/tracker/tracker_screen.dart';
import 'package:fitquest/screens/profile/profile_screen.dart';
import 'package:fitquest/screens/map/map_challenge_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String chatbot = '/chatbot';
  static const String workoutPlan = '/workout-plan';
  static const String tracker = '/tracker';
  static const String profile = '/profile';
  static const String mapChallenge = '/map-challenge';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case chatbot:
        return MaterialPageRoute(builder: (_) => const ChatbotScreen());
      case workoutPlan:
        return MaterialPageRoute(builder: (_) => const WorkoutPlanScreen());
      case tracker:
        return MaterialPageRoute(builder: (_) => const TrackerScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case mapChallenge:
        return MaterialPageRoute(builder: (_) => const MapChallengeScreen());
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