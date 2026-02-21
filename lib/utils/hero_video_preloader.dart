import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Status messages shown while loading so users see activity even when progress is slow.
const List<String> _loadingMessages = [
  'Loading your experience…',
  'Optimising view…',
  'Almost there…',
  'Just a moment…',
];

/// Full-screen loading view shown until critical assets (logo, hero image) are ready.
/// Hero video loads in the hero section after the app is visible.
class HeroLoadingScreen extends StatefulWidget {
  const HeroLoadingScreen({super.key, this.progress = 0.0});

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
      theme: AppTheme.dark().copyWith(
        scaffoldBackgroundColor: AppColors.backgroundDark,
        textTheme: textThemeForLocale('en'),
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
