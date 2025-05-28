import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitquest/services/settings_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Theme'),
            subtitle: Text(settings.theme == ThemeMode.dark ? 'Dark' : 'Light'),
            leading: const Icon(Icons.palette),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Choose Theme'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: const Text('Light'),
                        onTap: () {
                          settings.setTheme(ThemeMode.light);
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: const Text('Dark'),
                        onTap: () {
                          settings.setTheme(ThemeMode.dark);
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: const Text('System'),
                        onTap: () {
                          settings.setTheme(ThemeMode.system);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Language'),
            subtitle: Text(settings.language == 'en' ? 'English' : 'Deutsch'),
            leading: const Icon(Icons.language),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Choose Language'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: const Text('English'),
                        onTap: () {
                          settings.setLanguage('en');
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: const Text('Deutsch'),
                        onTap: () {
                          settings.setLanguage('de');
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Notifications'),
            leading: const Icon(Icons.notifications),
            trailing: Switch(
              value: settings.notificationsEnabled,
              onChanged: (value) {
                settings.setNotificationsEnabled(value);
              },
            ),
          ),
          ListTile(
            title: const Text('Location Services'),
            leading: const Icon(Icons.location_on),
            trailing: Switch(
              value: settings.locationEnabled,
              onChanged: (value) {
                settings.setLocationEnabled(value);
              },
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('About'),
            leading: const Icon(Icons.info),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'FitQuest',
                applicationVersion: '1.0.0',
                applicationIcon: const FlutterLogo(size: 64),
                children: const [
                  Text('A fitness app that makes working out fun!'),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
} 