// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PreferencesAdapter extends TypeAdapter<Preferences> {
  @override
  final int typeId = 0;

  @override
  Preferences read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Preferences(
      locale: Locale(fields[0] as String),
      themeMode: _parseThemeMode(fields[1] as String),
    );
  }

  @override
  void write(BinaryWriter writer, Preferences obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.locale.languageCode)
      ..writeByte(1)
      ..write(obj.themeMode.toString());
  }
}

// Вспомогательная функция для преобразования строки в ThemeMode
ThemeMode _parseThemeMode(String mode) {
  switch (mode) {
    case 'ThemeMode.light':
      return ThemeMode.light;
    case 'ThemeMode.dark':
      return ThemeMode.dark;
    case 'ThemeMode.system':
    default:
      return ThemeMode.system;
  }
}
