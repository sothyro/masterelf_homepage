import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:masterelf_homepage/utils/mobile_web_performance.dart';



void main() {

  testWidgets('devicePixelCacheWidth clamps to safe range', (tester) async {

    await tester.pumpWidget(

      MediaQuery(

        data: const MediaQueryData(size: Size(400, 800), devicePixelRatio: 3),

        child: Builder(

          builder: (context) {

            final width = MobileWebPerformance.devicePixelCacheWidth(context, 400);

            expect(width, 1200);

            return const SizedBox.shrink();

          },

        ),

      ),

    );

  });



  test('shouldPrewarmHeroVideo follows kIsWeb', () {

    // VM tests are not kIsWeb.

    expect(MobileWebPerformance.shouldPrewarmHeroVideo(), isFalse);

  });



  testWidgets('preferPosterOnlyHeroVideo is always false', (tester) async {

    await tester.binding.setSurfaceSize(const Size(390, 800));

    addTearDown(() => tester.binding.setSurfaceSize(null));



    await tester.pumpWidget(

      MaterialApp(

        home: Builder(

          builder: (context) {

            expect(MobileWebPerformance.preferPosterOnlyHeroVideo(context), isFalse);

            return const SizedBox.shrink();

          },

        ),

      ),

    );

  });

  testWidgets('mockup cache returns null off web for native full decode', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            expect(
              MobileWebPerformance.mockupPixelCacheWidth(context, 400),
              isNull,
            );
            expect(
              MobileWebPerformance.mockupFilterQuality(context),
              FilterQuality.high,
            );
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  });
}
