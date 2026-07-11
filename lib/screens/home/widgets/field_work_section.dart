import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../config/field_work_content.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/breakpoints.dart';
import '../../field_work/field_work_widgets.dart';
import 'field_work_chinese_design.dart';

/// Homepage proof layer between Consultations and Story — 4 equal showcase pillars.
class FieldWorkSection extends StatelessWidget {
  const FieldWorkSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = Breakpoints.isMobile(width);
    final isCompact = Breakpoints.isCompact(width);
    final cardsPerRow = isMobile || isCompact;
    final paddingH = isMobile ? 16.0 : 24.0;
    final gap = isMobile ? 16.0 : 20.0;
    final pillars = buildFieldWorkCategoryPillars(l10n);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Positioned.fill(child: ChineseInkWashGlow()),
        Padding(
          padding: EdgeInsets.symmetric(vertical: isMobile ? 48 : 64, horizontal: paddingH),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FieldWorkChineseSectionHeader(
                    title: l10n.fieldWorkSectionTitle,
                    headline: l10n.fieldWorkSectionHeadline,
                    subline: l10n.fieldWorkSectionSubline,
                    isMobile: isMobile || isCompact,
                  ),
                  SizedBox(height: isMobile ? 32 : 40),
                  if (cardsPerRow)
                    Column(
                      children: [
                        for (var i = 0; i < pillars.length; i++)
                          Padding(
                            padding: EdgeInsets.only(bottom: i < pillars.length - 1 ? gap : 0),
                            child: FieldWorkShowcaseCard(
                              pillar: pillars[i],
                              pillarIndex: i,
                              modernChineseStyle: true,
                            ),
                          ),
                      ],
                    )
                  else
                    Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: FieldWorkShowcaseCard(
                                pillar: pillars[0],
                                pillarIndex: 0,
                                modernChineseStyle: true,
                              ),
                            ),
                            SizedBox(width: gap),
                            Expanded(
                              child: FieldWorkShowcaseCard(
                                pillar: pillars[1],
                                pillarIndex: 1,
                                modernChineseStyle: true,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: gap),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: FieldWorkShowcaseCard(
                                pillar: pillars[2],
                                pillarIndex: 2,
                                modernChineseStyle: true,
                              ),
                            ),
                            SizedBox(width: gap),
                            Expanded(
                              child: FieldWorkShowcaseCard(
                                pillar: pillars[3],
                                pillarIndex: 3,
                                modernChineseStyle: true,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  SizedBox(height: isMobile ? 32 : 40),
                  FieldWorkChineseCtaPanel(
                    isMobile: isMobile || isCompact,
                    child: _SectionCtas(l10n: l10n, isMobile: isMobile || isCompact),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionCtas extends StatelessWidget {
  const _SectionCtas({required this.l10n, required this.isMobile});

  final AppLocalizations l10n;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final viewAll = OutlinedButton.icon(
      onPressed: () => context.push('/field-work'),
      icon: const Icon(LucideIcons.camera, size: 18),
      label: Text(l10n.fieldWorkViewAll),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.accent,
        side: BorderSide(color: AppColors.accent.withValues(alpha: 0.75), width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
    final book = FilledButton.icon(
      onPressed: () => context.push('/consultations'),
      icon: const Icon(LucideIcons.calendarCheck, size: 18),
      label: Text(l10n.fieldWorkBookConsultation),
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.onAccent,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          viewAll,
          const SizedBox(height: 12),
          book,
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        viewAll,
        const SizedBox(width: 16),
        book,
      ],
    );
  }
}
