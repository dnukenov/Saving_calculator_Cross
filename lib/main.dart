import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'auth_service.dart';
import 'settings_service.dart';
import 'connectivity_service.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'profile_page.dart';
import 'settings_page.dart';
import 'home_page.dart';
import 'about_page.dart';
import 'models/preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'firebase_options.dart'; // Убедитесь, что этот файл создан через flutterfire configure

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация Firebase с обработкой ошибок
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
  } catch (e) {
    print('Error initializing Firebase: $e');
    // Fallback инициализация
    await Firebase.initializeApp();
  }

  // Инициализация Hive
  await Hive.initFlutter();
  Hive.registerAdapter(PreferencesAdapter());
  await Hive.openBox<Preferences>('preferences');
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(create: (_) => AuthService()),
        ChangeNotifierProvider<SettingsService>(create: (_) => SettingsService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsService>(context, listen: false);
    
    // Инициализация ConnectivityService
    ConnectivityService(settings).init();

    return ValueListenableBuilder<Box<Preferences>>(
      valueListenable: Hive.box<Preferences>('preferences').listenable(),
      builder: (context, box, _) {
        final prefs = box.get('prefs', defaultValue: Preferences());
        
        // Применяем настройки после завершения построения виджета
        WidgetsBinding.instance.addPostFrameCallback((_) {
          settings.applyPreferences(prefs!);
        });

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'My App',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: settings.themeMode,
          locale: settings.locale,
          supportedLocales: const [
            Locale('en', ''),
            Locale('ru', ''),
            Locale('kk', ''),
          ],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            if (locale == null) return const Locale('kk');
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale.languageCode) {
                return supportedLocale;
              }
            }
            return const Locale('kk');
          },
          initialRoute: '/',
          routes: {
            '/': (context) => const HomePage(),
            '/login': (context) => const LoginPage(),
            '/register': (context) => const RegisterPage(),
            '/profile': (context) => const ProfilePage(),
            '/settings': (context) => const SettingsPage(),
            '/about': (context) => const AboutPage(),
          },
        );
      },
    );
  }
}