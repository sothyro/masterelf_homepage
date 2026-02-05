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
      color: AppColors.backgroundDark,
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
                    color: AppColors.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.sectionKnowledgeBody,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.onSurfaceVariantDark,
                    height: 1.5,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.sectionKnowledgeBody2,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.onSurfaceVariantDark,
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
                    color: AppColors.onSurfaceVariantDark,
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

class _AcademyCard extends StatefulWidget {
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
  State<_AcademyCard> createState() => _AcademyCardState();
}

class _AcademyCardState extends State<_AcademyCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final shadow = _isHovered ? AppShadows.cardHover : AppShadows.card;
    final borderColor = _isHovered ? AppColors.borderLight.withValues(alpha: 0.5) : AppColors.borderDark;
    final scale = _isHovered ? 1.02 : 1.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: AppColors.surfaceElevatedDark,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: 1),
            boxShadow: shadow,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onExplore,
              borderRadius: BorderRadius.circular(12),
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
                          child: Icon(widget.icon, size: 32, color: AppColors.accent),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.onPrimary,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            height: 1.5,
                            color: AppColors.onSurfaceVariantDark,
                          ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: widget.onExplore,
                      child: Text(l10n.exploreCourses),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
