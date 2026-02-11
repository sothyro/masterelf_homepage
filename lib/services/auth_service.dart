import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

/// Authentication service for admin/staff login.
abstract class AuthService {
  User? get currentUser;
  Stream<User?> get authStateChanges;
  Future<void> signInWithEmailAndPassword(String email, String password);
  Future<void> signOut();
}

class FirebaseAuthService implements AuthService {
  FirebaseAuthService() : _auth = _getAuth();

  static FirebaseAuth _getAuth() {
    if (Firebase.apps.isEmpty) {
      throw StateError(
        'Firebase has not been initialized. Ensure Firebase.initializeApp() '
        'is called before the app starts (e.g. in main()).',
      );
    }
    return FirebaseAuth.instance;
  }

  final FirebaseAuth _auth;

  @override
  User? get currentUser => _auth.currentUser;

  @override
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }
}

/// No-op auth when Firebase is not configured. Use when [Firebase.apps.isEmpty].
class NoOpAuthService implements AuthService {
  @override
  User? get currentUser => null;

  @override
  Stream<User?> get authStateChanges => Stream.value(null);

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    throw StateError('Firebase Auth is not configured.');
  }

  @override
  Future<void> signOut() async {}
}
