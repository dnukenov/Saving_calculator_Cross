import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_service.dart';
import 'settings_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final settings = Provider.of<SettingsService>(context);
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(local.profile)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('${local.loggedInAs}: ${auth.userEmail ?? 'Guest'}'),
            const SizedBox(height: 16),
            Text('${local.currentTheme}: ${settings.themeMode.name}'),
            Text('${local.currentLanguage}: ${settings.locale.languageCode}'),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                auth.logout();
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Text(local.logout),
            ),
          ],
        ),
      ),
    );
  }
}
