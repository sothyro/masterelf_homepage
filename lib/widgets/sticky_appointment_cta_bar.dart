import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import 'glass_container.dart';

/// Floating vertical bar for Appointment Dashboard CTA. Shown when logged in.
class StickyAppointmentCtaBar extends StatelessWidget {
  const StickyAppointmentCtaBar({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final path = GoRouterState.of(context).uri.path;
    final isActive = path == '/consultations' || path == '/consultations/dashboard';

    final textStyle = Theme.of(context).textTheme.titleSmall?.copyWith(
          color: isActive ? AppColors.onAccent : AppColors.accent,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        );

    const radius = BorderRadius.only(
      topLeft: Radius.circular(12),
      bottomLeft: Radius.circular(12),
    );
    return GlassContainer(
      blurSigma: 10,
      color: isActive ? AppColors.accent.withValues(alpha: 0.9) : AppColors.surfaceElevatedDark.withValues(alpha: 0.9),
      borderRadius: radius,
      border: Border(
        left: BorderSide(color: isActive ? AppColors.borderLight : AppColors.borderDark, width: 1.5),
        top: BorderSide(color: isActive ? AppColors.borderLight : AppColors.borderDark, width: 1.5),
        bottom: BorderSide(color: isActive ? AppColors.borderLight : AppColors.borderDark, width: 1.5),
      ),
      boxShadow: AppShadows.stickyCta,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      child: IntrinsicWidth(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 200),
          child: InkWell(
            onTap: () => context.go('/consultations/dashboard'),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(LucideIcons.calendarCheck, color: isActive ? AppColors.onAccent : AppColors.accent, size: 22),
                  const SizedBox(height: 12),
                  RotatedBox(
                    quarterTurns: 3,
                    child: Text(
                      l10n.consultations,
                      style: textStyle,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
