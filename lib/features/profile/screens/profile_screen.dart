import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../core/localization/locale_provider.dart';
import '../../../core/localization/language_constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeProvider = Provider.of<LocaleProvider>(context);

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
          ListTile(
            title: Text(l10n.language),
            subtitle: Text(LanguageConstants.getLanguageName(localeProvider.locale.languageCode)),
            leading: const Icon(Icons.language),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLanguagePicker(context, localeProvider),
          ),
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