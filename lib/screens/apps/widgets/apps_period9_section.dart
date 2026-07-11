import 'package:flutter/material.dart';

import '../../../config/app_content.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/breakpoints.dart';
import '../../../utils/launcher_utils.dart';
import '../../../widgets/chinese_phone_showcase.dart';
import '../../home/widgets/field_work_chinese_design.dart';
import '../../store/widgets/description_with_highlight.dart';
import 'apps_fullscreen_image.dart';

/// Chapter III — Period 9 mobile app: open scroll-stage layout with fanned phones.
class AppsPeriod9Section extends StatelessWidget {
  const AppsPeriod9Section({super.key, required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isMobile = width < Breakpoints.mobile;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            ChineseScrollStageBand(label: l10n.period9MobileApp),
            const SizedBox(height: 28),
            ChinesePhoneShowcase(
              assets: [AppContent.assetPeriod9_1, AppContent.assetPeriod9_2],
              onScreenshotTap: (asset) => showAppsFullscreenImage(context, asset),
            ),
            SizedBox(height: isMobile ? 28 : 36),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: _Period9CopyBand(l10n: l10n, isMobile: isMobile),
              ),
            ),
            SizedBox(height: isMobile ? 24 : 32),
            FieldWorkChineseCtaPanel(
              isMobile: isMobile,
              child: _Period9DownloadPanel(l10n: l10n, isMobile: isMobile),
            ),
          ],
        );
      },
    );
  }
}

/// Centered copy block — title, tagline, description.
class _Period9CopyBand extends StatelessWidget {
  const _Period9CopyBand({required this.l10n, required this.isMobile});

  final AppLocalizations l10n;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12,
          runSpacing: 8,
          children: [
            Text(
              l10n.period9SpotlightTitle,
              textAlign: TextAlign.center,
              style: highlightStyleForLocale(
                context,
                fontSize: isMobile ? 26 : 32,
                fontWeight: FontWeight.bold,
                color: AppColors.accent,
              ),
            ),
            _FreeBadge(l10n: l10n),
          ],
        ),
        const SizedBox(height: 12),
        DescriptionWithHighlight(
          description: l10n.period9SpotlightTagline,
          highlightPhrase: l10n.period9SpotlightTaglineHighlight,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 14),
        Text(
          l10n.period9SpotlightDesc,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.onSurfaceVariantDark,
                height: 1.55,
              ),
        ),
        const SizedBox(height: 16),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 10,
          runSpacing: 8,
          children: const [
            _PlatformChip(icon: Icons.apple, label: 'iOS'),
            _PlatformChip(icon: Icons.android, label: 'Android'),
          ],
        ),
      ],
    );
  }
}

class _PlatformChip extends StatelessWidget {
  const _PlatformChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: FieldWorkChinesePalette.inkWash.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.accent.withValues(alpha: 0.85)),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.onSurfaceVariantDark,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _FreeBadge extends StatelessWidget {
  const _FreeBadge({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.55)),
      ),
      child: Text(
        l10n.period9PriceFree,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.accent,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
      ),
    );
  }
}

/// Download CTA panel — compact store badges, clear hierarchy.
class _Period9DownloadPanel extends StatelessWidget {
  const _Period9DownloadPanel({required this.l10n, required this.isMobile});

  final AppLocalizations l10n;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isMobile)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _StoreBadgeButton(
                label: l10n.downloadOnAppStore,
                icon: Icons.apple,
                url: AppContent.period9AppStoreUrl,
              ),
              const SizedBox(height: 12),
              _StoreBadgeButton(
                label: l10n.getItOnGooglePlay,
                icon: Icons.play_circle_filled,
                url: AppContent.period9PlayStoreUrl,
              ),
            ],
          )
        else
          Row(
            children: [
              Expanded(
                child: _StoreBadgeButton(
                  label: l10n.downloadOnAppStore,
                  icon: Icons.apple,
                  url: AppContent.period9AppStoreUrl,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _StoreBadgeButton(
                  label: l10n.getItOnGooglePlay,
                  icon: Icons.play_circle_filled,
                  url: AppContent.period9PlayStoreUrl,
                ),
              ),
            ],
          ),
        const SizedBox(height: 14),
        Text(
          l10n.period9PremiumLabel,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.onSurfaceVariantDark.withValues(alpha: 0.85),
                fontStyle: FontStyle.italic,
              ),
        ),
      ],
    );
  }
}

class _StoreBadgeButton extends StatelessWidget {
  const _StoreBadgeButton({
    required this.label,
    required this.icon,
    required this.url,
  });

  final String label;
  final IconData icon;
  final String? url;

  @override
  Widget build(BuildContext context) {
    final enabled = url != null && url!.isNotEmpty;

    return Material(
      color: enabled
          ? AppColors.accent
          : FieldWorkChinesePalette.inkWash.withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: enabled ? () => launchUrlExternal(url!) : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: enabled
                  ? AppColors.accentLight.withValues(alpha: 0.4)
                  : AppColors.accent.withValues(alpha: 0.35),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 26,
                color: enabled ? AppColors.onAccent : AppColors.accent.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: enabled
                        ? AppColors.onAccent
                        : AppColors.onSurfaceVariantDark.withValues(alpha: 0.7),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
