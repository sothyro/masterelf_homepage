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

/// Status messages shown while loading so users see activity even when progress is slow.
const List<String> _loadingMessages = [
  'Loading your experience…',
  'Preparing content…',
  'Almost there…',
  'Just a moment…',
];

/// Full-screen loading view that matches the hero gradient so the transition is seamless.
/// [progress] should go from 0.0 to 1.0. The bar animates smoothly and status messages
/// rotate so the screen feels interactive even when progress is slow (e.g. during font load).
class HeroLoadingScreen extends StatefulWidget {
  const HeroLoadingScreen({super.key, this.progress = 0.0});

  /// Loading progress from 0.0 to 1.0. When 1.0, the bar is full and the app will switch to content.
  final double progress;

  @override
  State<HeroLoadingScreen> createState() => _HeroLoadingScreenState();
}

class _HeroLoadingScreenState extends State<HeroLoadingScreen>
    with TickerProviderStateMixin {
  double _displayProgress = 0.0;
  late AnimationController _progressController;
  late AnimationController _pulseController;
  int _messageIndex = 0;

  @override
  void initState() {
    super.initState();
    _displayProgress = widget.progress.clamp(0.0, 1.0);
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..addListener(() {
        if (mounted) setState(() {});
      })..repeat(reverse: true);
    _scheduleNextMessage();
  }

  void _scheduleNextMessage() {
    Future<void>.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _messageIndex = (_messageIndex + 1) % _loadingMessages.length);
      _scheduleNextMessage();
    });
  }

  @override
  void didUpdateWidget(HeroLoadingScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _animateTo(widget.progress.clamp(0.0, 1.0));
    }
  }

  void _animateTo(double target) {
    final start = _displayProgress;
    if ((target - start).abs() < 0.002) {
      setState(() => _displayProgress = target);
      return;
    }
    final animation = Tween<double>(begin: start, end: target).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeOut),
    );
    void listener() {
      if (mounted) setState(() => _displayProgress = animation.value);
    }
    animation.addListener(listener);
    _progressController.forward(from: 0).whenComplete(() {
      animation.removeListener(listener);
      if (mounted) setState(() => _displayProgress = target);
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _LoadingContent(
      displayProgress: _displayProgress,
      pulseValue: _pulseController.value,
      message: _loadingMessages[_messageIndex % _loadingMessages.length],
    );
  }
}

/// Inner content: displays animated progress, pulse, and rotating message.
class _LoadingContent extends StatelessWidget {
  const _LoadingContent({
    required this.displayProgress,
    required this.pulseValue,
    required this.message,
  });

  final double displayProgress;
  final double pulseValue;
  final String message;

  @override
  Widget build(BuildContext context) {
    final pulseScale = 1.0 + (0.04 * (0.5 - (pulseValue - 0.5).abs()));
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
                Transform.scale(
                  scale: pulseScale,
                  child: SizedBox(
                    width: 52,
                    height: 52,
                    child: CircularProgressIndicator(
                      value: displayProgress > 0 && displayProgress <= 1
                          ? displayProgress
                          : null,
                      strokeWidth: 2.5,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
                      backgroundColor: AppColors.accent.withValues(alpha: 0.2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '${(displayProgress * 100).round()}%',
                  style: TextStyle(
                    color: AppColors.accent.withValues(alpha: 0.95),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    message,
                    key: ValueKey<String>(message),
                    style: TextStyle(
                      color: AppColors.accent.withValues(alpha: 0.7),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
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
