import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';

class ConsultationsSection extends StatelessWidget {
  const ConsultationsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 56, horizontal: 24),
      color: AppColors.background,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.sectionMapHeading,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Text(
              l10n.sectionMapIntro,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            _ConsultBlock(
              category: l10n.consult1Category,
              method: l10n.consult1Method,
              question: l10n.consult1Question,
              description: l10n.consult1Desc,
              icon: LucideIcons.user,
              onGetConsultation: () => context.push('/appointments'),
            ),
            const SizedBox(height: 24),
            _ConsultBlock(
              category: l10n.consult2Category,
              method: l10n.consult2Method,
              question: l10n.consult2Question,
              description: l10n.consult2Desc,
              icon: LucideIcons.calendar,
              onGetConsultation: () => context.push('/appointments'),
            ),
            const SizedBox(height: 24),
            _ConsultBlock(
              category: l10n.consult3Category,
              method: l10n.consult3Method,
              question: l10n.consult3Question,
              description: l10n.consult3Desc,
              icon: LucideIcons.home,
              onGetConsultation: () => context.push('/appointments'),
            ),
            const SizedBox(height: 24),
            _ConsultBlock(
              category: l10n.consult4Category,
              method: l10n.consult4Method,
              question: l10n.consult4Question,
              description: l10n.consult4Desc,
              icon: LucideIcons.clock,
              onGetConsultation: () => context.push('/appointments'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConsultBlock extends StatelessWidget {
  const _ConsultBlock({
    required this.category,
    required this.method,
    required this.question,
    required this.description,
    required this.icon,
    required this.onGetConsultation,
  });

  final String category;
  final String method;
  final String question;
  final String description;
  final IconData icon;
  final VoidCallback onGetConsultation;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 28, color: AppColors.accent),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Text(
                    method,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.onSurfaceVariant),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    question,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: AppColors.onSurface,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: onGetConsultation,
                    child: Text(l10n.getConsultation),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
