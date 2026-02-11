import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../services/auth_service.dart';

/// Provides authentication state and actions for the app.
class AuthProvider extends ChangeNotifier {
  AuthProvider({AuthService? authService}) : _authService = authService ?? _createAuthService() {
    _subscription = _authService.authStateChanges.listen((_) {
      notifyListeners();
    });
  }

  static AuthService _createAuthService() {
    if (Firebase.apps.isEmpty) {
      return NoOpAuthService();
    }
    return FirebaseAuthService();
  }

  final AuthService _authService;
  StreamSubscription<User?>? _subscription;

  User? get currentUser => _authService.currentUser;
  bool get isLoggedIn => currentUser != null;
  String? get userEmail => currentUser?.email;

  Future<void> signIn(String email, String password) async {
    await _authService.signInWithEmailAndPassword(email, password);
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
