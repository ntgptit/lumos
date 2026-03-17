import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumos/core/themes/builders/app_adaptive_theme_builder.dart';
import 'package:lumos/core/themes/builders/app_component_theme_builder.dart';
import 'package:lumos/core/themes/component/app_button_tokens.dart';
import 'package:lumos/core/themes/component/app_card_tokens.dart';
import 'package:lumos/core/themes/component/app_dialog_tokens.dart';
import 'package:lumos/core/themes/component/app_input_tokens.dart';
import 'package:lumos/core/themes/component/app_navigation_bar_tokens.dart';
import 'package:lumos/core/themes/component/app_theme_contract_tokens.dart';
import 'package:lumos/core/themes/foundation/app_foundation.dart';
import 'package:lumos/core/themes/foundation/app_responsive.dart';
import 'package:lumos/core/themes/semantic/app_color_tokens.dart';
import 'package:lumos/core/themes/semantic/app_text_tokens.dart';
import 'package:lumos/presentation/shared/widgets/lumos_widgets.dart';

void main() {
  testWidgets('LumosButton shows loader and disables press while loading', (
    WidgetTester tester,
  ) async {
    bool tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LumosButton(
            label: 'Submit',
            isLoading: true,
            onPressed: () {
              tapped = true;
            },
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.tap(find.byType(LumosButton));
    await tester.pump();
    expect(tapped, isFalse);
  });

  testWidgets('LumosCard handles tap callback', (WidgetTester tester) async {
    bool tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LumosCard(
            onTap: () {
              tapped = true;
            },
            child: const Text('Card'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Card'));
    await tester.pump();
    expect(tapped, isTrue);
  });

  testWidgets('LumosEmptyState renders action button when callback exists', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LumosEmptyState(
            title: 'Empty',
            message: 'No data',
            buttonLabel: 'Reload',
            onButtonPressed: _noop,
          ),
        ),
      ),
    );

    expect(find.text('Empty'), findsOneWidget);
    expect(find.text('No data'), findsOneWidget);
    expect(find.text('Reload'), findsOneWidget);
  });

  testWidgets('LumosErrorState renders default title and retry label', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LumosErrorState(errorMessage: 'Request failed', onRetry: _noop),
        ),
      ),
    );

    expect(find.text(LumosErrorStateConst.defaultTitle), findsOneWidget);
    expect(find.text(LumosErrorStateConst.defaultRetryLabel), findsOneWidget);
  });

  testWidgets('LumosProgressBar clamps value into valid range', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: LumosProgressBar(value: 2))),
    );

    final LinearProgressIndicator progressIndicator = tester.widget(
      find.byType(LinearProgressIndicator),
    );
    expect(progressIndicator.value, 1);
  });

  testWidgets('LumosText resolves style from text theme', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LumosText('Headline', style: LumosTextStyle.headlineSmall),
        ),
      ),
    );

    final Text textWidget = tester.widget(find.text('Headline'));
    expect(textWidget.style, isNotNull);
  });

  testWidgets('LumosCard default padding follows adaptive card tokens', (
    WidgetTester tester,
  ) async {
    final ThemeData compactTheme = _buildCompactTheme();

    await tester.pumpWidget(
      MaterialApp(
        theme: compactTheme,
        home: const Scaffold(
          body: LumosCard(child: Text('Adaptive card content')),
        ),
      ),
    );

    final Padding paddingWidget = tester.widget(
      find
          .ancestor(
            of: find.text('Adaptive card content'),
            matching: find.byType(Padding),
          )
          .first,
    );

    expect(
      (paddingWidget.padding as EdgeInsets).left,
      compactTheme.extension<AppCardTokens>()!.paddingLg.left,
    );
  });

  testWidgets('LumosTextField defaults to adapted bodyMedium style', (
    WidgetTester tester,
  ) async {
    final ThemeData compactTheme = _buildCompactTheme();

    await tester.pumpWidget(
      MaterialApp(
        theme: compactTheme,
        home: const Scaffold(body: LumosTextField(initialValue: 'typed value')),
      ),
    );

    final EditableText textField = tester.widget(find.byType(EditableText));
    expect(
      textField.style.fontSize,
      compactTheme.textTheme.bodyMedium?.fontSize,
    );
  });
}

void _noop() {}

ThemeData _buildCompactTheme() {
  final ColorScheme colorScheme = ColorScheme.fromSeed(seedColor: Colors.blue);
  final ThemeData seedTheme = ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
  );
  final TextTheme textTheme = seedTheme.textTheme.copyWith(
    headlineMedium: _ensureFontSize(seedTheme.textTheme.headlineMedium, 28),
    titleLarge: _ensureFontSize(seedTheme.textTheme.titleLarge, 22),
    titleSmall: _ensureFontSize(seedTheme.textTheme.titleSmall, 14),
    bodyMedium: _ensureFontSize(seedTheme.textTheme.bodyMedium, 14),
    labelMedium: _ensureFontSize(seedTheme.textTheme.labelMedium, 12),
  );
  final ThemeData baseTheme = seedTheme.copyWith(
    textTheme: textTheme,
    primaryTextTheme: textTheme,
    extensions: <ThemeExtension<dynamic>>[
      AppThemeContractTokens.defaults,
      AppColorTokens.fromColorScheme(colorScheme: colorScheme),
      AppTextTokens.fromTheme(colorScheme: colorScheme, textTheme: textTheme),
      AppButtonTokens.defaults,
      AppInputTokens.defaults,
      AppCardTokens.defaults,
      AppDialogTokens.defaults,
      AppNavigationBarTokens.defaults,
    ],
  );
  final ThemeData resolvedTheme = AppComponentThemeBuilder.apply(
    baseTheme: baseTheme,
    colorScheme: colorScheme,
    textTheme: textTheme,
  );
  return AppAdaptiveThemeBuilder.adapt(
    theme: resolvedTheme,
    screenWidth:
        ResponsiveDimensions.minScaleFactor *
        ResponsiveDimensions.baseDesignWidth,
  );
}

TextStyle _ensureFontSize(TextStyle? style, double fontSize) {
  return (style ?? const TextStyle()).copyWith(fontSize: fontSize);
}
