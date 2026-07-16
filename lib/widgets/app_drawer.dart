import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../config/app_content.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import 'app_shell_scroll_scope.dart';
import 'glass_container.dart';
import 'logo_with_shape_shadow.dart';
import 'media_posts_popup.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final uri = GoRouterState.of(context).uri;
    final current = uri.path + (uri.fragment.isNotEmpty ? '#${uri.fragment}' : '');

    return Drawer(
      backgroundColor: Colors.transparent,
      child: GlassContainer(
        blurSigma: 10,
        color: AppColors.overlayDark.withValues(alpha: 0.88),
        borderRadius: BorderRadius.zero,
        border: const Border(
          right: BorderSide(color: AppColors.borderLight, width: 1.5),
        ),
        padding: EdgeInsets.zero,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _DrawerHeader(),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                  children: [
                    _SectionLabel(label: l10n.drawerNavigate),
                    _DrawerTile(
                      label: l10n.home,
                      path: '/',
                      current: current,
                      icon: LucideIcons.home,
                      onTap: () => _go(context, '/'),
                    ),
                    _SectionLabel(label: l10n.charteredPractitioner),
                    _DrawerTile(
                      label: l10n.journey,
                      path: '/journey',
                      current: current,
                      icon: LucideIcons.compass,
                      onTap: () => _go(context, '/journey'),
                    ),
                    _DrawerTile(
                      label: l10n.methodPageTitle,
                      path: '/academy',
                      current: current,
                      icon: LucideIcons.layers,
                      onTap: () => _go(context, '/academy'),
                    ),
                    _SectionLabel(label: l10n.appsAndStore),
                    _DrawerTile(
                      label: l10n.masterElfSystem,
                      path: '/apps',
                      current: current,
                      icon: LucideIcons.cpu,
                      onTap: () => _go(context, '/apps'),
                    ),
                    _DrawerTile(
                      label: l10n.bookStoreNav,
                      path: '/books',
                      current: current,
                      icon: LucideIcons.bookOpen,
                      onTap: () => _go(context, '/books'),
                    ),
                    _DrawerTile(
                      label: l10n.talismanStore,
                      path: '/talisman',
                      current: current,
                      icon: LucideIcons.shoppingBag,
                      onTap: () => _go(context, '/talisman'),
                    ),
                    _SectionLabel(label: l10n.events),
                    _DrawerTile(
                      label: l10n.eventsCalendar,
                      path: '/events',
                      current: current,
                      icon: LucideIcons.calendarDays,
                      onTap: () => _go(context, '/events'),
                    ),
                    _DrawerTile(
                      label: l10n.fieldWorkNav,
                      path: '/field-work',
                      current: current,
                      icon: LucideIcons.camera,
                      onTap: () => _go(context, '/field-work'),
                    ),
                    _DrawerTile(
                      label: l10n.mediaAndPosts,
                      path: '',
                      current: current,
                      icon: LucideIcons.fileText,
                      onTap: () {
                        Navigator.of(context).pop();
                        showMediaPostsPopup(context);
                      },
                    ),
                    const SizedBox(height: 4),
                    _SectionLabel(label: l10n.consultations),
                    _DrawerTile(
                      label: l10n.consultations,
                      path: '/consultations',
                      current: current,
                      icon: LucideIcons.calendarCheck,
                      onTap: () => _go(context, '/consultations'),
                    ),
                    const SizedBox(height: 8),
                    _SectionLabel(label: l10n.drawerGetInTouch),
                    const SizedBox(height: 2),
                    _ContactCta(
                      label: l10n.contactUs,
                      icon: LucideIcons.messageCircle,
                      onTap: () => _go(context, '/contact'),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _go(BuildContext context, String path) {
    Navigator.of(context).pop();
    goShellRoute(context, path);
  }
}

class _DrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Logo and title sizes stay fixed; only outer padding is tightened.
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 16, 8),
      child: Row(
        children: [
          LogoWithShapeShadow(
            assetPath: AppContent.assetLogo,
            width: 88,
            height: 88,
            errorBuilder: (_, __, ___) => Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(LucideIcons.sparkles, color: AppColors.accent, size: 24),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppContent.shortName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 2),
                Container(
                  height: 2,
                  width: 32,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final isKm = locale.languageCode == 'km';
    return Padding(
      padding: const EdgeInsets.only(left: 4, top: 6, bottom: 2),
      child: Text(
        isKm ? label : label.toUpperCase(),
        style: menuLabelStyle(
          context,
          fontSize: 10,
          color: Colors.white54,
          fontWeight: FontWeight.w600,
          letterSpacing: isKm ? 0 : 1.0,
          height: 1.1,
        ),
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  const _DrawerTile({
    required this.label,
    required this.path,
    required this.current,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final String path;
  final String current;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isActive = current == path;
    return Padding(
      padding: const EdgeInsets.only(bottom: 1),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            constraints: const BoxConstraints(minHeight: 36),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: isActive ? AppColors.accent.withValues(alpha: 0.18) : Colors.transparent,
              border: isActive ? Border.all(color: AppColors.accent.withValues(alpha: 0.5), width: 1) : null,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.accent.withValues(alpha: 0.25) : Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    size: 16,
                    color: isActive ? AppColors.accent : Colors.white70,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    label,
                    style: menuItemLabelStyle(
                      context,
                      fontSize: 14,
                      color: isActive ? AppColors.accent : Colors.white,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                      height: 1.15,
                    ),
                  ),
                ),
                if (isActive)
                  const Icon(LucideIcons.chevronRight, size: 16, color: AppColors.accent),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ContactCta extends StatelessWidget {
  const _ContactCta({required this.label, required this.icon, required this.onTap});

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(
              colors: [Color(0xFFA68520), AppColors.accent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withValues(alpha: 0.35),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, size: 18, color: AppColors.onAccent),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: menuItemLabelStyle(
                    context,
                    fontSize: 14,
                    color: AppColors.onAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(LucideIcons.arrowRight, size: 16, color: AppColors.onAccent),
            ],
          ),
        ),
      ),
    );
  }
}
