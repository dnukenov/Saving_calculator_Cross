import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'preferences.g.dart';

@HiveType(typeId: 0)
class Preferences {
  @HiveField(0)
  final ThemeMode themeMode;
  
  @HiveField(1)
  final Locale locale;

  Preferences({
    this.themeMode = ThemeMode.system,
    this.locale = const Locale('kk'),
  });
}