// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get login => 'Войти';

  @override
  String get register => 'Зарегистрироваться';

  @override
  String get email => 'Электронная почта';

  @override
  String get enterEmail => 'Пожалуйста, введите адрес электронной почты';

  @override
  String get password => 'Пароль';

  @override
  String get enterPassword => 'Пожалуйста, введите пароль';

  @override
  String get passwordTooShort => 'Пароль должен быть не менее 6 символов';

  @override
  String get confirmPassword => 'Подтвердите пароль';

  @override
  String get passwordsDontMatch => 'Пароли не совпадают';

  @override
  String get alreadyHaveAccount => 'Уже есть аккаунт? Войти';

  @override
  String get registrationFailed => 'Регистрация не удалась';

  @override
  String get aboutApp => 'О приложении';

  @override
  String get aboutDescription => 'Это приложение-калькулятор сбережений, которое помогает отслеживать и управлять вашими ежемесячными целями накоплений.';

  @override
  String get profile => 'Профиль';

  @override
  String get loggedInAs => 'Вы вошли как';

  @override
  String get currentTheme => 'Текущая тема';

  @override
  String get currentLanguage => 'Текущий язык';

  @override
  String get logout => 'Выйти';

  @override
  String get settings => 'Настройки';

  @override
  String get chooseTheme => 'Выберите тему';

  @override
  String get darkMode => 'Темная тема';

  @override
  String get chooseLanguage => 'Выберите язык';

  @override
  String get home => 'Главная';

  @override
  String get addItem => 'Добавить элемент';

  @override
  String get appTitle => 'Моё приложение';

  @override
  String get about => 'О приложении';

  @override
  String get noItems => 'Нет элементов';

  @override
  String get month => 'Месяц';

  @override
  String get editTitle => 'Редактировать название';

  @override
  String get editSavedMoney => 'Редактировать сбережения';

  @override
  String get save => 'Сохранить';

  @override
  String get newMonth => 'Новый месяц';

  @override
  String get add => 'Добавить';

  @override
  String get savedMoney => 'Сбережено';
}
