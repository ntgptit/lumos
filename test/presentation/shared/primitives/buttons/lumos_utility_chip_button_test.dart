import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumos/core/theme/app_theme.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/core/theme/responsive/screen_info.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_utility_chip_button.dart';

void main() {
  testWidgets('renders at control height and handles taps', (
    WidgetTester tester,
  ) async {
    bool pressed = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(
          screenInfo: ScreenInfo.fromSize(const Size(390, 844)),
        ),
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
              return Center(
                child: LumosUtilityChipButton(
                  key: const ValueKey<String>('utility-chip'),
                  label: 'Name A-Z',
                  leading: const Icon(Icons.sort_rounded),
                  trailing: const Icon(Icons.keyboard_arrow_down_rounded),
                  onPressed: () {
                    pressed = true;
                  },
                ),
              );
            },
          ),
        ),
      ),
    );

    final Size chipSize = tester.getSize(
      find.byKey(const ValueKey<String>('utility-chip')),
    );
    final BuildContext chipContext = tester.element(
      find.byKey(const ValueKey<String>('utility-chip')),
    );

    expect(chipSize.height, chipContext.component.buttonHeight);
    expect(find.text('Name A-Z'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey<String>('utility-chip')));
    await tester.pumpAndSettle();

    expect(pressed, isTrue);
  });
}
