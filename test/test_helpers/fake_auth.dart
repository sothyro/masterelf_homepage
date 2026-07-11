import 'package:firebase_auth/firebase_auth.dart';

import 'package:masterelf_homepage/services/auth_service.dart';

/// Auth service that reports a logged-in user for dashboard widget tests.
class FakeLoggedInAuthService implements AuthService {
  @override
  User? get currentUser => _FakeUser();

  @override
  Stream<User?> get authStateChanges => Stream.value(currentUser);

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {}

  @override
  Future<void> signOut() async {}
}

class _FakeUser implements User {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}
