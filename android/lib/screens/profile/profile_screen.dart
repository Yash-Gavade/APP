import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitquest/services/auth_service.dart';
import 'package:fitquest/services/settings_service.dart';
import 'package:fitquest/utils/routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final settings = Provider.of<SettingsService>(context);
    final l10n = AppLocalizations.of(context);
    final user = auth.userProfile;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profile),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.settings),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Header
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Profile Picture
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: user.photoUrl != null
                        ? NetworkImage(user.photoUrl!)
                        : null,
                    child: user.photoUrl == null
                        ? Text(
                            user.name[0].toUpperCase(),
                            style: Theme.of(context).textTheme.headlineMedium,
                          )
                        : null,
                  ),
                  const SizedBox(height: 16),
                  
                  // User Name
                  Text(
                    user.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  
                  // User Email
                  Text(
                    user.email,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Stats Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              _StatCard(
                title: l10n.level,
                value: user.level.toString(),
                icon: Icons.trending_up,
              ),
              _StatCard(
                title: l10n.xp,
                value: user.xp.toString(),
                icon: Icons.star,
              ),
              _StatCard(
                title: l10n.streak,
                value: '${user.streak} days',
                icon: Icons.local_fire_department,
              ),
              _StatCard(
                title: l10n.badges,
                value: '${user.badges?.length ?? 0}',
                icon: Icons.emoji_events,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Profile Actions
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: Text(l10n.editProfile),
                  onTap: () => _showEditProfileDialog(context),
                ),
                ListTile(
                  leading: const Icon(Icons.lock),
                  title: Text(l10n.changePassword),
                  onTap: () => _showChangePasswordDialog(context),
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: Text(l10n.logout),
                  onTap: () => _showLogoutConfirmationDialog(context),
                ),
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: Text(
                    l10n.deleteAccount,
                    style: const TextStyle(color: Colors.red),
                  ),
                  onTap: () => _showDeleteAccountConfirmationDialog(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showEditProfileDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final auth = Provider.of<AuthService>(context, listen: false);
    final user = auth.userProfile;
    final nameController = TextEditingController(text: user?.name);

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.editProfile),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: l10n.name,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(
              context,
              {'name': nameController.text},
            ),
            child: Text(l10n.save),
          ),
        ],
      ),
    );

    if (result != null) {
      try {
        await auth.updateProfile(name: result['name']);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.profileUpdated)),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.errorUpdatingProfile)),
          );
        }
      }
    }
  }

  Future<void> _showChangePasswordDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final auth = Provider.of<AuthService>(context, listen: false);
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.changePassword),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPasswordController,
              decoration: InputDecoration(
                labelText: l10n.currentPassword,
              ),
              obscureText: true,
            ),
            TextField(
              controller: newPasswordController,
              decoration: InputDecoration(
                labelText: l10n.newPassword,
              ),
              obscureText: true,
            ),
            TextField(
              controller: confirmPasswordController,
              decoration: InputDecoration(
                labelText: l10n.confirmPassword,
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              if (newPasswordController.text == confirmPasswordController.text) {
                Navigator.pop(context, true);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Passwords do not match'),
                  ),
                );
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );

    if (result == true) {
      try {
        await auth.changePassword(
          currentPassword: currentPasswordController.text,
          newPassword: newPasswordController.text,
        );
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.passwordChanged)),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.errorChangingPassword)),
          );
        }
      }
    }
  }

  Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final auth = Provider.of<AuthService>(context, listen: false);

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.logout),
        content: const Text('Are you sure you want to logout?'),
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
      await auth.signOut();
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    }
  }

  Future<void> _showDeleteAccountConfirmationDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final auth = Provider.of<AuthService>(context, listen: false);

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteAccount),
        content: Text(l10n.deleteAccountWarning),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.no),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: Text(l10n.yes),
          ),
        ],
      ),
    );

    if (result == true) {
      try {
        await auth.deleteAccount();
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        }
      }
    }
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
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
              value,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
} 