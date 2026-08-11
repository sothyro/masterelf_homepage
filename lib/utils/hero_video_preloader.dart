import 'package:flutter/material.dart';

import '../app_bootstrap.dart';
import '../config/app_content.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';

/// Full-screen loading view shown until critical assets, fonts, and the
/// painted eager homepage (Hero + Events) are ready. Hero video loads in
/// parallel and does not gate dismiss.
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

  String _messageForProgress(double progress, AppLocalizations l10n) {
    if (progress < 0.20) return l10n.loadingExperience;
    // 0.20–0.75: eager images + fonts; 0.75+: homepage paint settle (video parallel).
    if (progress < 0.75) return l10n.loadingOptimising;
    return l10n.loadingAlmostThere;
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: localeNotifier,
      builder: (context, _) {
        final locale = localeNotifier.locale;
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.dark().copyWith(
            scaffoldBackgroundColor: AppColors.backgroundDark,
            textTheme: textThemeForLocale(locale.languageCode),
          ),
          home: Builder(
            builder: (context) {
              final l10n = AppLocalizations.of(context)!;
              return _LoadingContent(
                displayProgress: _displayProgress,
                pulseValue: _pulseController.value,
                message: _messageForProgress(_displayProgress, l10n),
              );
            },
          ),
        );
      },
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
    return Scaffold(
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
              Image.asset(
                AppContent.assetLogo,
                width: 140,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 32),
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
    );
  }
}
