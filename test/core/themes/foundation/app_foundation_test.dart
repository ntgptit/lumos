import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumos/core/themes/foundation/app_foundation.dart';

void main() {
  group('DeviceTypeHelper', () {
    test('returns mobile for widths up to mobile breakpoint', () {
      final DeviceType result = DeviceTypeHelper.fromWidth(
        width: Breakpoints.kMobileMaxWidth,
      );

      expect(result, DeviceType.mobile);
    });

    test('returns tablet between mobile and tablet breakpoints', () {
      final DeviceType result = DeviceTypeHelper.fromWidth(
        width: Breakpoints.kMobileMaxWidth + AppSpacing.xs,
      );

      expect(result, DeviceType.tablet);
    });

    test('returns desktop above tablet breakpoint', () {
      final DeviceType result = DeviceTypeHelper.fromWidth(
        width: Breakpoints.kTabletMaxWidth + AppSpacing.xs,
      );

      expect(result, DeviceType.desktop);
    });
  });

  testWidgets('percent dimension extensions compute expected size', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(400, 800);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    double widthValue = AppSpacing.none;
    double heightValue = AppSpacing.none;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            widthValue = 0.5.percentWidth(context);
            heightValue = 0.25.percentHeight(context);
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(widthValue, 200);
    expect(heightValue, 200);
  });

  test('screen percentage helper fails fast for invalid input', () {
    expect(
      () => ResponsiveDimensions.screenWidthPercentage(
        context: _FakeBuildContext(),
        percentage: 1.1,
      ),
      throwsArgumentError,
    );
  });
}

class _FakeBuildContext implements BuildContext {
  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}
