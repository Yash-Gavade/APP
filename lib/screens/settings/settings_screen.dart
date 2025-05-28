import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitquest/services/settings_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsService>(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: ListView(
        children: [
          // Language Settings
          ListTile(
            title: Text(l10n.language),
            trailing: DropdownButton<String>(
              value: settings.language,
              items: [
                DropdownMenuItem(
                  value: 'en',
                  child: Text(l10n.english),
                ),
                DropdownMenuItem(
                  value: 'de',
                  child: Text(l10n.german),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  settings.updateLanguage(value);
                }
              },
            ),
          ),
          const Divider(),

          // Theme Settings
          ListTile(
            title: Text(l10n.theme),
            trailing: DropdownButton<ThemeMode>(
              value: settings.theme,
              items: [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text(l10n.systemTheme),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text(l10n.lightTheme),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text(l10n.darkTheme),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  settings.updateTheme(value);
                }
              },
            ),
          ),
          const Divider(),

          // Units Settings
          ListTile(
            title: Text(l10n.units),
            trailing: DropdownButton<String>(
              value: settings.units,
              items: [
                DropdownMenuItem(
                  value: 'metric',
                  child: Text(l10n.metric),
                ),
                DropdownMenuItem(
                  value: 'imperial',
                  child: Text(l10n.imperial),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  settings.updateUnits(value);
                }
              },
            ),
          ),
          const Divider(),

          // Notification Settings
          SwitchListTile(
            title: Text(l10n.notifications),
            value: settings.notifications,
            onChanged: (value) => settings.updateNotifications(value),
          ),
          const Divider(),

          // Sound Settings
          SwitchListTile(
            title: Text(l10n.sound),
            value: settings.sound,
            onChanged: (value) => settings.updateSound(value),
          ),
          const Divider(),

          // Vibration Settings
          SwitchListTile(
            title: Text(l10n.vibration),
            value: settings.vibration,
            onChanged: (value) => settings.updateVibration(value),
          ),
          const Divider(),

          // Reset Settings
          ListTile(
            title: Text(l10n.resetSettings),
            leading: const Icon(Icons.restore),
            onTap: () => _showResetConfirmationDialog(context),
          ),
          const Divider(),

          // About Section
          ListTile(
            title: Text(l10n.about),
            leading: const Icon(Icons.info),
            onTap: () => _showAboutDialog(context),
          ),
          ListTile(
            title: Text(l10n.privacyPolicy),
            leading: const Icon(Icons.privacy_tip),
            onTap: () {
              // TODO: Navigate to privacy policy
            },
          ),
          ListTile(
            title: Text(l10n.termsOfService),
            leading: const Icon(Icons.description),
            onTap: () {
              // TODO: Navigate to terms of service
            },
          ),
          ListTile(
            title: Text(l10n.contactUs),
            leading: const Icon(Icons.contact_support),
            onTap: () {
              // TODO: Navigate to contact form
            },
          ),
          ListTile(
            title: Text(l10n.feedback),
            leading: const Icon(Icons.feedback),
            onTap: () {
              // TODO: Navigate to feedback form
            },
          ),
          ListTile(
            title: Text(l10n.help),
            leading: const Icon(Icons.help),
            onTap: () {
              // TODO: Navigate to help center
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showResetConfirmationDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final settings = Provider.of<SettingsService>(context, listen: false);

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.resetSettings),
        content: Text(l10n.confirmDeleteAccount),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.no),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.yes),
          ),
        ],
      ),
    );

    if (result == true) {
      await settings.resetSettings();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.settingsSaved)),
        );
      }
    }
  }

  void _showAboutDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.about),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('FitQuest ${l10n.version} 1.0.0'),
            const SizedBox(height: 16),
            Text(
              'FitQuest is your personal fitness companion that makes working out fun and engaging. '
              'Track your progress, complete challenges, and discover surprises as you achieve your fitness goals.',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }
} 