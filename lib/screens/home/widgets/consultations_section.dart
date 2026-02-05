import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../config/app_content.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/breakpoints.dart';

class ConsultationsSection extends StatelessWidget {
  const ConsultationsSection({super.key});

  static const double _cardGap = 24.0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = Breakpoints.isMobile(width);

    final blocks = [
      _ConsultBlock(
        category: l10n.consult1Category,
        method: l10n.consult1Method,
        question: l10n.consult1Question,
        description: l10n.consult1Desc,
        icon: LucideIcons.user,
        onGetConsultation: () => context.push('/appointments'),
      ),
      _ConsultBlock(
        category: l10n.consult2Category,
        method: l10n.consult2Method,
        question: l10n.consult2Question,
        description: l10n.consult2Desc,
        icon: LucideIcons.calendar,
        onGetConsultation: () => context.push('/appointments'),
      ),
      _ConsultBlock(
        category: l10n.consult3Category,
        method: l10n.consult3Method,
        question: l10n.consult3Question,
        description: l10n.consult3Desc,
        icon: LucideIcons.home,
        onGetConsultation: () => context.push('/appointments'),
      ),
      _ConsultBlock(
        category: l10n.consult4Category,
        method: l10n.consult4Method,
        question: l10n.consult4Question,
        description: l10n.consult4Desc,
        icon: LucideIcons.clock,
        onGetConsultation: () => context.push('/appointments'),
      ),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 56, horizontal: 24),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppContent.assetAcademy),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.overlayDark.withValues(alpha: 0.6),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.sectionMapHeading,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Text(
              l10n.sectionMapIntro,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.5,
                color: AppColors.onPrimary.withValues(alpha: 0.9),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            if (isMobile) ...[
              ...blocks.map((b) => Padding(
                    padding: const EdgeInsets.only(bottom: _cardGap),
                    child: b,
                  )),
            ] else
              Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: blocks[0]),
                      const SizedBox(width: _cardGap),
                      Expanded(child: blocks[1]),
                    ],
                  ),
                  const SizedBox(height: _cardGap),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: blocks[2]),
                      const SizedBox(width: _cardGap),
                      Expanded(child: blocks[3]),
                    ],
                  ),
                ],
              ),
          ],
            ),
          ),
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

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onGetConsultation,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevatedDark,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderDark, width: 1),
            boxShadow: AppShadows.card,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, size: 28, color: AppColors.accent),
                  ),
                  const SizedBox(width: 16),
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
                        const SizedBox(height: 2),
                        Text(
                          method,
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: AppColors.onPrimary.withValues(alpha: 0.7),
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                question,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: AppColors.onPrimary,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.onPrimary.withValues(alpha: 0.8),
                      height: 1.45,
                    ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: AppShadows.accentButton,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: onGetConsultation,
                    style: FilledButton.styleFrom(elevation: 0),
                    child: Text(l10n.getConsultation),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
