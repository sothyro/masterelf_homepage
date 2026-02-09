import 'package:flutter/material.dart';

import '../../config/app_content.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../utils/breakpoints.dart';
import '../../widgets/breadcrumb.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isMobile = Breakpoints.isMobile(MediaQuery.sizeOf(context).width);
    final paddingH = isMobile ? 16.0 : 24.0;
    return Container(
      width: double.infinity,
      color: AppColors.backgroundDark,
      padding: EdgeInsets.symmetric(vertical: isMobile ? 32 : 48, horizontal: paddingH),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Breadcrumb(items: [
              (label: l10n.home, route: '/'),
              (label: l10n.about, route: null),
            ]),
            const SizedBox(height: 16),
            Text(
              l10n.aboutBreadcrumb,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.onSurfaceVariantDark,
                  ),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                AppContent.assetAboutHero,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.aboutHeroHeadline,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 32),
            _Bullet(text: l10n.aboutBullet1),
            _Bullet(text: l10n.aboutBullet2),
            _Bullet(text: l10n.aboutBullet3),
            _Bullet(text: l10n.aboutBullet4),
            const SizedBox(height: 32),
            Text(
              l10n.featuredIn,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.onPrimary,
                  ),
            ),
            const SizedBox(height: 16),
            // Logo row: horizontal scroll on mobile so all logos are accessible
            isMobile
                ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        4,
                        (i) => Container(
                          width: 88,
                          height: 44,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceElevatedDark,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.borderDark, width: 1),
                            boxShadow: AppShadows.card,
                          ),
                          child: Center(
                            child: Text(
                              'Logo ${i + 1}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.onSurfaceVariantDark,
                                    fontSize: 11,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : Row(
                    children: List.generate(
                      4,
                      (i) => Container(
                        width: 100,
                        height: 48,
                        margin: const EdgeInsets.only(right: 16),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceElevatedDark,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.borderDark, width: 1),
                          boxShadow: AppShadows.card,
                        ),
                        child: Center(
                          child: Text(
                            'Logo ${i + 1}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.onSurfaceVariantDark,
                                ),
                          ),
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

class _Bullet extends StatelessWidget {
  const _Bullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '•',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.5,
                    color: AppColors.onPrimary,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
