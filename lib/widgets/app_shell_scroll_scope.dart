import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../config/store_routes.dart';

/// Exposes the [AppShell] scroll controller so pages can scroll to anchored sections.
class AppShellScrollScope extends InheritedWidget {
  const AppShellScrollScope({
    super.key,
    required this.scrollController,
    required super.child,
  });

  final ScrollController scrollController;

  static AppShellScrollScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppShellScrollScope>();
  }

  static ScrollController? scrollControllerOf(BuildContext context) {
    return maybeOf(context)?.scrollController;
  }

  @override
  bool updateShouldNotify(AppShellScrollScope oldWidget) {
    return scrollController != oldWidget.scrollController;
  }
}

/// Scrolls [key]'s context into view within the shell [SingleChildScrollView].
void ensureShellSectionVisible(
  BuildContext context,
  GlobalKey key, {
  double alignment = 0.15,
  Duration duration = const Duration(milliseconds: 400),
  Curve curve = Curves.easeInOut,
}) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!context.mounted) return;
    final targetContext = key.currentContext;
    if (targetContext == null) return;

    Scrollable.ensureVisible(
      targetContext,
      duration: duration,
      curve: curve,
      alignment: alignment,
    );
  });
}

/// Jumps the shell scroll view back to the top (e.g. when opening a store page).
void resetShellScrollToTop(BuildContext context) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!context.mounted) return;
    final controller = AppShellScrollScope.scrollControllerOf(context);
    if (controller != null && controller.hasClients) {
      controller.jumpTo(0);
    }
  });
}

/// Navigates within the shell and resets scroll unless [location] is a deep link.
void goShellRoute(BuildContext context, String location) {
  final uri = Uri.parse('http://local${location.startsWith('/') ? location : '/$location'}');
  context.go(location);
  if (!routeRequestsSectionScroll(uri)) {
    resetShellScrollToTop(context);
  }
}
