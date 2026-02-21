import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

import '../../../config/app_content.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/breakpoints.dart';
import '../../../widgets/profile_dialog.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  VideoPlayerController? _controller;
  bool _videoReady = false;
  bool _videoError = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _initVideo();
    });
  }

  Future<void> _initVideo() async {
    if (!mounted) return;
    try {
      // Use .asset() on all platforms; video_player_web resolves assets correctly.
      final VideoPlayerController c = VideoPlayerController.asset(
        AppContent.assetHeroVideo,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );

      await c.initialize();
      if (!mounted) {
        c.dispose();
        return;
      }
      c.setLooping(true);
      c.setVolume(0);
      await c.play();
      if (!mounted) {
        c.dispose();
        return;
      }
      setState(() {
        _controller = c;
        _videoReady = true;
      });
    } catch (_) {
      if (mounted) setState(() => _videoError = true);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = Breakpoints.isMobile(width);
    final minHeight = Breakpoints.isSmall(width)
        ? 480.0
        : (Breakpoints.isDesktop(width) ? 1000.0 : 500.0);
    final height = width > 0 ? (width * 9 / 16).clamp(minHeight, 1600.0) : 1000.0;
    final horizontalPadding = isMobile ? 16.0 : 32.0;
    final verticalPadding = isMobile ? 32.0 : 48.0;
    final topInset = isMobile ? (MediaQuery.paddingOf(context).top + 12 + 64) : 0.0;
    final contentAlignment = isMobile ? const Alignment(0, 0.55) : const Alignment(-0.38, 0.42);
    final crossAlign = isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start;
    final textAlign = isMobile ? TextAlign.center : TextAlign.left;

    return RepaintBoundary(
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 1) Gradient background
            Container(
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
            ),
            // 2) Static hero image while video loads (or on error)
            if (!_videoReady || _videoError)
              Positioned.fill(
                child: Image.asset(
                  AppContent.assetHeroBackground,
                  fit: BoxFit.cover,
                ),
              ),
            // 3) Video when ready
            if (_videoReady && _controller != null && _controller!.value.isInitialized)
              Positioned.fill(
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: SizedBox(
                    width: _controller!.value.size.width,
                    height: _controller!.value.size.height,
                    child: VideoPlayer(_controller!),
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
              padding: EdgeInsets.only(
                left: horizontalPadding,
                right: horizontalPadding,
                top: topInset + verticalPadding,
                bottom: verticalPadding,
              ),
              child: Align(
                alignment: contentAlignment,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: crossAlign,
                    children: [
                      Semantics(
                        header: true,
                        child: RichText(
                          textAlign: textAlign,
                          text: TextSpan(
                            style: (Theme.of(context).textTheme.headlineLarge ?? const TextStyle()).copyWith(
                              color: AppColors.onPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: width < 600 ? 20 : (width < 900 ? 26 : 32),
                              height: 0.88,
                            ),
                            children: [
                              TextSpan(text: l10n.heroHeadline1Prefix),
                              TextSpan(
                                text: l10n.heroHeadline1Highlight,
                                style: GoogleFonts.condiment(
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: width < 600 ? 38 : (width < 900 ? 46 : 56),
                                ),
                              ),
                              TextSpan(text: l10n.heroHeadline1Suffix),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        textAlign: textAlign,
                        text: TextSpan(
                          style: (Theme.of(context).textTheme.headlineLarge ?? const TextStyle()).copyWith(
                            color: AppColors.onPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: width < 600 ? 20 : (width < 900 ? 26 : 32),
                            height: 0.88,
                          ),
                          children: [
                            TextSpan(text: l10n.heroHeadline2Prefix),
                            TextSpan(
                              text: l10n.heroHeadline2Highlight,
                              style: GoogleFonts.condiment(
                                color: AppColors.accent,
                                fontWeight: FontWeight.bold,
                                fontSize: width < 600 ? 38 : (width < 900 ? 46 : 56),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      Text(
                        l10n.heroSubline,
                        textAlign: textAlign,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.onPrimary.withValues(alpha: 0.9),
                          height: 0.9,
                          fontSize: width < 600 ? 13 : (width < 900 ? 15 : 17),
                        ),
                      ),
                      const SizedBox(height: 36),
                      Wrap(
                        alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
                        spacing: 20,
                        runSpacing: 14,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: AppShadows.accentButton,
                            ),
                            child: FilledButton(
                              onPressed: () => context.push('/consultations'),
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.accent,
                                foregroundColor: AppColors.onAccent,
                                padding: EdgeInsets.symmetric(
                                  horizontal: width < 600 ? 24 : 32,
                                  vertical: width < 600 ? 14 : 18,
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                l10n.bookConsultation,
                                style: TextStyle(
                                  fontSize: width < 600 ? 15 : 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          OutlinedButton(
                            onPressed: () => showProfileDialog(context),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.onPrimary,
                              side: const BorderSide(color: AppColors.onPrimary),
                              padding: EdgeInsets.symmetric(
                                horizontal: width < 600 ? 24 : 32,
                                vertical: width < 600 ? 14 : 18,
                              ),
                            ),
                            child: Text(
                              l10n.heroMasterElfCaption,
                              style: TextStyle(
                                fontSize: width < 600 ? 15 : 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
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
      ),
    );
  }
}
