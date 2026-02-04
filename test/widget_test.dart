import 'package:flutter_test/flutter_test.dart';

import 'package:masterelf_homepage/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MasterElfApp());
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
  });
}
