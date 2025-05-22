import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'settings_service.dart';

class ConnectivityService {
  final SettingsService _settings;

  ConnectivityService(this._settings);

  Future<void> init() async {
    Connectivity().onConnectivityChanged.listen((result) {
      _settings.setOfflineStatus(result == ConnectivityResult.none);
    });

    final initialStatus = await Connectivity().checkConnectivity();
    _settings.setOfflineStatus(initialStatus == ConnectivityResult.none);
  }
}