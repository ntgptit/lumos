import 'package:flutter/material.dart';

import '../component/app_navigation_bar_tokens.dart';
import '../foundation/app_foundation.dart';
import '../extensions/theme_extensions.dart';
import '../semantic/app_elevation_tokens.dart';

abstract final class AppSurfaceThemeBuilder {
  static AppBarTheme appBarTheme({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return AppBarTheme(
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      elevation: WidgetSizes.none,
      centerTitle: false,
      toolbarHeight: WidgetSizes.appBarHeight,
      surfaceTintColor: colorScheme.surface.withValues(
        alpha: AppOpacity.transparent,
      ),
      scrolledUnderElevation: WidgetSizes.none,
      shadowColor: colorScheme.shadow.withValues(alpha: AppOpacity.transparent),
      titleTextStyle: textTheme.titleLarge?.copyWith(
        color: colorScheme.onSurface,
      ),
    );
  }

  static SearchBarThemeData searchBarTheme({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return SearchBarThemeData(
      constraints: const BoxConstraints(minHeight: WidgetSizes.minTouchTarget),
      elevation: const WidgetStatePropertyAll<double>(WidgetSizes.none),
      padding: const WidgetStatePropertyAll<EdgeInsets>(
        EdgeInsets.symmetric(horizontal: AppSpacing.md),
      ),
      side: WidgetStatePropertyAll<BorderSide>(
        BorderSide(
          color: colorScheme.outlineVariant,
          width: WidgetSizes.borderWidthRegular,
        ),
      ),
      backgroundColor: WidgetStatePropertyAll<Color>(
        colorScheme.surfaceContainerLow,
      ),
      textStyle: WidgetStatePropertyAll<TextStyle?>(textTheme.bodyMedium),
      hintStyle: WidgetStatePropertyAll<TextStyle?>(
        textTheme.bodyMedium?.withResolvedColor(colorScheme.onSurfaceVariant),
      ),
    );
  }

  static DividerThemeData dividerTheme({required ColorScheme colorScheme}) {
    return DividerThemeData(
      color: colorScheme.outlineVariant,
      thickness: WidgetSizes.borderWidthRegular,
      space: AppSpacing.lg,
    );
  }

  static BottomNavigationBarThemeData bottomNavigationBarTheme({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    final TextStyle? navigationLabelStyle = textTheme.labelMedium;
    return BottomNavigationBarThemeData(
      backgroundColor: colorScheme.surfaceContainerLowest,
      selectedItemColor: colorScheme.primary,
      unselectedItemColor: colorScheme.onSurfaceVariant,
      selectedLabelStyle: navigationLabelStyle?.copyWith(
        color: colorScheme.primary,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: navigationLabelStyle?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
      elevation: WidgetSizes.none,
      type: BottomNavigationBarType.fixed,
    );
  }

  static NavigationBarThemeData navigationBarTheme({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    required AppNavigationBarTokens navigationBarTokens,
  }) {
    final TextStyle? navigationLabelStyle = textTheme.labelMedium;
    return NavigationBarThemeData(
      backgroundColor: colorScheme.surfaceContainerLowest,
      elevation: WidgetSizes.none,
      indicatorColor: colorScheme.secondaryContainer,
      indicatorShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          navigationBarTokens.indicatorRadius,
        ),
      ),
      height: navigationBarTokens.height,
      iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((
        Set<WidgetState> states,
      ) {
        if (states.isSelected) {
          return IconThemeData(
            color: colorScheme.onSecondaryContainer,
            size: navigationBarTokens.iconSize,
          );
        }
        return IconThemeData(
          color: colorScheme.onSurfaceVariant,
          size: navigationBarTokens.iconSize,
        );
      }),
      labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>((
        Set<WidgetState> states,
      ) {
        if (states.isSelected) {
          return navigationLabelStyle?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          );
        }
        return navigationLabelStyle?.copyWith(
          color: colorScheme.onSurfaceVariant,
        );
      }),
    );
  }

  static FloatingActionButtonThemeData floatingActionButtonTheme({
    required ColorScheme colorScheme,
  }) {
    return FloatingActionButtonThemeData(
      backgroundColor: colorScheme.primaryContainer,
      foregroundColor: colorScheme.onPrimaryContainer,
      elevation: AppElevationTokens.level3,
      focusElevation: AppElevationTokens.level3,
      hoverElevation: AppElevationTokens.level4,
      highlightElevation: AppElevationTokens.level3,
    );
  }

  static TabBarThemeData tabBarTheme({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return TabBarThemeData(
      dividerColor: colorScheme.outlineVariant,
      indicatorColor: colorScheme.primary,
      indicatorSize: TabBarIndicatorSize.label,
      labelColor: colorScheme.primary,
      unselectedLabelColor: colorScheme.onSurfaceVariant,
      labelStyle: textTheme.titleSmall?.copyWith(
        color: colorScheme.primary,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: textTheme.titleSmall?.copyWith(
        color: colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w500,
      ),
      overlayColor: colorScheme.primary.asInteractiveOverlayProperty(),
      splashFactory: NoSplash.splashFactory,
    );
  }

  static SegmentedButtonThemeData segmentedButtonTheme({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    final TextStyle? segmentedLabelStyle = textTheme.titleSmall;
    return SegmentedButtonThemeData(
      style: ButtonStyle(
        textStyle: WidgetStatePropertyAll<TextStyle?>(
          segmentedLabelStyle?.copyWith(fontWeight: FontWeight.w600),
        ),
        foregroundColor: WidgetStateProperty.resolveWith<Color>((
          Set<WidgetState> states,
        ) {
          if (states.isDisabled) {
            return colorScheme.disabledContentColor;
          }
          if (states.isSelected) {
            return colorScheme.onSecondaryContainer;
          }
          return colorScheme.onSurfaceVariant;
        }),
        backgroundColor: WidgetStateProperty.resolveWith<Color>((
          Set<WidgetState> states,
        ) {
          if (states.isDisabled) {
            return colorScheme.surfaceContainerLow;
          }
          if (states.isSelected) {
            return colorScheme.secondaryContainer;
          }
          return colorScheme.surfaceContainerLowest;
        }),
        side: WidgetStateProperty.resolveWith<BorderSide>((
          Set<WidgetState> states,
        ) {
          if (states.isSelected) {
            return BorderSide(
              color: colorScheme.secondaryContainer,
              width: WidgetSizes.borderWidthRegular,
            );
          }
          return BorderSide(
            color: colorScheme.outlineVariant,
            width: WidgetSizes.borderWidthRegular,
          );
        }),
        shape: WidgetStatePropertyAll<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
        ),
        padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
        ),
        overlayColor: colorScheme.primary.asInteractiveOverlayProperty(),
      ),
    );
  }
}
