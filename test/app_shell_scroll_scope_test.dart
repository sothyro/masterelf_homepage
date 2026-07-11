import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masterelf_homepage/widgets/app_shell_scroll_scope.dart';

void main() {
  testWidgets('ensureShellSectionVisible completes without layout errors', (tester) async {
    final scrollController = ScrollController();
    final sectionKey = GlobalKey();

    await tester.pumpWidget(
      MaterialApp(
        home: SizedBox(
          height: 600,
          width: 400,
          child: AppShellScrollScope(
            scrollController: scrollController,
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
                  const SizedBox(height: 1200),
                  SizedBox(
                    key: sectionKey,
                    height: 200,
                    width: double.infinity,
                    child: const ColoredBox(color: Colors.blue),
                  ),
                  const SizedBox(height: 1200),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(scrollController.position.maxScrollExtent, greaterThan(800));

    ensureShellSectionVisible(
      tester.element(find.byType(AppShellScrollScope)),
      sectionKey,
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
