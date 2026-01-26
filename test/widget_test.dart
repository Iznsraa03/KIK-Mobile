import 'package:flutter_test/flutter_test.dart';

import 'package:JELAJAH_KI_SULSEL/main.dart';

void main() {
  testWidgets('App builds smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const JelajahKiSulselApp());

    // Splash tampil dulu.
    expect(find.text('Jelajah KI Sulsel'), findsOneWidget);
  });
}
