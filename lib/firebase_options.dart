// Firebase configuration for masterelf-website project.
// See: https://firebase.google.com/docs/web/setup

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return FirebaseOptions(
      apiKey: 'AIzaSyAALBe0wGLfoHrZ5u4kMr-Vm3tAzlCx8tw',
      appId: '1:339733051394:web:830a105f2279fa51accf1b',
      messagingSenderId: '339733051394',
      projectId: 'masterelf-website',
      authDomain: 'masterelf-website.firebaseapp.com',
      storageBucket: 'masterelf-website.firebasestorage.app',
      measurementId: 'G-9L9LJKBD2W',
    );
  }
}
