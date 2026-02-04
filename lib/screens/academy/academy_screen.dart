import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../config/app_content.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../widgets/breadcrumb.dart';
import '../../utils/breakpoints.dart';

class AcademyScreen extends StatelessWidget {
  const AcademyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.sizeOf(context).width;
    final isNarrow = Breakpoints.isMobile(width);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Breadcrumb(items: [
              (label: l10n.home, route: '/'),
              (label: l10n.learning, route: null),
            ]),
            const SizedBox(height: 16),
            Text(
              l10n.sectionKnowledgeHeading,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.sectionKnowledgeBody,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.onSurfaceVariant,
                    height: 1.5,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.sectionKnowledgeBody2,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.onSurfaceVariant,
                    height: 1.5,
                  ),
            ),
            const SizedBox(height: 40),
            if (isNarrow) ...[
              _AcademyCard(
                icon: LucideIcons.compass,
                title: l10n.academyQiMen,
                description: l10n.academyQiMenDesc,
                onExplore: () {}, // placeholder: future course page
              ),
              const SizedBox(height: 16),
              _AcademyCard(
                icon: LucideIcons.user,
                title: l10n.academyBaZi,
                description: l10n.academyBaZiDesc,
                onExplore: () {},
              ),
              const SizedBox(height: 16),
              _AcademyCard(
                icon: LucideIcons.home,
                title: l10n.academyFengShui,
                description: l10n.academyFengShuiDesc,
                onExplore: () {},
              ),
            ] else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _AcademyCard(
                      icon: LucideIcons.compass,
                      title: l10n.academyQiMen,
                      description: l10n.academyQiMenDesc,
                      onExplore: () {},
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: _AcademyCard(
                      icon: LucideIcons.user,
                      title: l10n.academyBaZi,
                      description: l10n.academyBaZiDesc,
                      onExplore: () {},
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: _AcademyCard(
                      icon: LucideIcons.home,
                      title: l10n.academyFengShui,
                      description: l10n.academyFengShuiDesc,
                      onExplore: () {},
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 32),
            Text(
              'More courses and schedules will be announced here. Contact us for early access or custom group sessions.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => context.push('/contact'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.onAccent,
              ),
              child: Text(l10n.contactUs),
            ),
          ],
        ),
      ),
    );
  }
}

class _AcademyCard extends StatelessWidget {
  const _AcademyCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onExplore,
  });

  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                AppContent.assetAcademy,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 32, color: AppColors.accent),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: onExplore,
              child: Text(l10n.exploreCourses),
            ),
          ],
        ),
      ),
    );
  }
}
