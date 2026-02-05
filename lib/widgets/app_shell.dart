import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'app_header.dart';
import 'app_footer.dart';
import 'app_drawer.dart';
import 'sticky_cta_bar.dart';

/// Wraps each route with persistent header and footer (Joey Yap–style layout).
class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _showBackToTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final show = _scrollController.hasClients && _scrollController.offset > 400;
    if (show != _showBackToTop) setState(() => _showBackToTop = show);
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
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.backgroundDark,
      drawer: const AppDrawer(),
      floatingActionButton: _showBackToTop
          ? Padding(
              padding: const EdgeInsets.only(bottom: 60),
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
                  child: const Icon(Icons.keyboard_arrow_up),
                ),
              ),
            )
          : null,
      body: Stack(
        children: [
          Semantics(
            container: true,
            label: 'Main content',
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  widget.child,
                  Semantics(
                    container: true,
                    label: 'Footer',
                    child: const AppFooter(),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: AppHeader(
                  onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 160,
            bottom: 100,
            child: SafeArea(
              left: false,
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 0),
                  child: StickyCtaBar(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
