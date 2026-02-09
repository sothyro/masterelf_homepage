import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../config/app_content.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../providers/locale_provider.dart';
import 'glass_container.dart';
import 'media_posts_popup.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeNotifier = context.read<LocaleNotifier>();
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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  children: [
                    _SectionLabel(label: 'Navigate'),
                    _DrawerTile(
                      label: l10n.home,
                      path: '/',
                      current: current,
                      icon: LucideIcons.home,
                      onTap: () => _go(context, '/'),
                    ),
                    _DrawerTile(
                      label: l10n.about,
                      path: '/about',
                      current: current,
                      icon: LucideIcons.user,
                      onTap: () => _go(context, '/about'),
                    ),
                    _DrawerTile(
                      label: l10n.journey,
                      path: '/journey',
                      current: current,
                      icon: LucideIcons.compass,
                      onTap: () => _go(context, '/journey'),
                    ),
                    _DrawerTile(
                      label: l10n.ourMethod,
                      path: '/method',
                      current: current,
                      icon: LucideIcons.lightbulb,
                      onTap: () => _go(context, '/method'),
                    ),
                    const SizedBox(height: 16),
                    _SectionLabel(label: l10n.charteredPractitioner),
                    _DrawerTile(
                      label: l10n.charteredPractitioner,
                      path: '/academy',
                      current: current,
                      icon: LucideIcons.graduationCap,
                      onTap: () => _go(context, '/academy'),
                    ),
                    _SectionLabel(label: l10n.appsAndStore),
                    _DrawerTile(
                      label: l10n.masterElfSystem,
                      path: '/apps#master-elf',
                      current: current,
                      icon: LucideIcons.cpu,
                      onTap: () => _go(context, '/apps#master-elf'),
                    ),
                    _DrawerTile(
                      label: l10n.period9MobileApp,
                      path: '/apps#period9',
                      current: current,
                      icon: LucideIcons.smartphone,
                      onTap: () => _go(context, '/apps#period9'),
                    ),
                    _DrawerTile(
                      label: l10n.talismanStore,
                      path: '/apps#talisman',
                      current: current,
                      icon: LucideIcons.shoppingBag,
                      onTap: () => _go(context, '/apps#talisman'),
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
                      label: l10n.mediaAndPosts,
                      path: '',
                      current: current,
                      icon: LucideIcons.fileText,
                      onTap: () {
                        Navigator.of(context).pop();
                        showMediaPostsPopup(context);
                      },
                    ),
                    const SizedBox(height: 16),
                    _SectionLabel(label: l10n.consultations),
                    _DrawerTile(
                      label: l10n.consultations,
                      path: '/appointments',
                      current: current,
                      icon: LucideIcons.calendarCheck,
                      onTap: () => _go(context, '/appointments'),
                    ),
                    const SizedBox(height: 24),
                    _SectionLabel(label: 'Get in touch'),
                    const SizedBox(height: 8),
                    _ContactCta(
                      label: l10n.contactUs,
                      icon: LucideIcons.messageCircle,
                      onTap: () => _go(context, '/contact'),
                    ),
                    const SizedBox(height: 24),
                    _SectionLabel(label: l10n.language),
                    const SizedBox(height: 8),
                    _LanguageChips(notifier: localeNotifier),
                    const SizedBox(height: 24),
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
    context.go(path);
  }
}

class _DrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              AppContent.assetLogo,
              width: 44,
              height: 44,
              fit: BoxFit.cover,
              color: AppColors.accent,
              errorBuilder: (_, __, ___) => Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(LucideIcons.sparkles, color: AppColors.accent, size: 24),
              ),
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
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 6),
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.white54,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
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
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: isActive ? AppColors.accent.withValues(alpha: 0.18) : Colors.transparent,
              border: isActive ? Border.all(color: AppColors.accent.withValues(alpha: 0.5), width: 1) : null,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.accent.withValues(alpha: 0.25) : Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: isActive ? AppColors.accent : Colors.white70,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                      color: isActive ? AppColors.accent : Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
                if (isActive)
                  const Icon(LucideIcons.chevronRight, size: 18, color: AppColors.accent),
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
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: const LinearGradient(
              colors: [Color(0xFFA68520), AppColors.accent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withValues(alpha: 0.35),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, size: 22, color: AppColors.onAccent),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.onAccent,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
              const Icon(LucideIcons.arrowRight, size: 20, color: AppColors.onAccent),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageChips extends StatelessWidget {
  const _LanguageChips({required this.notifier});

  final LocaleNotifier notifier;

  static const _locales = [
    ('en', 'EN'),
    ('km', 'KM'),
    ('zh', 'ZH'),
  ];

  @override
  Widget build(BuildContext context) {
    final code = notifier.locale.languageCode;
    return Row(
      children: _locales.map((e) {
        final isSelected = code == e.$1;
        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                notifier.setLocaleFromCode(e.$1);
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.accent.withValues(alpha: 0.25) : Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: isSelected ? Border.all(color: AppColors.accent, width: 1.5) : null,
                ),
                child: Text(
                  e.$2,
                  style: TextStyle(
                    color: isSelected ? AppColors.accent : Colors.white70,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
