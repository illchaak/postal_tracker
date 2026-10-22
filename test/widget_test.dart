import 'package:flutter_test/flutter_test.dart';

import 'package:postal_tracker/app/app.dart';

void main() {
  testWidgets('Застосунок відкривається з екрана входу', (tester) async {
    await tester.pumpWidget(const PostalTrackerApp());

    expect(find.text('Трекер поштових відправлень'), findsOneWidget);
    expect(find.text('Увійти'), findsOneWidget);
  });
}
