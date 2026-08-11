import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import 'glass_container.dart';

/// Icon-only logout button for the desktop sticky CTA bar. Shown when logged in.
class StickyLogoutCtaBar extends StatelessWidget {
  const StickyLogoutCtaBar({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final auth = context.watch<AuthProvider>();

    const radius = BorderRadius.only(
      topLeft: Radius.circular(12),
      bottomLeft: Radius.circular(12),
    );
    return GlassContainer(
      blurSigma: 10,
      color: AppColors.surfaceElevatedDark.withValues(alpha: 0.9),
      borderRadius: radius,
      border: const Border(
        left: BorderSide(color: AppColors.borderDark, width: 1.5),
        top: BorderSide(color: AppColors.borderDark, width: 1.5),
        bottom: BorderSide(color: AppColors.borderDark, width: 1.5),
      ),
      boxShadow: AppShadows.stickyCta,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      child: IconButton(
        icon: const Icon(LucideIcons.logOut, color: AppColors.accent, size: 22),
        onPressed: auth.signOut,
        tooltip: l10n.logoutButton,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(
          minWidth: 36,
          minHeight: 36,
        ),
        style: IconButton.styleFrom(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }
}
