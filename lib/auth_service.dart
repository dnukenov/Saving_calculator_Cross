import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'models/preferences.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get currentUser => _auth.currentUser;
  Stream<User?> get user => _auth.authStateChanges();
  bool get isAuthenticated => _auth.currentUser != null;
  String? get userEmail => _auth.currentUser?.email;

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _loadUserPreferences(result.user!.uid);
      notifyListeners();
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? "Login failed");
    }
  }

  Future<User?> registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _saveDefaultPreferences(result.user!.uid);
      notifyListeners();
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? "Registration failed");
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential result = await _auth.signInWithCredential(credential);
      await _loadUserPreferences(result.user!.uid);
      notifyListeners();
      return result.user;
    } catch (e) {
      throw AuthException("Google sign in failed");
    }
  }

  Future<void> logout() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      notifyListeners();
    } catch (e) {
      throw AuthException("Logout failed");
    }
  }

  Future<void> _saveDefaultPreferences(String userId) async {
    final prefs = Preferences(
      themeMode: ThemeMode.system,
      locale: Locale('kk'),
    );

    final box = Hive.box<Preferences>('preferences');
    await box.put('prefs', prefs);

    try {
      await _firestore.collection('userPreferences').doc(userId).set({
        'themeMode': prefs.themeMode.toString(),
        'locale': prefs.locale.languageCode,
      });
    } catch (e) {
      // Оффлайн - сохраняем только локально
    }
  }

  Future<void> _loadUserPreferences(String userId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('userPreferences').doc(userId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        final box = Hive.box<Preferences>('preferences');
        await box.put(
          'prefs',
          Preferences(
            themeMode: _parseThemeMode(data['themeMode']),
            locale: Locale(data['locale'] ?? 'kk'),
          ),
        );
      }
    } catch (e) {
      // Оффлайн - используем локальные настройки
    }
  }

  ThemeMode _parseThemeMode(String? mode) {
    switch (mode) {
      case 'ThemeMode.light':
        return ThemeMode.light;
      case 'ThemeMode.dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}