import 'package:flutter_test/flutter_test.dart';

import 'test_helpers/pump_app.dart';

void main() {
  for (final width in [375.0, 1280.0]) {
    testWidgets('About page has no overflow at ${width.toInt()}px', (tester) async {
      await pumpRouteAtWidth(tester, '/about', width);

      expect(find.text('About Master Elf.'), findsOneWidget);
      expect(find.text('About'), findsWidgets);
    });
  }
}
