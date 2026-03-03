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
        EdgeInsets.symmetric(horizontal: Insets.spacing12),
      ),
      side: WidgetStatePropertyAll<BorderSide>(
        BorderSide(
          color: colorScheme.outlineVariant,
          width: WidgetSizes.borderWidthRegular,
        ),
      ),
      backgroundColor: WidgetStatePropertyAll<Color>(
        colorScheme.surfaceContainerHigh,
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
      space: Insets.spacing16,
    );
  }

  static BottomNavigationBarThemeData bottomNavigationBarTheme({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return BottomNavigationBarThemeData(
      backgroundColor: colorScheme.surface,
      selectedItemColor: colorScheme.primary,
      unselectedItemColor: colorScheme.onSurfaceVariant,
      selectedLabelStyle: textTheme.labelMedium?.copyWith(
        color: colorScheme.primary,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: textTheme.labelMedium?.copyWith(
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
    return NavigationBarThemeData(
      backgroundColor: colorScheme.surface,
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
          return textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          );
        }
        return textTheme.labelMedium?.copyWith(
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
}
