import 'package:flutter_test/flutter_test.dart';

import 'package:flutter/widgets.dart';

void main() {
  testWidgets('Minimal root widget smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    expect(find.byType(SizedBox), findsOneWidget);
  });
}
