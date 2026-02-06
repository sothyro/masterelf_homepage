import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../config/app_content.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../utils/breakpoints.dart';
import '../../utils/launcher_utils.dart';

/// Apps & Store page: Master Elf System, Period 9 Mobile App, Talisman Store.
class AppsScreen extends StatelessWidget {
  const AppsScreen({super.key});

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
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.appsPageTitle,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: AppColors.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 48),
                    _SpotlightSection(
                      icon: LucideIcons.cpu,
                      title: l10n.masterElfSystemSpotlightTitle,
                      description: l10n.masterElfSystemSpotlightDesc,
                      child: FilledButton.icon(
                        onPressed: () => launchUrlExternal(AppContent.baziSystemUrl),
                        icon: const Icon(LucideIcons.externalLink, size: 20),
                        label: Text(l10n.openMasterElfSystem),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          foregroundColor: AppColors.onAccent,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    _SpotlightSection(
                      icon: LucideIcons.smartphone,
                      title: l10n.period9SpotlightTitle,
                      description: l10n.period9SpotlightDesc,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _StoreButton(
                            label: l10n.downloadOnAppStore,
                            icon: Icons.apple,
                            url: AppContent.period9AppStoreUrl,
                          ),
                          const SizedBox(width: 16),
                          _StoreButton(
                            label: l10n.getItOnGooglePlay,
                            icon: Icons.play_circle_filled,
                            url: AppContent.period9PlayStoreUrl,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      l10n.talismanStoreSpotlightTitle,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.talismanStoreSpotlightDesc,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.onSurfaceVariantDark,
                            height: 1.5,
                          ),
                    ),
                    const SizedBox(height: 24),
                    _TalismanGrid(),
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

/// App spotlight style: icon, title, description, and CTA area.
class _SpotlightSection extends StatelessWidget {
  const _SpotlightSection({
    required this.icon,
    required this.title,
    required this.description,
    required this.child,
  });

  final IconData icon;
  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isNarrow = Breakpoints.isMobile(width);

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevatedDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderDark, width: 1),
        boxShadow: AppShadows.card,
      ),
      child: isNarrow
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildIcon(context),
                const SizedBox(height: 20),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.onSurfaceVariantDark,
                        height: 1.5,
                      ),
                ),
                const SizedBox(height: 24),
                child,
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildIcon(context),
                const SizedBox(width: 28),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppColors.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        description,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.onSurfaceVariantDark,
                              height: 1.5,
                            ),
                      ),
                      const SizedBox(height: 24),
                      child,
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight.withValues(alpha: 0.4)),
      ),
      child: Icon(icon, size: 48, color: AppColors.accent),
    );
  }
}

class _StoreButton extends StatelessWidget {
  const _StoreButton({
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

    return OutlinedButton.icon(
      onPressed: enabled
          ? () => launchUrlExternal(url!)
          : null,
      icon: Icon(icon, size: 22, color: enabled ? AppColors.accent : AppColors.onSurfaceVariantDark),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.onPrimary,
        side: BorderSide(color: enabled ? AppColors.accent : AppColors.borderDark),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
    );
  }
}

/// 3×3 grid of vertical rectangular placeholder boxes for Talisman Store (2 columns on mobile).
class _TalismanGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final crossAxisCount = Breakpoints.isMobile(width) ? 2 : 3;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1 / 1.4,
      children: List.generate(
        9,
        (i) => Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceElevatedDark,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderDark, width: 1),
            boxShadow: AppShadows.card,
          ),
          child: Center(
            child: Text(
              'Talisman ${i + 1}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceVariantDark,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
