import 'package:flutter/material.dart';
import 'package:fitventure/screens/home/home_screen.dart';
import 'package:fitventure/screens/surprise/surprise_discovery_screen.dart';
import 'package:fitventure/screens/social/social_screen.dart';
import 'package:fitventure/screens/profile/profile_screen.dart';
import 'package:fitventure/widgets/main_navigation.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late final List<Widget> _screens;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _screens = const [
      HomeScreen(),
      SurpriseDiscoveryScreen(),
      SocialScreen(),
      ProfileScreen(),
    ];
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNavTap(int index) {
    setState(() => _currentIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _screens,
        onPageChanged: (index) {
          setState(() => _currentIndex = index);
        },
      ),
      bottomNavigationBar: MainNavigation(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
} 