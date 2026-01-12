import 'package:flutter_test/flutter_test.dart';

import 'package:kik_mobile/main.dart';

void main() {
  testWidgets('App builds smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const JelajahKiSulselApp());

    // Splash tampil dulu.
    expect(find.text('Jelajah KI Sulsel'), findsOneWidget);
  });
}
