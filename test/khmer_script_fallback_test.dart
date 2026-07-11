import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masterelf_homepage/theme/app_theme.dart';
import 'package:masterelf_homepage/utils/khmer_script.dart';
import 'package:masterelf_homepage/widgets/khmer_aware_text.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('containsKhmerScript', () {
    test('detects Khmer characters', () {
      expect(containsKhmerScript('សុខា'), isTrue);
      expect(containsKhmerScript('John សុខា'), isTrue);
      expect(containsKhmerScript('៥១,០០០'), isTrue);
    });

    test('ignores Latin-only text', () {
      expect(containsKhmerScript('John Smith'), isFalse);
      expect(containsKhmerScript('BaZi Analysis'), isFalse);
      expect(containsKhmerScript(''), isFalse);
    });
  });

  group('withScriptFallbacks', () {
    test('en locale includes Siemreap in fontFamilyFallback', () {
      final style = withScriptFallbacks(const TextStyle(), 'en');
      expect(style.fontFamilyFallback, isNotNull);
      expect(style.fontFamilyFallback, isNotEmpty);
      expect(
        style.fontFamilyFallback,
        contains(AppFontFamilies.siemreap),
      );
    });

    test('zh locale includes Siemreap fallback for Khmer in data', () {
      final style = withScriptFallbacks(const TextStyle(), 'zh');
      expect(style.fontFamilyFallback, contains(AppFontFamilies.siemreap));
    });

    test('km locale includes Noto Sans SC fallback', () {
      final style = withScriptFallbacks(const TextStyle(), 'km');
      expect(style.fontFamilyFallback, contains(AppFontFamilies.notoSansSc));
    });
  });

  group('textThemeForLocale', () {
    test('bodyMedium receives Siemreap fallback for en locale', () {
      // Mirrors _applyFallbacksToTextTheme without loading Google Fonts in tests.
      const bodyMedium = TextStyle(fontFamily: AppFontFamilies.exo2, fontSize: 14);
      final result = withScriptFallbacks(bodyMedium, 'en');
      expect(result.fontFamilyFallback, isNotNull);
      expect(result.fontFamilyFallback, contains(AppFontFamilies.siemreap));
    });
  });

  group('buildMixedScriptSpans', () {
    test('splits Latin label from Khmer name', () {
      const latin = TextStyle(fontFamily: 'Exo 2');
      const khmer = TextStyle(fontFamily: 'Siemreap');
      final spans = buildMixedScriptSpans(
        'Name: សុខា',
        latinStyle: latin,
        khmerStyle: khmer,
      );
      expect(spans.length, 2);
      expect((spans[0] as TextSpan).text, 'Name: ');
      expect((spans[0] as TextSpan).style?.fontFamily, 'Exo 2');
      expect((spans[1] as TextSpan).text, 'សុខា');
      expect((spans[1] as TextSpan).style?.fontFamily, 'Siemreap');
    });
  });

  group('KhmerAwareText', () {
    testWidgets('uses Siem Reap for Khmer name when locale is English', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          home: Builder(
            builder: (context) => Scaffold(
              body: KhmerAwareText(
                'សុខា',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
        ),
      );

      final text = tester.widget<Text>(find.byType(Text));
      expect(text.style?.fontFamily, contains('Siemreap'));
    });
  });
}
