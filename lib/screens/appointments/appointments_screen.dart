import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../widgets/breadcrumb.dart';

class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Breadcrumb(items: [
              (label: 'Home', route: '/'),
              (label: l10n.consultations, route: null),
            ]),
            const SizedBox(height: 16),
            Text(
              l10n.bookConsultation,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              'Choose a consultation type below or reach out and we\'ll guide you to the right option.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
            ),
            const SizedBox(height: 40),
            _ConsultationCard(
              category: l10n.consult1Category,
              method: l10n.consult1Method,
              description: l10n.consult1Desc,
              icon: LucideIcons.user,
              onGetConsultation: () => context.push('/contact'),
              l10n: l10n,
            ),
            const SizedBox(height: 20),
            _ConsultationCard(
              category: l10n.consult2Category,
              method: l10n.consult2Method,
              description: l10n.consult2Desc,
              icon: LucideIcons.calendar,
              onGetConsultation: () => context.push('/contact'),
              l10n: l10n,
            ),
            const SizedBox(height: 20),
            _ConsultationCard(
              category: l10n.consult3Category,
              method: l10n.consult3Method,
              description: l10n.consult3Desc,
              icon: LucideIcons.home,
              onGetConsultation: () => context.push('/contact'),
              l10n: l10n,
            ),
            const SizedBox(height: 20),
            _ConsultationCard(
              category: l10n.consult4Category,
              method: l10n.consult4Method,
              description: l10n.consult4Desc,
              icon: LucideIcons.clock,
              onGetConsultation: () => context.push('/contact'),
              l10n: l10n,
            ),
          ],
        ),
      ),
    );
  }
}

class _ConsultationCard extends StatelessWidget {
  const _ConsultationCard({
    required this.category,
    required this.method,
    required this.description,
    required this.icon,
    required this.onGetConsultation,
    required this.l10n,
  });

  final String category;
  final String method;
  final String description;
  final IconData icon;
  final VoidCallback onGetConsultation;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onGetConsultation,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Icon(icon, size: 32, color: AppColors.accent),
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
      ),
    );
  }
}
