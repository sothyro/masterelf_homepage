import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../config/store_routes.dart';
import '../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../utils/breakpoints.dart';
import 'app_header.dart';
import 'app_footer.dart';
import 'app_drawer.dart';
import 'mobile_sticky_cta_bar.dart';
import 'sticky_appointment_cta_bar.dart';
import 'sticky_cta_bar.dart';
import 'sticky_inspection_cta_bar.dart';
import 'sticky_login_cta_bar.dart';
import 'sticky_logout_cta_bar.dart';
import 'app_shell_scroll_scope.dart';

/// Maximum height (from top of overlay) that participates in hit testing.
/// Taps below this pass through to content (breadcrumbs, buttons, etc.).
/// Must include nav bar (~72px) plus language flags row (barHeight+8 ≈ 80, row ~24px) so flags are clickable.
const double _kHeaderHitTestHeight = 130.0;

/// Wraps each route with persistent header and footer.
class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  @override
  State<AppShell> createState() => _AppShellState();
}

/// Scroll offset past which the hero area is considered "scrolled past" (menu hides).
const double _heroThreshold = 400;

class _AppShellState extends State<AppShell> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _showBackToTop = false;
  bool _menuVisible = true;
  String _routeLocation = '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final uri = GoRouterState.of(context).uri;
    final location = uri.path +
        (uri.hasQuery ? '?${uri.query}' : '') +
        (uri.fragment.isNotEmpty ? '#${uri.fragment}' : '');
    if (location != _routeLocation) {
      _routeLocation = location;
      if (!routeRequestsSectionScroll(uri)) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.jumpTo(0);
          }
          setState(() {
            _menuVisible = true;
            _showBackToTop = false;
          });
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AppShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child != widget.child) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(0);
        }
        setState(() {
          _menuVisible = true;
          _showBackToTop = false;
        });
      });
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final offset = _scrollController.offset;
    final showBackToTop = offset > _heroThreshold;
    final menuVisible = offset <= _heroThreshold;
    if (showBackToTop != _showBackToTop || menuVisible != _menuVisible) {
      setState(() {
        _showBackToTop = showBackToTop;
        _menuVisible = menuVisible;
      });
    }
  }

  void _scrollToContent() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = Breakpoints.isMobile(width);
    final bottomSafe = MediaQuery.paddingOf(context).bottom;
    final mobileBarHeight = isMobile ? kMobileStickyCtaBarHeight : 0.0;
    final fabBottomPadding = (isMobile ? 24.0 : 60.0) + bottomSafe + mobileBarHeight;
    final footerBottomInset = isMobile ? kMobileStickyCtaBarHeight + 8 : 0.0;

    return AppShellScrollScope(
      scrollController: _scrollController,
      child: Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.backgroundDark,
      drawer: const AppDrawer(),
      floatingActionButton: _showBackToTop
          ? Padding(
              padding: EdgeInsets.only(bottom: fabBottomPadding),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: AppShadows.stickyCta,
                ),
                child: FloatingActionButton.small(
                  onPressed: _scrollToContent,
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.onAccent,
                  elevation: 0,
                  highlightElevation: 0,
                  tooltip: AppLocalizations.of(context)!.backToTop,
                  child: const Icon(Icons.keyboard_arrow_up),
                ),
              ),
            )
          : null,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Semantics(
            container: true,
            label: l10n.semanticsMainContent,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  controller: _scrollController,
                  physics: const ClampingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        widget.child,
                        Semantics(
                          container: true,
                          label: l10n.semanticsFooter,
                          child: AppFooter(bottomInset: footerBottomInset),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: IgnorePointer(
              ignoring: !_menuVisible,
              child: AnimatedSlide(
                offset: _menuVisible ? Offset.zero : const Offset(0, -1),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: AnimatedOpacity(
                  opacity: _menuVisible ? 1 : 0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                    child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: _HeaderHitTestLimit(
                        maxHitTestHeight: _kHeaderHitTestHeight,
                        child: AppHeader(
                          onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Desktop: vertical sticky CTA bars on the right
          // When logged in: Appointment + Inspection. When logged out: Login + 12 Zodiac.
          if (!isMobile)
            Positioned(
              right: 0,
              top: 160,
              bottom: 100,
              child: SafeArea(
                left: false,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Builder(
                    builder: (context) {
                      final auth = context.watch<AuthProvider>();
                      return SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (auth.isLoggedIn) ...[
                              StickyAppointmentCtaBar(),
                              const SizedBox(height: 12),
                              StickyInspectionCtaBar(),
                              const SizedBox(height: 12),
                              StickyLogoutCtaBar(),
                            ] else ...[
                              StickyLoginCtaBar(),
                              const SizedBox(height: 12),
                              StickyCtaBar(),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          // Mobile: horizontal sticky CTA bar at bottom (thumb zone, best practice)
          // Same scroll-hide behaviour as menu bar: hide when scrolling down, show when scrolling up
          if (isMobile)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: IgnorePointer(
                ignoring: !_menuVisible,
                child: AnimatedSlide(
                  offset: _menuVisible ? Offset.zero : const Offset(0, 1),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: AnimatedOpacity(
                    opacity: _menuVisible ? 1 : 0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: MobileStickyCtaBar(),
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
    );
  }
}

/// Limits the header overlay's hit test area so taps below [maxHitTestHeight] pass
/// through to the content underneath (e.g. hero buttons). Fixes mobile tap-through
/// when the header overlaps the hero section.
class _HeaderHitTestLimit extends SingleChildRenderObjectWidget {
  const _HeaderHitTestLimit({
    required this.maxHitTestHeight,
    required super.child,
  });

  final double maxHitTestHeight;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderHeaderHitTestLimit(maxHitTestHeight: maxHitTestHeight);
  }

  @override
  void updateRenderObject(BuildContext context, covariant RenderObject renderObject) {
    (renderObject as _RenderHeaderHitTestLimit).maxHitTestHeight = maxHitTestHeight;
  }
}

class _RenderHeaderHitTestLimit extends RenderProxyBox {
  _RenderHeaderHitTestLimit({required double maxHitTestHeight})
      : _maxHitTestHeight = maxHitTestHeight;

  double _maxHitTestHeight;

  double get maxHitTestHeight => _maxHitTestHeight;

  set maxHitTestHeight(double value) {
    if (_maxHitTestHeight == value) return;
    _maxHitTestHeight = value;
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (position.dy > _maxHitTestHeight) return false;
    return super.hitTest(result, position: position);
  }
}
