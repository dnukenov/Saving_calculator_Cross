import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'settings_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsService>(context);
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(local.settings)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(local.chooseTheme),
            SwitchListTile(
              title: Text(local.darkMode),
              value: settings.themeMode == ThemeMode.dark,
              onChanged: (val) {
                settings.setThemeMode(
                  val ? ThemeMode.dark : ThemeMode.light,
                );
              },
            ),
            const SizedBox(height: 16),
            Text(local.chooseLanguage),
            DropdownButton<String>(
              value: settings.locale.languageCode,
              onChanged: (val) {
                if (val != null) {
                  settings.setLocale(Locale(val));
                }
              },
              items: const [
                DropdownMenuItem(value: 'kk', child: Text('Қазақ')),
                DropdownMenuItem(value: 'ru', child: Text('Русский')),
                DropdownMenuItem(value: 'en', child: Text('English')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}