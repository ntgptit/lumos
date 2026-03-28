import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumos/core/theme/app_foundation.dart';
import 'package:lumos/core/theme/responsive/breakpoints.dart';
import 'package:lumos/core/theme/responsive/screen_class.dart';

void main() {
  group('Breakpoints and screen classes', () {
    test('bridge foundation breakpoints to responsive breakpoints', () {
      expect(Breakpoints.kMobileMaxWidth, AppBreakpoints.compactMaxWidth);
      expect(Breakpoints.kTabletMaxWidth, AppBreakpoints.expandedMaxWidth);
    });

    test('resolves screen classes at the configured width ranges', () {
      expect(ScreenClass.fromWidth(390), ScreenClass.compact);
      expect(ScreenClass.fromWidth(700), ScreenClass.medium);
      expect(ScreenClass.fromWidth(900), ScreenClass.expanded);
      expect(ScreenClass.fromWidth(1280), ScreenClass.large);
    });
  });

  testWidgets('device type context extension follows screen width', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    DeviceType? resolvedDeviceType;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            resolvedDeviceType = context.deviceType;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(resolvedDeviceType, DeviceType.mobile);

    tester.view.physicalSize = const Size(700, 844);
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            resolvedDeviceType = context.deviceType;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(resolvedDeviceType, DeviceType.tablet);

    tester.view.physicalSize = const Size(1280, 844);
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            resolvedDeviceType = context.deviceType;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(resolvedDeviceType, DeviceType.desktop);
  });

  testWidgets('compact value scales only on compact widths', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 800);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    var compactValue = 0.0;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            compactValue = ResponsiveDimensions.compactValue(
              context: context,
              baseValue: LumosSpacing.lg,
              minScale: ResponsiveDimensions.compactInsetScale,
            );
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(compactValue, lessThan(LumosSpacing.lg));

    tester.view.physicalSize = const Size(430, 800);
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            compactValue = ResponsiveDimensions.compactValue(
              context: context,
              baseValue: LumosSpacing.lg,
              minScale: ResponsiveDimensions.compactInsetScale,
            );
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(compactValue, LumosSpacing.lg);
  });
}
