import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import 'forecast_popup.dart';
import 'glass_container.dart';
import 'login_dialog.dart';

/// Approximate height of the mobile bottom CTA bar for layout calculations.
/// Includes bar content, padding, and typical SafeArea bottom inset.
const double kMobileStickyCtaBarHeight = 88.0;

/// Horizontal sticky bar at the bottom for mobile (thumb zone).
/// When logged out: Login and 12 Zodiac Forecast. When logged in: Appointment and Inspection.
class MobileStickyCtaBar extends StatelessWidget {
  const MobileStickyCtaBar({super.key});

  void _openForecastPopup(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) => const ForecastPopup(),
    );
  }

  void _openLoginDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showLoginDialog(
      context,
      successActions: [
        (label: l10n.dashboardTitle, route: '/consultations/dashboard'),
        (label: l10n.inspectionDashboardTitle, route: '/consultations/inspection-dashboard'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final l10n = AppLocalizations.of(context)!;
    final path = GoRouterState.of(context).uri.path;

    final isConsultationsPage = path == '/consultations' ||
        path == '/consultations/dashboard';
    final isInspectionPage = path == '/consultations/inspection-dashboard' ||
        path.startsWith('/consultations/site-inspection');

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: GlassContainer(
          blurSigma: 8,
          color: AppColors.surfaceElevatedDark.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderLight.withValues(alpha: 0.5), width: 1),
          boxShadow: AppShadows.stickyCta,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (auth.isLoggedIn) ...[
                Expanded(
                  child: _CtaButton(
                    icon: LucideIcons.calendarCheck,
                    label: l10n.consultations,
                    onTap: () => context.go('/consultations/dashboard'),
                    isPrimary: isConsultationsPage,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _CtaButton(
                    icon: LucideIcons.clipboardList,
                    label: l10n.siteInspection,
                    onTap: () => context.go('/consultations/inspection-dashboard'),
                    isPrimary: isInspectionPage,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(LucideIcons.logOut, color: AppColors.accent, size: 22),
                  onPressed: auth.signOut,
                  tooltip: l10n.logoutButton,
                  style: IconButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ] else ...[
                Expanded(
                  child: _CtaButton(
                    icon: LucideIcons.logIn,
                    label: l10n.loginButton,
                    onTap: () => _openLoginDialog(context),
                    isPrimary: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _CtaButton(
                    icon: LucideIcons.megaphone,
                    label: l10n.stickyCtaText,
                    onTap: () => _openForecastPopup(context),
                    isPrimary: false,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _CtaButton extends StatelessWidget {
  const _CtaButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isPrimary = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isPrimary ? AppColors.accent.withValues(alpha: 0.9) : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20,
                color: isPrimary ? AppColors.onAccent : AppColors.accent,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: isPrimary ? AppColors.onAccent : AppColors.accent,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
