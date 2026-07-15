import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masterelf_homepage/utils/scroll_activity_gate.dart';
import 'package:masterelf_homepage/widgets/app_footer.dart';
import 'package:masterelf_homepage/widgets/mobile_sticky_cta_bar.dart';

import 'test_helpers/pump_app.dart';

void setTestViewSize(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  testWidgets('short page pins footer to viewport bottom on desktop', (tester) async {
    setTestViewSize(tester, const Size(1280, 1400));
    await pumpMasterElfApp(tester, surfaceSize: const Size(1280, 1400));
    await navigateTo(tester, '/about');
    await tester.pump(const Duration(milliseconds: 800));

    final footer = tester.getRect(find.byType(AppFooter));
    final viewport = tester.getRect(find.byType(SingleChildScrollView).first);
    expect(footer.bottom, closeTo(viewport.bottom, 1));
    expect(tester.widget<AppFooter>(find.byType(AppFooter)).bottomInset, 0);
  });

  testWidgets('mobile footer uses safe-area bottom padding only', (tester) async {
    setTestViewSize(tester, const Size(375, 800));
    await pumpMasterElfApp(tester, surfaceSize: const Size(375, 800));
    await navigateTo(tester, '/about');
    await tester.pump(const Duration(milliseconds: 800));

    expect(find.byType(MobileStickyCtaBar), findsOneWidget);
    expect(
      tester.widget<AppFooter>(find.byType(AppFooter)).bottomInset,
      16,
    );

    final controller = tester.widget<Scrollable>(find.byType(Scrollable).first).controller!;
    controller.jumpTo(controller.position.maxScrollExtent);
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pump(ScrollActivityGate.idleDelay);
    ScrollActivityGate.resetForTesting();

    final footerRect = tester.getRect(find.byType(AppFooter));
    final viewportRect = tester.getRect(find.byType(SingleChildScrollView).first);
    expect(footerRect.bottom, closeTo(viewportRect.bottom, 1));
  });
}
