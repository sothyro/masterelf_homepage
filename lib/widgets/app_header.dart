import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../providers/locale_provider.dart';
import '../config/app_content.dart';
import '../utils/breakpoints.dart';
import 'glass_container.dart';

/// Menu bar colors: gold accents and link text (glass fill uses [AppColors.overlayDark]).
class _MenuColors {
  _MenuColors._();
  static const Color barBorder = Color(0xFFC9A227);
  static const Color linkText = Color(0xFFF0F0F0);
  static const Color goldDark = Color(0xFFA68520);
}

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppHeader({super.key, this.onOpenDrawer});

  final VoidCallback? onOpenDrawer;

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeNotifier = context.watch<LocaleNotifier>();
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = Breakpoints.isMobile(width);

    return Semantics(
      container: true,
      label: 'Navigation',
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        color: Colors.transparent,
        child: isMobile
            ? _MobileHeader(l10n: l10n, onOpenDrawer: onOpenDrawer)
            : _DesktopHeader(l10n: l10n, localeNotifier: localeNotifier),
      ),
    );
  }
}

class _MobileHeader extends StatelessWidget {
  const _MobileHeader({required this.l10n, this.onOpenDrawer});

  final AppLocalizations l10n;
  final VoidCallback? onOpenDrawer;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      blurSigma: 14,
      color: AppColors.overlayDark.withValues(alpha: 0.42),
      borderRadius: BorderRadius.circular(32),
      border: Border.all(color: _MenuColors.barBorder, width: 1.5),
      boxShadow: AppShadows.header,
      padding: EdgeInsets.zero,
      child: SizedBox(
        height: 64,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(LucideIcons.menu, color: _MenuColors.linkText, size: 24),
              onPressed: onOpenDrawer ?? () {},
              tooltip: 'Menu',
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => context.go('/'),
                child: Center(
                  child: Image.asset(
                    AppContent.assetLogo,
                    height: 40,
                    fit: BoxFit.contain,
                    color: AppColors.accent,
                    errorBuilder: (_, __, ___) => Text(
                      AppContent.shortName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.accent,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: _ContactUsButton(l10n: l10n),
            ),
          ],
        ),
      ),
    );
  }
}

class _DesktopHeader extends StatelessWidget {
  const _DesktopHeader({required this.l10n, required this.localeNotifier});

  final AppLocalizations l10n;
  final LocaleNotifier localeNotifier;

  /// Paths per dropdown (by index). When multiple dropdowns share a path (e.g. /events),
  /// only the last matching one is active so at most one menu is highlighted.
  static const _dropdownPaths = [
    ['/about'],
    ['/academy'],
    ['/events'],  // Resources
    ['/events'],  // News & Events — wins when on /events
  ];

  @override
  Widget build(BuildContext context) {
    final current = GoRouterState.of(context).uri.path;
    final pathOnly = current.split('#').first;
    int activeDropdownIndex = -1;
    for (int i = 0; i < _dropdownPaths.length; i++) {
      if (_dropdownPaths[i].any((p) => pathOnly == p || pathOnly.startsWith('$p/'))) {
        activeDropdownIndex = i;
      }
    }
    return Center(
      child: GlassContainer(
        blurSigma: 14,
        color: AppColors.overlayDark.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(34),
        border: Border.all(color: _MenuColors.barBorder, width: 1.5),
        boxShadow: AppShadows.header,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280, minHeight: 56),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            GestureDetector(
              onTap: () => context.go('/'),
              child: Image.asset(
                AppContent.assetLogo,
                height: 42,
                fit: BoxFit.contain,
                color: AppColors.accent,
                errorBuilder: (_, __, ___) => Text(
                  AppContent.shortName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
            const SizedBox(width: 36),
            _NavLink(label: l10n.home, path: '/'),
            _NavDropdown(
              label: l10n.about,
              items: [
                _NavItem(l10n.journey, '/about', LucideIcons.compass),
                _NavItem(l10n.ourMethod, '/about#method', LucideIcons.lightbulb),
              ],
              isActive: activeDropdownIndex == 0,
            ),
            _NavDropdown(
              label: l10n.learning,
              items: [
                _NavItem('QiMen Academy', '/academy', LucideIcons.compass),
                _NavItem('Feng Shui Academy', '/academy', LucideIcons.home),
                _NavItem('BaZi Academy', '/academy', LucideIcons.user),
              ],
              isActive: activeDropdownIndex == 1,
            ),
            _NavDropdown(
              label: l10n.resources,
              items: [
                _NavItem('BaZi Plotter', '/events', LucideIcons.calendar),
                _NavItem('Flying Star Charts', '/events', LucideIcons.star),
                _NavItem('Store', '/events', LucideIcons.shoppingBag),
              ],
              isActive: activeDropdownIndex == 2,
            ),
            _NavDropdown(
              label: l10n.newsAndEvents,
              items: [
                _NavItem(l10n.events, '/events', LucideIcons.calendarDays),
                _NavItem(l10n.blog, '/events', LucideIcons.fileText),
                _NavItem(l10n.media, '/events', LucideIcons.video),
              ],
              isActive: activeDropdownIndex == 3,
            ),
            _NavLink(label: l10n.consultations, path: '/appointments'),
            const Spacer(),
            _LocaleSwitcher(notifier: localeNotifier),
            const SizedBox(width: 20),
            _ContactUsButton(l10n: l10n),
            ],
          ),
        ),
      ),
    );
  }
}

/// Contact Us button styled like the Hero section's "Book Consultation" button.
class _ContactUsButton extends StatelessWidget {
  const _ContactUsButton({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isNarrow = width < 500;
    final isMedium = width < 800 && !isNarrow;
    final horizontalPadding = isNarrow ? 16.0 : (isMedium ? 20.0 : 24.0);
    final verticalPadding = isNarrow ? 8.0 : (isMedium ? 10.0 : 12.0);
    final fontSize = isNarrow ? 12.0 : (isMedium ? 14.0 : 15.0);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: AppShadows.accentButton,
      ),
      child: FilledButton(
        onPressed: () => context.push('/contact'),
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.onAccent,
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          l10n.contactUs,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  const _NavLink({required this.label, required this.path});

  final String label;
  final String path;

  @override
  Widget build(BuildContext context) {
    final current = GoRouterState.of(context).uri.path;
    final isActive = current == path;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: TextButton(
        onPressed: () => context.go(path),
        style: TextButton.styleFrom(
          foregroundColor: _MenuColors.linkText,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.hovered)) {
              return _MenuColors.linkText.withValues(alpha: 0.1);
            }
            return null;
          }),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isActive ? AppColors.accent : _MenuColors.linkText,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                fontSize: 14,
              ),
            ),
            if (isActive)
              Container(
                margin: const EdgeInsets.only(top: 4),
                height: 2,
                width: 24,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem(this.label, this.path, [this.icon]);
  final String label;
  final String path;
  final IconData? icon;
}

class _NavDropdown extends StatelessWidget {
  const _NavDropdown({
    required this.label,
    required this.items,
    required this.isActive,
  });

  final String label;
  final List<_NavItem> items;
  /// When true, this dropdown is shown as the active nav item. Only one dropdown
  /// should be active per route so that shared paths (e.g. /events) don't highlight multiple menus.
  final bool isActive;

  static const _itemHeight = 48.0;

  Future<void> _showDropdown(BuildContext context, RenderBox button) async {
    final current = GoRouterState.of(context).uri.path;
    final offset = button.localToGlobal(Offset.zero);
    final size = MediaQuery.sizeOf(context);
    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + button.size.height + 6,
        size.width - offset.dx,
        size.height - offset.dy - button.size.height - 6,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: _MenuColors.barBorder, width: 1.5),
      ),
      color: AppColors.overlayDark.withValues(alpha: 0.92),
      elevation: 12,
      items: items
          .map((e) => PopupMenuItem<String>(
                value: e.path,
                height: _itemHeight,
                padding: EdgeInsets.zero,
                child: _DropdownItem(
                  label: e.label,
                  icon: e.icon,
                  isActive: current == e.path || current.startsWith('${e.path}/'),
                ),
              ))
          .toList(),
    );
    if (selected != null && context.mounted) context.go(selected);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Builder(
        builder: (context) {
          return InkWell(
            onTap: () {
              final box = context.findRenderObject() as RenderBox?;
              if (box != null) _showDropdown(context, box);
            },
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          color: isActive ? AppColors.accent : _MenuColors.linkText,
                          fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        LucideIcons.chevronDown,
                        size: 16,
                        color: isActive ? AppColors.accent : _MenuColors.linkText,
                      ),
                    ],
                  ),
                  if (isActive)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      height: 2,
                      width: 24,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DropdownItem extends StatelessWidget {
  const _DropdownItem({required this.label, this.icon, required this.isActive});

  final String label;
  final IconData? icon;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon!, size: 18, color: isActive ? AppColors.accent : Colors.white70),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: isActive ? AppColors.accent : Colors.white,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
          if (isActive) const Icon(LucideIcons.check, size: 16, color: AppColors.accent),
        ],
      ),
    );
  }
}

class _LocaleSwitcher extends StatelessWidget {
  const _LocaleSwitcher({required this.notifier});

  final LocaleNotifier notifier;

  static const _locales = [
    ('en', 'EN'),
    ('km', 'KM'),
    ('zh', 'ZH'),
  ];

  static const _itemHeight = 44.0;

  Future<void> _showLocaleMenu(BuildContext context, RenderBox button) async {
    final code = notifier.locale.languageCode;
    final offset = button.localToGlobal(Offset.zero);
    final size = MediaQuery.sizeOf(context);
    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + button.size.height + 6,
        size.width - offset.dx,
        size.height - offset.dy - button.size.height - 6,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: _MenuColors.barBorder, width: 1.5),
      ),
      color: AppColors.overlayDark.withValues(alpha: 0.92),
      elevation: 12,
      items: _locales
          .map((e) => PopupMenuItem<String>(
                value: e.$1,
                height: _itemHeight,
                padding: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Icon(
                        LucideIcons.languages,
                        size: 18,
                        color: code == e.$1 ? AppColors.accent : Colors.white70,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        e.$2,
                        style: TextStyle(
                          color: code == e.$1 ? AppColors.accent : Colors.white,
                          fontWeight: code == e.$1 ? FontWeight.w600 : FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      if (code == e.$1) ...[
                        const Spacer(),
                        const Icon(LucideIcons.check, size: 16, color: AppColors.accent),
                      ],
                    ],
                  ),
                ),
              ))
          .toList(),
    );
    if (selected != null) notifier.setLocaleFromCode(selected);
  }

  @override
  Widget build(BuildContext context) {
    final code = notifier.locale.languageCode;
    return Builder(
      builder: (context) => InkWell(
        onTap: () {
          final box = context.findRenderObject() as RenderBox?;
          if (box != null) _showLocaleMenu(context, box);
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(LucideIcons.languages, size: 16, color: _MenuColors.linkText),
              const SizedBox(width: 4),
              Text(
                code.toUpperCase(),
                style: const TextStyle(color: _MenuColors.linkText, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
