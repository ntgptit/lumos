import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumos/core/constants/dimensions.dart';
import 'package:lumos/presentation/features/home/screens/home_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('renders mobile layout at mobile width', (
    WidgetTester tester,
  ) async {
    await _pumpHomeWithSize(
      tester: tester,
      logicalSize: const Size(Breakpoints.kMobileMaxWidth, 800),
    );

    expect(find.byKey(HomeScreenKeys.mobileLayout), findsOneWidget);
    expect(find.byKey(HomeScreenKeys.tabletLayout), findsNothing);
    expect(find.byKey(HomeScreenKeys.desktopLayout), findsNothing);
  });

  testWidgets('renders tablet layout above mobile breakpoint', (
    WidgetTester tester,
  ) async {
    await _pumpHomeWithSize(
      tester: tester,
      logicalSize: const Size(
        Breakpoints.kMobileMaxWidth + Insets.spacing4,
        900,
      ),
    );

    expect(find.byKey(HomeScreenKeys.mobileLayout), findsNothing);
    expect(find.byKey(HomeScreenKeys.tabletLayout), findsOneWidget);
    expect(find.byKey(HomeScreenKeys.desktopLayout), findsNothing);
  });

  testWidgets('renders desktop layout above tablet breakpoint', (
    WidgetTester tester,
  ) async {
    await _pumpHomeWithSize(
      tester: tester,
      logicalSize: const Size(
        Breakpoints.kTabletMaxWidth + Insets.spacing4,
        1000,
      ),
    );

    expect(find.byKey(HomeScreenKeys.mobileLayout), findsNothing);
    expect(find.byKey(HomeScreenKeys.tabletLayout), findsNothing);
    expect(find.byKey(HomeScreenKeys.desktopLayout), findsOneWidget);
  });

  testWidgets('renders semantic cards and safe area', (
    WidgetTester tester,
  ) async {
    await _pumpHomeWithSize(tester: tester, logicalSize: const Size(390, 844));

    expect(find.byType(SafeArea), findsWidgets);
    expect(find.bySemanticsLabel(HomeScreenSemantics.heroCard), findsOneWidget);
    expect(
      find.bySemanticsLabel(HomeScreenSemantics.sectionCard),
      findsOneWidget,
    );
  });
}

Future<void> _pumpHomeWithSize({
  required WidgetTester tester,
  required Size logicalSize,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = logicalSize;
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);

  await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
  await tester.pumpAndSettle();
}
