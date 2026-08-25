import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masterelf_homepage/screens/home/home_section_mount_queue.dart';
import 'package:masterelf_homepage/screens/home/widgets/home_queued_section.dart';
import 'package:masterelf_homepage/theme/app_theme.dart';
import 'package:masterelf_homepage/utils/app_asset_preloader.dart';
import 'package:masterelf_homepage/utils/scroll_activity_gate.dart';
import 'package:visibility_detector/visibility_detector.dart';

void main() {
  setUp(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
    ScrollActivityGate.resetForTesting();
    HomeSectionMountQueue.resetForTesting();
    AppAssetPreloader.resetForTesting();
    AppAssetPreloader.disableBackgroundFontsForTesting = true;
  });

  tearDown(() {
    VisibilityDetectorController.instance.updateInterval =
        const Duration(milliseconds: 500);
    HomeSectionMountQueue.resetForTesting();
    ScrollActivityGate.resetForTesting();
  });

  Future<void> pumpQueuedColumn(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark(),
        home: Scaffold(
          backgroundColor: AppColors.backgroundDark,
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Keep queued slots below the fold so visibility does not auto-boost.
                const SizedBox(height: 1200),
                HomeQueuedSection(
                  sectionKey: 'home-academies',
                  placeholderHeight: 200,
                  child: const Text('academies'),
                ),
                HomeQueuedSection(
                  sectionKey: 'home-consultations',
                  placeholderHeight: 200,
                  child: const Text('consultations'),
                ),
                HomeQueuedSection(
                  sectionKey: 'home-field-work-story',
                  placeholderHeight: 200,
                  child: const Text('field-work'),
                ),
                HomeQueuedSection(
                  sectionKey: 'home-featured-band',
                  placeholderHeight: 200,
                  child: const Text('featured'),
                ),
                HomeQueuedSection(
                  sectionKey: 'home-activity-stories',
                  placeholderHeight: 200,
                  child: const Text('stories'),
                ),
                HomeQueuedSection(
                  sectionKey: 'home-testimonials',
                  placeholderHeight: 200,
                  child: const Text('testimonials'),
                ),
                HomeQueuedSection(
                  sectionKey: 'home-cta',
                  placeholderHeight: 200,
                  child: const Text('cta'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('idle queue mounts sections in document order without visibility', (
    tester,
  ) async {
    await pumpQueuedColumn(tester);
    HomeSectionMountQueue.instance.armAfterCriticalReady();

    expect(find.text('academies'), findsNothing);

    await tester.pump(HomeSectionMountQueue.firstAdvanceDelay);
    await tester.pump();
    expect(find.text('academies'), findsOneWidget);
    expect(find.text('consultations'), findsNothing);

    await tester.pump(HomeSectionMountQueue.betweenSectionsDelay);
    await tester.pump();
    expect(find.text('consultations'), findsOneWidget);
    expect(find.text('field-work'), findsNothing);

    await tester.pump(HomeSectionMountQueue.betweenSectionsDelay);
    await tester.pump();
    expect(find.text('field-work'), findsOneWidget);
    HomeSectionMountQueue.resetForTesting();
  });

  testWidgets('queue pauses while scrolling and resumes on idle', (tester) async {
    await pumpQueuedColumn(tester);
    HomeSectionMountQueue.instance.armAfterCriticalReady();

    ScrollActivityGate.onScrollOffset(10);
    await tester.pump(HomeSectionMountQueue.firstAdvanceDelay);
    await tester.pump();
    expect(find.text('academies'), findsNothing);

    for (var i = 0; i < 5; i++) {
      ScrollActivityGate.onScrollOffset(20.0 + i * 10);
      await tester.pump(const Duration(milliseconds: 80));
    }
    expect(find.text('academies'), findsNothing);

    await tester.pump(ScrollActivityGate.idleDelay);
    await tester.pump();
    expect(find.text('academies'), findsOneWidget);
    HomeSectionMountQueue.resetForTesting();
  });

  testWidgets('boost mounts a later section next then continues order', (
    tester,
  ) async {
    await pumpQueuedColumn(tester);
    HomeSectionMountQueue.instance.armAfterCriticalReady();

    HomeSectionMountQueue.instance.requestBoost('home-cta');
    await tester.pump();
    expect(find.text('cta'), findsNothing);

    await tester.pump(HomeSectionMountQueue.betweenSectionsDelay);
    await tester.pump();
    expect(find.text('cta'), findsOneWidget);
    expect(find.text('academies'), findsNothing);

    await tester.pump(HomeSectionMountQueue.betweenSectionsDelay);
    await tester.pump();
    expect(find.text('academies'), findsOneWidget);
    HomeSectionMountQueue.resetForTesting();
  });

  testWidgets('placeholder uses scaffold background color', (tester) async {
    await pumpQueuedColumn(tester);
    final colored = tester.widgetList<ColoredBox>(find.byType(ColoredBox));
    expect(colored.any((c) => c.color == AppColors.backgroundDark), isTrue);
    HomeSectionMountQueue.resetForTesting();
  });
}
