import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../config/app_content.dart';
import '../theme/app_theme.dart';

/// Preloads the hero video at app startup so the hero section can use it when mounted.
/// [preload] returns a Future that completes when the video is ready (or fails).
class HeroVideoPreloader {
  HeroVideoPreloader._();

  static VideoPlayerController? _preloaded;
  static Completer<void>? _readyCompleter;

  /// Start loading the hero video. Returns a Future that completes when ready.
  /// Safe to call once; subsequent calls return the same future.
  static Future<void> preload() {
    if (_preloaded != null) return Future.value();
    if (_readyCompleter != null) return _readyCompleter!.future;
    _readyCompleter = Completer<void>();
    final controller = VideoPlayerController.asset(
      AppContent.assetHeroVideo,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
    controller.initialize().then((_) {
      if (_preloaded != null) {
        controller.dispose();
        _readyCompleter?.complete();
        return;
      }
      controller.setLooping(true);
      controller.setVolume(0);
      _preloaded = controller;
      _readyCompleter?.complete();
    }).catchError((_) {
      controller.dispose();
      _readyCompleter?.complete();
    });
    return _readyCompleter!.future;
  }

  /// Returns the preloaded controller if ready and clears the stored reference.
  static VideoPlayerController? takePreloaded() {
    final c = _preloaded;
    _preloaded = null;
    return c;
  }
}

/// Full-screen loading view that matches the hero gradient so the transition is seamless.
/// [progress] should go from 0.0 to 1.0; the circular bar and percentage reflect this.
class HeroLoadingScreen extends StatelessWidget {
  const HeroLoadingScreen({super.key, this.progress = 0.0});

  /// Loading progress from 0.0 to 1.0. When 1.0, the bar is full and the app will switch to content.
  final double progress;

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0.0, 1.0);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppColors.backgroundDark,
      ),
      home: Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.backgroundDark,
                AppColors.surfaceDark,
                AppColors.primary.withValues(alpha: 0.95),
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 48,
                  height: 48,
                  child: CircularProgressIndicator(
                    value: clampedProgress > 0 && clampedProgress <= 1
                        ? clampedProgress
                        : null,
                    strokeWidth: 2,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
                    backgroundColor: AppColors.accent.withValues(alpha: 0.2),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '${(clampedProgress * 100).round()}%',
                  style: TextStyle(
                    color: AppColors.accent.withValues(alpha: 0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
