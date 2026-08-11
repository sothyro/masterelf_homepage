import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/app_theme.dart';
import '../utils/breakpoints.dart';

/// Cinematic bottom-anchored hero shared by Events, Field Work, and similar pages.
class EditorialPageHero extends StatelessWidget {
  const EditorialPageHero({
    super.key,
    required this.backgroundAsset,
    required this.label,
    required this.headline,
    required this.body,
    required this.primaryCta,
    required this.onPrimary,
    this.secondaryCta,
    this.onSecondary,
    this.primaryIcon = LucideIcons.calendarCheck,
    this.secondaryIcon = LucideIcons.chevronDown,
    this.isDesktop = false,
    this.imageAlignmentMobile = const Alignment(0.0, -0.15),
    this.imageAlignmentDesktop = const Alignment(0.1, -0.1),
    this.backgroundCacheWidth,
  });

  final String backgroundAsset;
  final int? backgroundCacheWidth;
  final String label;
  final String headline;
  final String body;
  final String primaryCta;
  final String? secondaryCta;
  final VoidCallback onPrimary;
  final VoidCallback? onSecondary;
  final IconData primaryIcon;
  final IconData secondaryIcon;
  final bool isDesktop;
  final Alignment imageAlignmentMobile;
  final Alignment imageAlignmentDesktop;

  @override
  Widget build(BuildContext context) {
    final isMobile = Breakpoints.isMobile(MediaQuery.sizeOf(context).width);
    final heroHeight = isDesktop ? 680.0 : (isMobile ? 480.0 : 520.0);
    final imageAlignment = isMobile ? imageAlignmentMobile : imageAlignmentDesktop;

    return SizedBox(
      height: heroHeight,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Image.asset(
              backgroundAsset,
              fit: BoxFit.cover,
              alignment: imageAlignment,
              cacheWidth: backgroundCacheWidth,
              errorBuilder: (_, __, ___) => const SizedBox.expand(),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.backgroundDark.withValues(alpha: 0.55),
                    Colors.transparent,
                    AppColors.backgroundDark.withValues(alpha: 0.88),
                    AppColors.backgroundDark.withValues(alpha: 0.97),
                  ],
                  stops: const [0.0, 0.32, 0.72, 1.0],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                isMobile ? 20 : 48,
                0,
                isMobile ? 20 : 48,
                isMobile ? 40 : 56,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: isMobile ? 520 : 640),
                child: EditorialPageHeroCopy(
                  label: label,
                  headline: headline,
                  body: body,
                  primaryCta: primaryCta,
                  secondaryCta: secondaryCta,
                  onPrimary: onPrimary,
                  onSecondary: onSecondary,
                  primaryIcon: primaryIcon,
                  secondaryIcon: secondaryIcon,
                  isMobile: isMobile,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EditorialPageHeroCopy extends StatelessWidget {
  const EditorialPageHeroCopy({
    super.key,
    required this.label,
    required this.headline,
    required this.body,
    required this.primaryCta,
    required this.onPrimary,
    this.secondaryCta,
    this.onSecondary,
    this.primaryIcon = LucideIcons.calendarCheck,
    this.secondaryIcon = LucideIcons.chevronDown,
    required this.isMobile,
  });

  final String label;
  final String headline;
  final String body;
  final String primaryCta;
  final String? secondaryCta;
  final VoidCallback onPrimary;
  final VoidCallback? onSecondary;
  final IconData primaryIcon;
  final IconData secondaryIcon;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final titleStyle = textStyleWithLocale(
      context,
      isHeading: false,
      fontSize: isMobile ? 13 : 14,
      fontWeight: FontWeight.w600,
      color: AppColors.onPrimary.withValues(alpha: 0.9),
    ).copyWith(letterSpacing: 2.8, height: 1.2);

    final headlineStyle = highlightStyleForLocale(
      context,
      fontSize: isMobile ? 30 : 42,
      fontWeight: FontWeight.bold,
      color: AppColors.accent,
      height: 1.1,
    );

    final bodyStyle = textStyleWithLocale(
      context,
      isHeading: false,
      fontSize: isMobile ? 15 : 17,
      fontWeight: FontWeight.w400,
      color: AppColors.onPrimary.withValues(alpha: 0.88),
    ).copyWith(height: 1.45);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        EditorialHeroLabel(text: label, style: titleStyle),
        SizedBox(height: isMobile ? 14 : 18),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            headline,
            textAlign: TextAlign.center,
            maxLines: 1,
            softWrap: false,
            style: headlineStyle,
          ),
        ),
        SizedBox(height: isMobile ? 10 : 12),
        Text(
          body,
          textAlign: TextAlign.center,
          style: bodyStyle,
        ),
        if (primaryCta.isNotEmpty) ...[
          SizedBox(height: isMobile ? 24 : 28),
          EditorialHeroActions(
            primaryCta: primaryCta,
            secondaryCta: secondaryCta,
            onPrimary: onPrimary,
            onSecondary: onSecondary,
            primaryIcon: primaryIcon,
            secondaryIcon: secondaryIcon,
            isMobile: isMobile,
          ),
        ],
      ],
    );
  }
}

class EditorialHeroLabel extends StatelessWidget {
  const EditorialHeroLabel({super.key, required this.text, required this.style});

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 1.5,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                AppColors.accent.withValues(alpha: 0.9),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(text.toUpperCase(), style: style),
        ),
        Container(
          width: 28,
          height: 1.5,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.accent.withValues(alpha: 0.9),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class EditorialHeroActions extends StatelessWidget {
  const EditorialHeroActions({
    super.key,
    required this.primaryCta,
    required this.onPrimary,
    this.secondaryCta,
    this.onSecondary,
    this.primaryIcon = LucideIcons.calendarCheck,
    this.secondaryIcon = LucideIcons.chevronDown,
    required this.isMobile,
  });

  final String primaryCta;
  final String? secondaryCta;
  final VoidCallback onPrimary;
  final VoidCallback? onSecondary;
  final IconData primaryIcon;
  final IconData secondaryIcon;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final primary = FilledButton.icon(
      onPressed: onPrimary,
      icon: Icon(primaryIcon, size: isMobile ? 17 : 18),
      label: Text(
        primaryCta,
        style: TextStyle(
          fontSize: isMobile ? 14 : 15,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.onAccent,
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 22 : 26,
          vertical: isMobile ? 13 : 14,
        ),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
    );

    final secondary = secondaryCta != null && onSecondary != null
        ? TextButton.icon(
            onPressed: onSecondary,
            icon: Icon(secondaryIcon, size: isMobile ? 16 : 17),
            label: Text(
              secondaryCta!,
              style: TextStyle(
                fontSize: isMobile ? 14 : 15,
                fontWeight: FontWeight.w500,
                color: AppColors.onPrimary.withValues(alpha: 0.92),
              ),
            ),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.onPrimary,
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 12 : 16,
                vertical: isMobile ? 12 : 14,
              ),
            ),
          )
        : null;

    if (secondary == null) {
      return isMobile
          ? SizedBox(width: double.infinity, child: primary)
          : primary;
    }

    if (isMobile) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: double.infinity, child: primary),
          const SizedBox(height: 6),
          secondary,
        ],
      );
    }

    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [primary, secondary],
    );
  }
}
