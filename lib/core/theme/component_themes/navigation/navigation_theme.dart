import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/app_theme_palette.dart';
import 'package:lumos/core/theme/extensions/dimension_theme_ext.dart';

abstract final class LumosNavigationTheme {
  static NavigationBarThemeData bar({
    required ColorScheme colorScheme,
    required DimensionThemeExt dimensions,
    required TextTheme textTheme,
  }) {
    final palette = AppThemePalette.fromBrightness(colorScheme.brightness);

    return NavigationBarThemeData(
      height: dimensions.componentSize.bottomBarHeight,
      backgroundColor: palette.sidebarBackground,
      indicatorColor: palette.sidebarSelectedBackground,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final isSelected = states.contains(WidgetState.selected);
        return textTheme.labelMedium?.copyWith(
          color: isSelected
              ? palette.sidebarSelectedForeground
              : palette.sidebarText,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final isSelected = states.contains(WidgetState.selected);
        return IconThemeData(
          size: dimensions.iconSize.lg,
          color: isSelected
              ? palette.sidebarSelectedForeground
              : palette.sidebarText,
        );
      }),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    );
  }

  static NavigationRailThemeData rail({
    required ColorScheme colorScheme,
    required DimensionThemeExt dimensions,
    required TextTheme textTheme,
  }) {
    final palette = AppThemePalette.fromBrightness(colorScheme.brightness);

    return NavigationRailThemeData(
      backgroundColor: palette.sidebarBackground,
      indicatorColor: palette.sidebarSelectedBackground,
      minWidth: dimensions.componentSize.navigationRailWidth,
      minExtendedWidth: dimensions.componentSize.navigationRailWidth * 2.75,
      selectedIconTheme: IconThemeData(
        size: dimensions.iconSize.lg,
        color: palette.sidebarSelectedForeground,
      ),
      unselectedIconTheme: IconThemeData(
        size: dimensions.iconSize.lg,
        color: palette.sidebarText,
      ),
      selectedLabelTextStyle: textTheme.labelMedium?.copyWith(
        color: palette.sidebarSelectedForeground,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelTextStyle: textTheme.labelMedium?.copyWith(
        color: palette.sidebarText,
        fontWeight: FontWeight.w500,
      ),
      useIndicator: true,
    );
  }
}
