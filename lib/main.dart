import 'package:flutter/material.dart';

import 'app.dart';
import 'utils/hero_video_preloader.dart';

void main() {
  runApp(const HeroVideoBootstrap());
}

/// Shows a loading screen until the hero video is ready, then the full app so the video appears with the site.
class HeroVideoBootstrap extends StatefulWidget {
  const HeroVideoBootstrap({super.key});

  @override
  State<HeroVideoBootstrap> createState() => _HeroVideoBootstrapState();
}

class _HeroVideoBootstrapState extends State<HeroVideoBootstrap> {
  bool _videoReady = false;

  @override
  void initState() {
    super.initState();
    HeroVideoPreloader.preload().then((_) {
      if (mounted) setState(() => _videoReady = true);
    }).catchError((_) {
      if (mounted) setState(() => _videoReady = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_videoReady) return const HeroLoadingScreen();
    return const MasterElfApp();
  }
}
