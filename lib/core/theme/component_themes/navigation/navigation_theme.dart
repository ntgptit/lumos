import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/dimension_theme_ext.dart';
import 'package:lumos/core/theme/tokens/tokens.dart';

abstract final class lumosNavigationTheme {
  static NavigationBarThemeData bar({
    required ColorScheme colorScheme,
    required DimensionThemeExt dimensions,
    required TextTheme textTheme,
  }) {
    final isLight = colorScheme.brightness == Brightness.light;
    final selectedColor = isLight
        ? AppColorTokens.lightPrimary
        : AppColorTokens.darkSidebarMenuItemActive;
    final unselectedColor = isLight
        ? AppColorTokens.lightSecondary
        : AppColorTokens.darkSidebarText;

    return NavigationBarThemeData(
      height: dimensions.componentSize.bottomBarHeight,
      backgroundColor: isLight
          ? AppColorTokens.lightSidebarBackground
          : AppColorTokens.darkSidebarBackground,
      indicatorColor: isLight
          ? AppColorTokens.lightPrimaryContainer
          : AppColorTokens.darkSidebarMenuItemBackgroundActive,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final isSelected = states.contains(WidgetState.selected);
        return textTheme.labelMedium?.copyWith(
          color: isSelected ? selectedColor : unselectedColor,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final isSelected = states.contains(WidgetState.selected);
        return IconThemeData(
          size: dimensions.iconSize.lg,
          color: isSelected ? selectedColor : unselectedColor,
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
    final isLight = colorScheme.brightness == Brightness.light;
    final selectedColor = isLight
        ? AppColorTokens.lightPrimary
        : AppColorTokens.darkSidebarMenuItemActive;
    final unselectedColor = isLight
        ? AppColorTokens.lightSecondary
        : AppColorTokens.darkSidebarText;

    return NavigationRailThemeData(
      backgroundColor: isLight
          ? AppColorTokens.lightSidebarBackground
          : AppColorTokens.darkSidebarBackground,
      indicatorColor: isLight
          ? AppColorTokens.lightPrimaryContainer
          : AppColorTokens.darkSidebarMenuItemBackgroundActive,
      minWidth: dimensions.componentSize.navigationRailWidth,
      minExtendedWidth: dimensions.componentSize.navigationRailWidth * 2.75,
      selectedIconTheme: IconThemeData(
        size: dimensions.iconSize.lg,
        color: selectedColor,
      ),
      unselectedIconTheme: IconThemeData(
        size: dimensions.iconSize.lg,
        color: unselectedColor,
      ),
      selectedLabelTextStyle: textTheme.labelMedium?.copyWith(
        color: selectedColor,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelTextStyle: textTheme.labelMedium?.copyWith(
        color: unselectedColor,
        fontWeight: FontWeight.w500,
      ),
      useIndicator: true,
    );
  }
}
