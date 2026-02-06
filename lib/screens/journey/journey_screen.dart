import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../config/app_content.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../utils/breakpoints.dart';

/// Master Elf's Journey page: hero, story, Period 9, and The Rise of the Phoenix.
class JourneyScreen extends StatelessWidget {
  const JourneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.sizeOf(context).width;
    final isNarrow = Breakpoints.isMobile(width);

    return Container(
      width: double.infinity,
      color: AppColors.backgroundDark,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 80),
          const _PageHero(),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isNarrow ? 20 : 32,
              vertical: 48,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.journeyPageHeadline,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: AppColors.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 28),
                    _Paragraph(text: l10n.journeyStory1),
                    const SizedBox(height: 20),
                    _Paragraph(text: l10n.journeyStory2),
                    const SizedBox(height: 20),
                    _Paragraph(text: l10n.journeyStory3),
                    const SizedBox(height: 36),
                    Text(
                      l10n.journeyPeriod9Title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 12),
                    _Paragraph(text: l10n.journeyPeriod9Body),
                    const SizedBox(height: 36),
                    Text(
                      l10n.journeyPhoenixTitle,
                      style: GoogleFonts.condiment(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.accent,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _Paragraph(text: l10n.journeyPhoenixBody),
                    const SizedBox(height: 48),
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

class _PageHero extends StatelessWidget {
  const _PageHero();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = width < 600 ? 320.0 : (width < 900 ? 420.0 : 520.0);

    return SizedBox(
      width: double.infinity,
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            AppContent.assetHeroBackground,
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  AppColors.backgroundDark.withValues(alpha: 0.35),
                  AppColors.backgroundDark.withValues(alpha: 0.15),
                  AppColors.backgroundDark.withValues(alpha: 0.08),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Paragraph extends StatelessWidget {
  const _Paragraph({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.onSurfaceVariantDark,
            height: 1.6,
          ),
    );
  }
}
