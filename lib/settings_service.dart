import 'package:flutter/material.dart';
import 'models/preferences.dart';
import 'package:hive/hive.dart';

class SettingsService extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('kk');
  bool _isOffline = false;

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;
  bool get isOffline => _isOffline;

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    _savePreferences();
    notifyListeners();
  }

  void setLocale(Locale locale) {
    _locale = locale;
    _savePreferences();
    notifyListeners();
  }

  void setOfflineStatus(bool status) {
    _isOffline = status;
    notifyListeners();
  }

  void applyPreferences(Preferences prefs) {
    _themeMode = prefs.themeMode;
    _locale = prefs.locale;
  }

  Future<void> _savePreferences() async {
    final box = Hive.box<Preferences>('preferences');
    await box.put('prefs', Preferences(
      themeMode: _themeMode,
      locale: _locale,
    ));
  }
}