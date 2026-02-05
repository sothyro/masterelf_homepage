import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

import '../../../config/app_content.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  VideoPlayerController? _videoController;
  bool _videoReady = false;

  @override
  void initState() {
    super.initState();
    // Defer video init until after first frame so the hero always paints immediately.
    WidgetsBinding.instance.addPostFrameCallback((_) => _initVideo());
  }

  Future<void> _initVideo() async {
    if (!mounted) return;
    try {
      final controller = VideoPlayerController.asset(
        AppContent.assetHeroVideo,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );
      await controller.initialize();
      if (!mounted) return;
      controller.setLooping(true);
      controller.setVolume(0);
      await controller.play();
      if (!mounted) return;
      setState(() {
        _videoController = controller;
        _videoReady = true;
      });
    } catch (_) {
      // Keep showing gradient + image; do not update state to avoid any risk.
      if (mounted) setState(() {});
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.sizeOf(context).width;
    // Responsive height: 16:9 of width so video fits; lower min on small screens so hero isn’t oversized
    final minHeight = width < 600 ? 320.0 : (width < 900 ? 500.0 : 1000.0);
    final height = width > 0 ? (width * 9 / 16).clamp(minHeight, 1600.0) : 1000.0;

    return SizedBox(
      width: double.infinity,
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 1) Solid gradient – always visible, no dependency on assets
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primary,
                  AppColors.primary.withValues(alpha: 0.9),
                ],
              ),
            ),
          ),
          // 2) Background image (with error handling so a bad asset doesn’t break the UI)
          if (!_videoReady)
            Positioned.fill(
              child: Image.asset(
                AppContent.assetHeroBackground,
                fit: BoxFit.cover,
                opacity: const AlwaysStoppedAnimation<double>(0.4),
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          // 3) Video layer – BoxFit.contain so full video is visible (no cropping)
          if (_videoReady && _videoController != null && _videoController!.value.isInitialized)
            Positioned.fill(
              child: FittedBox(
                fit: BoxFit.contain,
                child: SizedBox(
                  width: _videoController!.value.size.width,
                  height: _videoController!.value.size.height,
                  child: VideoPlayer(_videoController!),
                ),
              ),
            ),
          // 4) Overlay for text contrast
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primary.withValues(alpha: 0.45),
                  AppColors.primary.withValues(alpha: 0.7),
                ],
              ),
            ),
          ),
          // 5) Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Semantics(
                      header: true,
                      child: Text(
                        l10n.heroHeadline1,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: AppColors.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: AppColors.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                        children: [
                          TextSpan(text: l10n.heroHeadline2Prefix),
                          TextSpan(
                            text: l10n.heroHeadline2Highlight,
                            style: TextStyle(
                                color: AppColors.accent,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      l10n.heroSubline,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.onPrimary.withValues(alpha: 0.9),
                            height: 1.5,
                          ),
                    ),
                    const SizedBox(height: 32),
                    Wrap(
                      spacing: 16,
                      runSpacing: 12,
                      children: [
                        FilledButton(
                          onPressed: () => context.push('/appointments'),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            foregroundColor: AppColors.onAccent,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 28, vertical: 16),
                          ),
                          child: Text(l10n.bookConsultation),
                        ),
                        OutlinedButton(
                          onPressed: () => context.push('/about'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.onPrimary,
                            side: const BorderSide(color: AppColors.onPrimary),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 28, vertical: 16),
                          ),
                          child: Text(l10n.aboutMasterElf),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
