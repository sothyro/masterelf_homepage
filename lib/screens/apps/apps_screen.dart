import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../config/app_content.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../utils/breakpoints.dart';
import '../../utils/launcher_utils.dart';

/// Fragment IDs for Apps & Store sections (used in /apps#fragment).
const String _sectionMasterElf = 'master-elf';
const String _sectionPeriod9 = 'period9';
const String _sectionTalisman = 'talisman';

/// Apps & Store page: Master Elf System, Period 9 Mobile App, Talisman Store.
class AppsScreen extends StatefulWidget {
  const AppsScreen({super.key});

  @override
  State<AppsScreen> createState() => _AppsScreenState();
}

class _AppsScreenState extends State<AppsScreen> {
  final GlobalKey _keyMasterElf = GlobalKey();
  final GlobalKey _keyPeriod9 = GlobalKey();
  final GlobalKey _keyTalisman = GlobalKey();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollToSectionIfNeeded();
  }

  void _scrollToSectionIfNeeded() {
    final fragment = GoRouterState.of(context).uri.fragment;
    if (fragment.isEmpty) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final key = switch (fragment) {
        _sectionMasterElf => _keyMasterElf,
        _sectionPeriod9 => _keyPeriod9,
        _sectionTalisman => _keyTalisman,
        _ => null,
      };
      if (key?.currentContext != null) {
        Scrollable.ensureVisible(
          key!.currentContext!,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          alignment: 0.1,
        );
      }
    });
  }

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
          const _PageHero(assetPath: AppContent.assetHeroBackground),
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
                    _SectionAnchor(key: _keyMasterElf, child: _SpotlightSection(
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
                    )),
                    const SizedBox(height: 32),
                    Text(
                      l10n.appsFeatureShowcaseHeading,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 20),
                    _AppFeatureShowcase(
                      features: [
                        (AppContent.assetAppQiMen, l10n.appFeatureQiMen),
                        (AppContent.assetAppBaziLife, l10n.appFeatureBaziLife),
                        (AppContent.assetAppBaziReport, l10n.appFeatureBaziReport),
                        (AppContent.assetAppBaziAge, l10n.appFeatureBaziAge),
                        (AppContent.assetAppBaziStars, l10n.appFeatureBaziStars),
                        (AppContent.assetAppBaziKhmer, l10n.appFeatureBaziKhmer),
                        (AppContent.assetAppBaziPage2, l10n.appFeatureBaziChart),
                        (AppContent.assetAppDateSelection, l10n.appFeatureDateSelection),
                        (AppContent.assetAppMarriage, l10n.appFeatureMarriage),
                        (AppContent.assetAppBusinessPartner, l10n.appFeatureBusinessPartner),
                        (AppContent.assetAppAdvancedFeatures, l10n.appFeatureAdvancedFeatures),
                      ],
                    ),
                    const SizedBox(height: 40),
                    _SectionAnchor(key: _keyPeriod9, child: _SpotlightSection(
                      icon: LucideIcons.smartphone,
                      title: l10n.period9SpotlightTitle,
                      description: l10n.period9SpotlightDesc,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _Period9Screenshots(),
                          const SizedBox(height: 24),
                          Wrap(
                            spacing: 16,
                            runSpacing: 12,
                            children: [
                              _StoreButton(
                                label: l10n.downloadOnAppStore,
                                icon: Icons.apple,
                                url: AppContent.period9AppStoreUrl,
                              ),
                              _StoreButton(
                                label: l10n.getItOnGooglePlay,
                                icon: Icons.play_circle_filled,
                                url: AppContent.period9PlayStoreUrl,
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
                    const SizedBox(height: 40),
                    _SectionAnchor(key: _keyTalisman, child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
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
                      ],
                    )),
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

/// Wrapper that holds a [GlobalKey] for scroll-to-section.
class _SectionAnchor extends StatelessWidget {
  const _SectionAnchor({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}

class _PageHero extends StatelessWidget {
  const _PageHero({required this.assetPath});

  final String assetPath;

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
            assetPath,
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

/// Two Period 9 app screenshots in two rows with a divider between. Fills card width.
class _Period9Screenshots extends StatelessWidget {
  const _Period9Screenshots();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final imageHeight = (width * 0.5).clamp(280.0, 420.0);

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Period9Screenshot(asset: AppContent.assetPeriod9_1, height: imageHeight),
            const SizedBox(height: 20),
            Divider(height: 1, color: AppColors.borderDark, indent: 0, endIndent: 0),
            const SizedBox(height: 20),
            _Period9Screenshot(asset: AppContent.assetPeriod9_2, height: imageHeight),
          ],
        );
      },
    );
  }
}

class _Period9Screenshot extends StatelessWidget {
  const _Period9Screenshot({
    required this.asset,
    required this.height,
  });

  final String asset;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderDark, width: 1),
        boxShadow: AppShadows.card,
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        asset,
        fit: BoxFit.cover,
        width: double.infinity,
        height: height,
        errorBuilder: (_, __, ___) => SizedBox(
          width: double.infinity,
          height: height,
          child: Center(
            child: Icon(LucideIcons.smartphone, size: 40, color: AppColors.onSurfaceVariantDark.withValues(alpha: 0.5)),
          ),
        ),
      ),
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

/// Product showcase: grid of app feature screens with labels.
class _AppFeatureShowcase extends StatelessWidget {
  const _AppFeatureShowcase({required this.features});

  final List<(String asset, String title)> features;

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = 3;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 3 / 4,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final e = features[index];
        return _AppFeatureCard(asset: e.$1, title: e.$2);
      },
    );
  }
}

class _AppFeatureCard extends StatelessWidget {
  const _AppFeatureCard({required this.asset, required this.title});

  final String asset;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceElevatedDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderDark, width: 1),
        boxShadow: AppShadows.card,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image.asset(
              asset,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Center(
                child: Icon(LucideIcons.image, size: 48, color: AppColors.onSurfaceVariantDark.withValues(alpha: 0.5)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.onPrimary,
                    fontWeight: FontWeight.w500,
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
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
