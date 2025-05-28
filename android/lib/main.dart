import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fitquest/services/auth_service.dart';
import 'package:fitquest/services/settings_service.dart';
import 'package:fitquest/utils/routes.dart';
import 'package:fitquest/l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';

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