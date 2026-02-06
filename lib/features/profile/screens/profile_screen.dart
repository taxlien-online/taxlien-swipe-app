import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:taxlien_swipe_app/features/auth/auth_provider.dart';
import 'package:taxlien_swipe_app/features/auth/auth_state.dart';
import 'package:taxlien_swipe_app/l10n/app_localizations.dart';
import '../../../core/localization/locale_provider.dart';
import '../../../core/localization/language_constants.dart';
import '../../tutorial/services/tutorial_service.dart';
import '../../tutorial/services/achievement_service.dart';
import '../../tutorial/models/achievement.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _hintsDisabled = false;
  bool _hintsLoaded = false;
  bool _hintsLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hintsLoaded && !_hintsLoading) {
      _hintsLoading = true;
      _loadHintsDisabled();
    }
  }

  Future<void> _loadHintsDisabled() async {
    final service = context.read<TutorialService>();
    final disabled = await service.areHintsDisabled();
    if (mounted) {
      setState(() {
        _hintsDisabled = disabled;
        _hintsLoaded = true;
        _hintsLoading = false;
      });
    }
  }

  Future<void> _toggleHints(bool disabled) async {
    final service = context.read<TutorialService>();
    if (disabled) {
      await service.disableAllHints();
    } else {
      await service.enableHints();
    }
    if (mounted) setState(() => _hintsDisabled = disabled);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeProvider = Provider.of<LocaleProvider>(context);
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profileTitle),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          const Center(
            child: CircleAvatar(radius: 40, child: Icon(Icons.person)),
          ),
          const SizedBox(height: 20),
          _AccountSection(auth: auth),
          const Divider(),
          ListTile(
            title: Text(l10n.language),
            subtitle: Text(LanguageConstants.getLanguageName(localeProvider.locale.languageCode)),
            leading: const Icon(Icons.language),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLanguagePicker(context, localeProvider),
          ),
          if (_hintsLoaded)
            SwitchListTile(
              title: Text(_hintsDisabled ? l10n.showHints : l10n.disableAllHints),
              subtitle: Text(_hintsDisabled ? 'Hints are off' : 'Tap to turn off all hints'),
              value: _hintsDisabled,
              onChanged: _toggleHints,
            ),
          const Divider(),
          const _AchievementsSection(),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              l10n.roles,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const ListTile(
            title: Text('Expert Profile Switcher'),
            subtitle: Text('Roles: Khun Pho, Denis, Anton, Vasilisa'),
          ),
        ],
      ),
    );
  }

  void _showLanguagePicker(BuildContext context, LocaleProvider provider) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: LanguageConstants.supportedLocales.map((locale) {
              return ListTile(
                title: Text(LanguageConstants.getLanguageName(locale.languageCode)),
                onTap: () {
                  provider.setLocale(locale);
                  Navigator.pop(context);
                },
                selected: provider.locale.languageCode == locale.languageCode,
                trailing: provider.locale.languageCode == locale.languageCode
                    ? const Icon(Icons.check, color: Colors.green)
                    : null,
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class _AccountSection extends StatelessWidget {
  const _AccountSection({required this.auth});

  final AuthProvider auth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Account',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          if (!auth.isSignedIn) ...[
            Text(
              'Not signed in',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: () => context.push('/onboarding/oauth?returnTo=profile'),
              icon: const Icon(Icons.login, size: 20),
              label: const Text('Sign In'),
            ),
          ] else ...[
            if (auth.state?.displayName != null)
              Text(
                auth.state!.displayName!,
                style: theme.textTheme.titleSmall,
              ),
            if (auth.state?.email != null)
              Text(
                auth.state!.email!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => _signOut(context),
              icon: const Icon(Icons.logout, size: 20),
              label: const Text('Sign Out'),
            ),
            const SizedBox(height: 4),
            TextButton.icon(
              onPressed: () => _deleteAccount(context),
              icon: Icon(Icons.delete_outline, size: 20, color: theme.colorScheme.error),
              label: Text(
                'Delete Account',
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    await auth.signOut();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signed out')),
      );
    }
  }

  Future<void> _deleteAccount(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure? This will remove your account and cloud data. '
          'Local data may be kept.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final result = await auth.deleteAccount();
    if (!context.mounted) return;

    switch (result) {
      case AuthResult.success:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account deleted')),
        );
        break;
      case AuthResult.requiresRecentLogin:
        await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Sign in again'),
            content: const Text(
              'To delete your account, please sign out, then sign in again and try Delete Account.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        break;
      case AuthResult.cancelled:
      case AuthResult.error:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not delete account. Try again.')),
        );
        break;
    }
  }
}

class _AchievementsSection extends StatelessWidget {
  const _AchievementsSection();

  @override
  Widget build(BuildContext context) {
    final achievementService = context.read<AchievementService>();
    final theme = Theme.of(context);
    return FutureBuilder<Map<String, dynamic>>(
      future: Future.wait([
        achievementService.getAllAchievements(),
        achievementService.getUnlockedIds(),
      ]).then((r) => {'achievements': r[0], 'unlocked': r[1]}),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 2))),
          );
        }
        final achievements = snapshot.data!['achievements'] as List<Achievement>;
        final unlocked = (snapshot.data!['unlocked'] as List<String>).toSet();
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Achievements',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: achievements.map((a) {
                  final isUnlocked = unlocked.contains(a.id);
                  return Tooltip(
                    message: '${a.title}: ${a.description}',
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: isUnlocked
                            ? theme.colorScheme.primaryContainer.withValues(alpha: 0.6)
                            : theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            a.badgeEmoji,
                            style: TextStyle(
                              fontSize: 18,
                              color: isUnlocked ? null : theme.colorScheme.onSurface.withValues(alpha: 0.4),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            a.title,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: isUnlocked ? null : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}