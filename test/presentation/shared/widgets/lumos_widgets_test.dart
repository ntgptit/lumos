import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumos/core/theme/app_theme.dart';
import 'package:lumos/core/theme/responsive/screen_info.dart';
import 'package:lumos/presentation/shared/composites/states/lumos_empty_state.dart';
import 'package:lumos/presentation/shared/composites/states/lumos_error_state.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_button.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_card.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_progress_bar.dart';
import 'package:lumos/presentation/shared/primitives/inputs/lumos_text_field.dart';
import 'package:lumos/presentation/shared/primitives/text/lumos_text.dart';

void main() {
  testWidgets('LumosButton shows loader and disables press while loading', (
    WidgetTester tester,
  ) async {
    var tapped = false;

    await tester.pumpWidget(
      _TestApp(
        child: LumosButton.primary(
          text: 'Submit',
          isLoading: true,
          onPressed: () {
            tapped = true;
          },
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.tap(find.byType(FilledButton));
    await tester.pump();
    expect(tapped, isFalse);
  });

  testWidgets('LumosCard handles tap callback', (WidgetTester tester) async {
    var tapped = false;

    await tester.pumpWidget(
      _TestApp(
        child: LumosCard(
          onTap: () {
            tapped = true;
          },
          child: const Text('Card'),
        ),
      ),
    );

    await tester.tap(find.text('Card'));
    await tester.pumpAndSettle();

    expect(tapped, isTrue);
  });

  testWidgets('LumosEmptyState renders action button when callback exists', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const _TestApp(
        child: LumosEmptyState(
          title: 'Empty',
          message: 'No data',
          buttonLabel: 'Reload',
          onButtonPressed: _noop,
        ),
      ),
    );

    expect(find.text('Empty'), findsOneWidget);
    expect(find.text('No data'), findsOneWidget);
    expect(find.text('Reload'), findsOneWidget);
  });

  testWidgets('LumosErrorState renders provided labels and retry action', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const _TestApp(
        child: LumosErrorState(
          title: 'Oops',
          errorMessage: 'Request failed',
          retryLabel: 'Retry now',
          onRetry: _noop,
        ),
      ),
    );

    expect(find.text('Oops'), findsOneWidget);
    expect(find.text('Request failed'), findsOneWidget);
    expect(find.text('Retry now'), findsOneWidget);
  });

  testWidgets('LumosProgressBar forwards value and height', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const _TestApp(
        child: LumosProgressBar(value: 0.7, height: 6),
      ),
    );

    final LinearProgressIndicator progressIndicator = tester.widget(
      find.byType(LinearProgressIndicator),
    );
    expect(progressIndicator.value, 0.7);
    expect(progressIndicator.minHeight, 6);
  });

  testWidgets('LumosText resolves a themed text style', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const _TestApp(
        child: LumosText(
          'Headline',
          style: LumosTextStyle.headlineMedium,
        ),
      ),
    );

    final Text textWidget = tester.widget(find.text('Headline'));
    expect(textWidget.style, isNotNull);
    expect(textWidget.style!.fontSize, greaterThan(0));
  });

  testWidgets('LumosTextField uses the theme body medium text size', (
    WidgetTester tester,
  ) async {
    const Size size = Size(390, 844);
    final ThemeData theme = AppTheme.light(
      screenInfo: ScreenInfo.fromSize(size),
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        home: const Scaffold(
          body: LumosTextField(initialValue: 'typed value'),
        ),
      ),
    );

    final EditableText editableText = tester.widget(find.byType(EditableText));
    expect(
      editableText.style.fontSize,
      theme.textTheme.bodyMedium?.fontSize,
    );
  });
}

void _noop() {}

class _TestApp extends StatelessWidget {
  const _TestApp({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    const Size size = Size(390, 844);
    return MaterialApp(
      theme: AppTheme.light(screenInfo: ScreenInfo.fromSize(size)),
      home: Scaffold(body: child),
    );
  }
}
