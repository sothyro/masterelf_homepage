import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:masterelf_homepage/l10n/app_localizations.dart';

import 'package:masterelf_homepage/screens/home/widgets/hero_section.dart';

import 'package:masterelf_homepage/services/hero_video_platform.dart';

import 'package:masterelf_homepage/utils/mobile_web_performance.dart';



Widget _heroTestApp() {

  return MaterialApp(

    localizationsDelegates: AppLocalizations.localizationsDelegates,

    supportedLocales: AppLocalizations.supportedLocales,

    home: const Scaffold(

      body: HeroSection(),

    ),

  );

}



void main() {

  setUp(() {

    HeroVideoPlatform.resetForTesting();

    HeroVideoPlatform.prewarmOverrideForTesting = Future.value(false);

  });



  tearDown(HeroVideoPlatform.resetForTesting);



  testWidgets('hero section builds on mobile width with poster fallback', (tester) async {

    await tester.binding.setSurfaceSize(const Size(390, 844));

    addTearDown(() => tester.binding.setSurfaceSize(null));



    await tester.pumpWidget(_heroTestApp());

    await tester.pump();

    await tester.pump(const Duration(milliseconds: 100));



    expect(find.byType(HeroSection), findsOneWidget);

    expect(

      MobileWebPerformance.preferPosterOnlyHeroVideo(

        tester.element(find.byType(HeroSection)),

      ),

      isFalse,

    );

    expect(find.byType(Image), findsWidgets);

  });

}


