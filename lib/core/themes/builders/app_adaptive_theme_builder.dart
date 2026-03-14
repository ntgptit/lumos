import 'package:flutter/material.dart';

import '../component/app_button_tokens.dart';
import '../component/app_card_tokens.dart';
import '../component/app_dialog_tokens.dart';
import '../component/app_input_tokens.dart';
import '../component/app_navigation_bar_tokens.dart';
import '../component/app_theme_contract_tokens.dart';
import '../foundation/app_foundation.dart';
import '../semantic/app_color_tokens.dart';
import '../semantic/app_text_tokens.dart';
import 'app_component_theme_builder.dart';

abstract final class AppAdaptiveThemeConst {
  AppAdaptiveThemeConst._();

  static const double baseCompactWidth = ResponsiveDimensions.baseDesignWidth;
  static const double minimumComponentScale = 0.88;
  static const double minimumDisplayScale = 0.9;
  static const double minimumHeadlineScale = 0.92;
  static const double minimumBodyScale = 0.95;
  static const double minimumRadiusScale = 0.94;
  static const double maximumScale = 1.0;
  static const double maximumCompactDensity = -1.0;
}

final class AppAdaptiveThemeBuilder {
  static ThemeData adapt({
    required ThemeData theme,
    required double screenWidth,
  }) {
    final double componentScale = _resolveScale(
      screenWidth: screenWidth,
      minimumScale: AppAdaptiveThemeConst.minimumComponentScale,
    );
    if (componentScale >= AppAdaptiveThemeConst.maximumScale) {
      return theme;
    }
    final TextTheme textTheme = _scaleTextTheme(
      theme.textTheme,
      screenWidth: screenWidth,
    );
    final TextTheme primaryTextTheme = _scaleTextTheme(
      theme.primaryTextTheme,
      screenWidth: screenWidth,
    );
    final ThemeData adaptedTheme = theme.copyWith(
      textTheme: textTheme,
      primaryTextTheme: primaryTextTheme,
      visualDensity: _resolveVisualDensity(componentScale: componentScale),
      extensions: _buildExtensions(
        theme: theme,
        textTheme: textTheme,
        componentScale: componentScale,
      ),
    );
    final ThemeData componentTheme = AppComponentThemeBuilder.apply(
      baseTheme: adaptedTheme,
      colorScheme: adaptedTheme.colorScheme,
      textTheme: textTheme,
    );
    return _applyCompactSurfaceAdjustments(
      theme: componentTheme,
      componentScale: componentScale,
      textTheme: textTheme,
    );
  }

  static ThemeData _applyCompactSurfaceAdjustments({
    required ThemeData theme,
    required double componentScale,
    required TextTheme textTheme,
  }) {
    final double spacingScale = _resolveScale(
      screenWidth: AppAdaptiveThemeConst.baseCompactWidth * componentScale,
      minimumScale: AppAdaptiveThemeConst.minimumComponentScale,
    );
    return theme.copyWith(
      appBarTheme: theme.appBarTheme.copyWith(
        toolbarHeight: WidgetSizes.appBarHeight * spacingScale,
      ),
      dividerTheme: theme.dividerTheme.copyWith(
        space: AppSpacing.lg * spacingScale,
      ),
      searchBarTheme: theme.searchBarTheme.copyWith(
        constraints: BoxConstraints(
          minHeight: WidgetSizes.minTouchTarget * spacingScale,
        ),
        padding: WidgetStatePropertyAll<EdgeInsets>(
          EdgeInsets.symmetric(horizontal: AppSpacing.md * spacingScale),
        ),
        textStyle: WidgetStatePropertyAll<TextStyle?>(textTheme.bodyMedium),
        hintStyle: WidgetStatePropertyAll<TextStyle?>(
          textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
      listTileTheme: theme.listTileTheme.copyWith(
        minLeadingWidth: IconSizes.iconLarge * spacingScale,
        minVerticalPadding: AppSpacing.sm * spacingScale,
      ),
      chipTheme: theme.chipTheme.copyWith(
        labelStyle: textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.onSurface,
        ),
        secondaryLabelStyle: textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.onSecondaryContainer,
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: theme.segmentedButtonTheme.style?.copyWith(
          textStyle: WidgetStatePropertyAll<TextStyle?>(
            textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(
              horizontal: AppSpacing.lg * spacingScale,
              vertical: AppSpacing.sm * spacingScale,
            ),
          ),
        ),
      ),
    );
  }

  static List<ThemeExtension<dynamic>> _buildExtensions({
    required ThemeData theme,
    required TextTheme textTheme,
    required double componentScale,
  }) {
    final double radiusScale = _radiusScale(componentScale: componentScale);
    final AppButtonTokens buttonTokens =
        theme.extension<AppButtonTokens>() ?? AppButtonTokens.defaults;
    final AppInputTokens inputTokens =
        theme.extension<AppInputTokens>() ?? AppInputTokens.defaults;
    final AppCardTokens cardTokens =
        theme.extension<AppCardTokens>() ?? AppCardTokens.defaults;
    final AppDialogTokens dialogTokens =
        theme.extension<AppDialogTokens>() ?? AppDialogTokens.defaults;
    final AppNavigationBarTokens navigationBarTokens =
        theme.extension<AppNavigationBarTokens>() ??
        AppNavigationBarTokens.defaults;
    return <ThemeExtension<dynamic>>[
      theme.extension<AppThemeContractTokens>() ??
          AppThemeContractTokens.defaults,
      AppColorTokens.fromColorScheme(colorScheme: theme.colorScheme),
      AppTextTokens.fromTheme(
        colorScheme: theme.colorScheme,
        textTheme: textTheme,
      ),
      buttonTokens.copyWith(
        heightSm: buttonTokens.heightSm * componentScale,
        heightMd: buttonTokens.heightMd * componentScale,
        heightLg: buttonTokens.heightLg * componentScale,
        paddingSm: _scaleEdgeInsets(buttonTokens.paddingSm, componentScale),
        paddingMd: _scaleEdgeInsets(buttonTokens.paddingMd, componentScale),
        paddingLg: _scaleEdgeInsets(buttonTokens.paddingLg, componentScale),
        radiusSm: buttonTokens.radiusSm * radiusScale,
        radiusMd: buttonTokens.radiusMd * radiusScale,
        radiusLg: buttonTokens.radiusLg * radiusScale,
        iconSizeSm: buttonTokens.iconSizeSm * componentScale,
        iconSizeMd: buttonTokens.iconSizeMd * componentScale,
        iconSizeLg: buttonTokens.iconSizeLg * componentScale,
      ),
      inputTokens.copyWith(
        minHeight: inputTokens.minHeight * componentScale,
        contentPadding: _scaleEdgeInsets(
          inputTokens.contentPadding,
          componentScale,
        ),
        borderRadius: inputTokens.borderRadius * radiusScale,
        iconSize: inputTokens.iconSize * componentScale,
        labelGap: inputTokens.labelGap * componentScale,
      ),
      cardTokens.copyWith(
        paddingSm: _scaleEdgeInsets(cardTokens.paddingSm, componentScale),
        paddingMd: _scaleEdgeInsets(cardTokens.paddingMd, componentScale),
        paddingLg: _scaleEdgeInsets(cardTokens.paddingLg, componentScale),
        radius: cardTokens.radius * radiusScale,
      ),
      dialogTokens.copyWith(
        insetPaddingMobile: _scaleEdgeInsets(
          dialogTokens.insetPaddingMobile,
          componentScale,
        ),
        radius: dialogTokens.radius * radiusScale,
      ),
      navigationBarTokens.copyWith(
        height: navigationBarTokens.height * componentScale,
        iconSize: navigationBarTokens.iconSize * componentScale,
        indicatorRadius: navigationBarTokens.indicatorRadius * radiusScale,
        labelPadding: _scaleEdgeInsets(
          navigationBarTokens.labelPadding,
          componentScale,
        ),
      ),
    ];
  }

  static TextTheme _scaleTextTheme(
    TextTheme textTheme, {
    required double screenWidth,
  }) {
    final double displayScale = _resolveScale(
      screenWidth: screenWidth,
      minimumScale: AppAdaptiveThemeConst.minimumDisplayScale,
    );
    final double headlineScale = _resolveScale(
      screenWidth: screenWidth,
      minimumScale: AppAdaptiveThemeConst.minimumHeadlineScale,
    );
    final double bodyScale = _resolveScale(
      screenWidth: screenWidth,
      minimumScale: AppAdaptiveThemeConst.minimumBodyScale,
    );
    return textTheme.copyWith(
      displayLarge: _scaleTextStyle(textTheme.displayLarge, displayScale),
      displayMedium: _scaleTextStyle(textTheme.displayMedium, displayScale),
      displaySmall: _scaleTextStyle(textTheme.displaySmall, displayScale),
      headlineLarge: _scaleTextStyle(textTheme.headlineLarge, headlineScale),
      headlineMedium: _scaleTextStyle(textTheme.headlineMedium, headlineScale),
      headlineSmall: _scaleTextStyle(textTheme.headlineSmall, headlineScale),
      titleLarge: _scaleTextStyle(textTheme.titleLarge, headlineScale),
      titleMedium: _scaleTextStyle(textTheme.titleMedium, bodyScale),
      titleSmall: _scaleTextStyle(textTheme.titleSmall, bodyScale),
      bodyLarge: _scaleTextStyle(textTheme.bodyLarge, bodyScale),
      bodyMedium: _scaleTextStyle(textTheme.bodyMedium, bodyScale),
      bodySmall: _scaleTextStyle(textTheme.bodySmall, bodyScale),
      labelLarge: _scaleTextStyle(textTheme.labelLarge, bodyScale),
      labelMedium: _scaleTextStyle(textTheme.labelMedium, bodyScale),
      labelSmall: _scaleTextStyle(textTheme.labelSmall, bodyScale),
    );
  }

  static TextStyle? _scaleTextStyle(TextStyle? style, double scale) {
    if (style == null) {
      return null;
    }
    if (style.fontSize == null) {
      return style;
    }
    return style.copyWith(fontSize: style.fontSize! * scale);
  }

  static VisualDensity _resolveVisualDensity({required double componentScale}) {
    final double progress =
        (AppAdaptiveThemeConst.maximumScale - componentScale) /
        (AppAdaptiveThemeConst.maximumScale -
            AppAdaptiveThemeConst.minimumComponentScale);
    final double density =
        AppAdaptiveThemeConst.maximumCompactDensity * progress;
    return VisualDensity(horizontal: density, vertical: density);
  }

  static double _resolveScale({
    required double screenWidth,
    required double minimumScale,
  }) {
    final double rawScale =
        screenWidth / AppAdaptiveThemeConst.baseCompactWidth;
    if (rawScale <= minimumScale) {
      return minimumScale;
    }
    if (rawScale >= AppAdaptiveThemeConst.maximumScale) {
      return AppAdaptiveThemeConst.maximumScale;
    }
    return rawScale;
  }

  static double _radiusScale({required double componentScale}) {
    final double radiusReduction =
        AppAdaptiveThemeConst.maximumScale - componentScale;
    final double candidate =
        AppAdaptiveThemeConst.maximumScale - (radiusReduction * 0.6);
    if (candidate <= AppAdaptiveThemeConst.minimumRadiusScale) {
      return AppAdaptiveThemeConst.minimumRadiusScale;
    }
    return candidate;
  }

  static EdgeInsets _scaleEdgeInsets(EdgeInsets value, double scale) {
    return EdgeInsets.fromLTRB(
      value.left * scale,
      value.top * scale,
      value.right * scale,
      value.bottom * scale,
    );
  }
}
