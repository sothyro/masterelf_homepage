import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'firebase_options.dart';
import 'utils/app_asset_preloader.dart';
import 'utils/hero_video_preloader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase before app starts so AuthProvider and other Firebase services work.
  await _initFirebase();
  runApp(const HeroVideoBootstrap());
}

/// Initialize Firebase only when options are configured (not placeholder).
Future<void> _initFirebase() async {
  try {
    final options = DefaultFirebaseOptions.currentPlatform;
    if (options.projectId.isEmpty || options.projectId == 'your-project-id') {
      return;
    }
    await Firebase.initializeApp(options: options);
  } catch (_) {
    // Run without Firebase (demo mode for booking)
  }
}

/// Shows a loading screen with 0–100% progress until assets (video, images, fonts) are ready, then the full app.
class HeroVideoBootstrap extends StatefulWidget {
  const HeroVideoBootstrap({super.key});

  @override
  State<HeroVideoBootstrap> createState() => _HeroVideoBootstrapState();
}

class _HeroVideoBootstrapState extends State<HeroVideoBootstrap> {
  double _progress = 0.0;
  bool _ready = false;
  bool _transitioning = false;

  @override
  void initState() {
    super.initState();
    AppAssetPreloader.preloadAll((progress) {
      if (!mounted) return;
      setState(() => _progress = progress);
      if (progress >= 1.0 && !_ready) {
        _ready = true;
        // Show immediately at 100% — no artificial delay (best practice: minimize time to content)
        if (mounted) {
          setState(() => _transitioning = true);
        }
      }
    }).catchError((_) {
      if (mounted) {
        setState(() {
          _progress = 1.0;
          _ready = true;
          _transitioning = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_transitioning) {
      return HeroLoadingScreen(progress: _progress);
    }
    return const MasterElfApp();
  }
}
