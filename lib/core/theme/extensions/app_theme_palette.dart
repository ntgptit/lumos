import 'package:flutter/material.dart';
import 'package:lumos/core/theme/tokens/tokens.dart';

@immutable
class AppThemePalette extends ThemeExtension<AppThemePalette> {
  const AppThemePalette({
    required this.primary,
    required this.primaryContainer,
    required this.primaryAccentShadow,
    required this.secondary,
    required this.surface,
    required this.surfaceContainerLow,
    required this.controlTrack,
    required this.outline,
    required this.separator,
    required this.shadow,
    required this.textPrimary,
    required this.textSecondary,
    required this.textDisabled,
    required this.headerBackground,
    required this.headerForeground,
    required this.headerScrolledUnderElevation,
    required this.sidebarBackground,
    required this.sidebarText,
    required this.sidebarSelectedForeground,
    required this.sidebarSelectedBackground,
    required this.cardBackground,
    required this.cardBorder,
    required this.dialogBackground,
    required this.switchSelectedThumb,
    required this.switchUnselectedThumb,
    required this.switchSelectedTrack,
    required this.switchUnselectedTrack,
  });

  factory AppThemePalette.fromBrightness(Brightness brightness) {
    if (brightness == Brightness.dark) {
      return const AppThemePalette(
        primary: AppColorTokens.darkPrimary,
        primaryContainer: AppColorTokens.darkPrimaryContainer,
        primaryAccentShadow: AppColorTokens.darkPrimaryContainerStrong,
        secondary: AppColorTokens.darkSecondary,
        surface: AppColorTokens.darkSurface,
        surfaceContainerLow: AppColorTokens.darkSurfaceContainerLow,
        controlTrack: AppColorTokens.darkSurfaceContainerHigh,
        outline: AppColorTokens.darkOutline,
        separator: AppColorTokens.darkTextSubtle,
        shadow: AppColorTokens.darkShadow,
        textPrimary: AppColorTokens.darkTextPrimary,
        textSecondary: AppColorTokens.darkTextSecondary,
        textDisabled: AppColorTokens.darkTextDisabled,
        headerBackground: AppColorTokens.darkHeaderBackgroundFrosted,
        headerForeground: AppColorTokens.darkHeaderForeground,
        headerScrolledUnderElevation: AppElevationTokens.level2,
        sidebarBackground: AppColorTokens.darkSidebarBackground,
        sidebarText: AppColorTokens.darkSidebarText,
        sidebarSelectedForeground: AppColorTokens.darkSidebarMenuItemActive,
        sidebarSelectedBackground:
            AppColorTokens.darkSidebarMenuItemBackgroundActive,
        cardBackground: AppColorTokens.darkSurface,
        cardBorder: AppColorTokens.darkCardStroke,
        dialogBackground: AppColorTokens.darkDialogSurface,
        switchSelectedThumb: AppColorTokens.darkPrimary,
        switchUnselectedThumb: AppColorTokens.darkSurface,
        switchSelectedTrack: AppColorTokens.darkPrimaryContainerStrong,
        switchUnselectedTrack: AppColorTokens.darkSurfaceContainerLow,
      );
    }

    return const AppThemePalette(
      primary: AppColorTokens.lightPrimary,
      primaryContainer: AppColorTokens.lightPrimaryContainer,
      primaryAccentShadow: AppColorTokens.primaryAlpha10,
      secondary: AppColorTokens.lightSecondary,
      surface: AppColorTokens.lightSurface,
      surfaceContainerLow: AppColorTokens.lightSurfaceContainerLow,
      controlTrack: AppColorTokens.lightSurfaceContainerHighest,
      outline: AppColorTokens.lightOutlineVariant,
      separator: AppColorTokens.lightOutlineVariant,
      shadow: AppColorTokens.lightShadow,
      textPrimary: AppColorTokens.lightTextPrimary,
      textSecondary: AppColorTokens.lightTextSecondary,
      textDisabled: AppColorTokens.lightTextDisabled,
      headerBackground: AppColorTokens.lightHeaderBackground,
      headerForeground: AppColorTokens.lightHeaderForeground,
      headerScrolledUnderElevation: AppElevationTokens.level1,
      sidebarBackground: AppColorTokens.lightSidebarBackground,
      sidebarText: AppColorTokens.lightSidebarText,
      sidebarSelectedForeground: AppColorTokens.lightPrimary,
      sidebarSelectedBackground: AppColorTokens.lightPrimaryContainer,
      cardBackground: AppColorTokens.lightSurface,
      cardBorder: AppColorTokens.lightOutlineVariant,
      dialogBackground: AppColorTokens.lightSurface,
      switchSelectedThumb: AppColorTokens.white,
      switchUnselectedThumb: AppColorTokens.lightOutline,
      switchSelectedTrack: AppColorTokens.lightPrimary,
      switchUnselectedTrack: AppColorTokens.lightSurfaceContainerHighest,
    );
  }

  final Color primary;
  final Color primaryContainer;
  final Color primaryAccentShadow;
  final Color secondary;
  final Color surface;
  final Color surfaceContainerLow;
  final Color controlTrack;
  final Color outline;
  final Color separator;
  final Color shadow;
  final Color textPrimary;
  final Color textSecondary;
  final Color textDisabled;
  final Color headerBackground;
  final Color headerForeground;
  final double headerScrolledUnderElevation;
  final Color sidebarBackground;
  final Color sidebarText;
  final Color sidebarSelectedForeground;
  final Color sidebarSelectedBackground;
  final Color cardBackground;
  final Color cardBorder;
  final Color dialogBackground;
  final Color switchSelectedThumb;
  final Color switchUnselectedThumb;
  final Color switchSelectedTrack;
  final Color switchUnselectedTrack;

  @override
  AppThemePalette copyWith({
    Color? primary,
    Color? primaryContainer,
    Color? primaryAccentShadow,
    Color? secondary,
    Color? surface,
    Color? surfaceContainerLow,
    Color? controlTrack,
    Color? outline,
    Color? separator,
    Color? shadow,
    Color? textPrimary,
    Color? textSecondary,
    Color? textDisabled,
    Color? headerBackground,
    Color? headerForeground,
    double? headerScrolledUnderElevation,
    Color? sidebarBackground,
    Color? sidebarText,
    Color? sidebarSelectedForeground,
    Color? sidebarSelectedBackground,
    Color? cardBackground,
    Color? cardBorder,
    Color? dialogBackground,
    Color? switchSelectedThumb,
    Color? switchUnselectedThumb,
    Color? switchSelectedTrack,
    Color? switchUnselectedTrack,
  }) {
    return AppThemePalette(
      primary: primary ?? this.primary,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      primaryAccentShadow: primaryAccentShadow ?? this.primaryAccentShadow,
      secondary: secondary ?? this.secondary,
      surface: surface ?? this.surface,
      surfaceContainerLow: surfaceContainerLow ?? this.surfaceContainerLow,
      controlTrack: controlTrack ?? this.controlTrack,
      outline: outline ?? this.outline,
      separator: separator ?? this.separator,
      shadow: shadow ?? this.shadow,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textDisabled: textDisabled ?? this.textDisabled,
      headerBackground: headerBackground ?? this.headerBackground,
      headerForeground: headerForeground ?? this.headerForeground,
      headerScrolledUnderElevation:
          headerScrolledUnderElevation ?? this.headerScrolledUnderElevation,
      sidebarBackground: sidebarBackground ?? this.sidebarBackground,
      sidebarText: sidebarText ?? this.sidebarText,
      sidebarSelectedForeground:
          sidebarSelectedForeground ?? this.sidebarSelectedForeground,
      sidebarSelectedBackground:
          sidebarSelectedBackground ?? this.sidebarSelectedBackground,
      cardBackground: cardBackground ?? this.cardBackground,
      cardBorder: cardBorder ?? this.cardBorder,
      dialogBackground: dialogBackground ?? this.dialogBackground,
      switchSelectedThumb: switchSelectedThumb ?? this.switchSelectedThumb,
      switchUnselectedThumb:
          switchUnselectedThumb ?? this.switchUnselectedThumb,
      switchSelectedTrack: switchSelectedTrack ?? this.switchSelectedTrack,
      switchUnselectedTrack:
          switchUnselectedTrack ?? this.switchUnselectedTrack,
    );
  }

  @override
  AppThemePalette lerp(ThemeExtension<AppThemePalette>? other, double t) {
    if (other is! AppThemePalette) {
      return this;
    }

    return AppThemePalette(
      primary: Color.lerp(primary, other.primary, t) ?? primary,
      primaryContainer:
          Color.lerp(primaryContainer, other.primaryContainer, t) ??
          primaryContainer,
      primaryAccentShadow:
          Color.lerp(primaryAccentShadow, other.primaryAccentShadow, t) ??
          primaryAccentShadow,
      secondary: Color.lerp(secondary, other.secondary, t) ?? secondary,
      surface: Color.lerp(surface, other.surface, t) ?? surface,
      surfaceContainerLow:
          Color.lerp(surfaceContainerLow, other.surfaceContainerLow, t) ??
          surfaceContainerLow,
      controlTrack:
          Color.lerp(controlTrack, other.controlTrack, t) ?? controlTrack,
      outline: Color.lerp(outline, other.outline, t) ?? outline,
      separator: Color.lerp(separator, other.separator, t) ?? separator,
      shadow: Color.lerp(shadow, other.shadow, t) ?? shadow,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t) ?? textPrimary,
      textSecondary:
          Color.lerp(textSecondary, other.textSecondary, t) ?? textSecondary,
      textDisabled:
          Color.lerp(textDisabled, other.textDisabled, t) ?? textDisabled,
      headerBackground:
          Color.lerp(headerBackground, other.headerBackground, t) ??
          headerBackground,
      headerForeground:
          Color.lerp(headerForeground, other.headerForeground, t) ??
          headerForeground,
      headerScrolledUnderElevation:
          t < 0.5
              ? headerScrolledUnderElevation
              : other.headerScrolledUnderElevation,
      sidebarBackground:
          Color.lerp(sidebarBackground, other.sidebarBackground, t) ??
          sidebarBackground,
      sidebarText: Color.lerp(sidebarText, other.sidebarText, t) ?? sidebarText,
      sidebarSelectedForeground:
          Color.lerp(
            sidebarSelectedForeground,
            other.sidebarSelectedForeground,
            t,
          ) ??
          sidebarSelectedForeground,
      sidebarSelectedBackground:
          Color.lerp(
            sidebarSelectedBackground,
            other.sidebarSelectedBackground,
            t,
          ) ??
          sidebarSelectedBackground,
      cardBackground:
          Color.lerp(cardBackground, other.cardBackground, t) ?? cardBackground,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t) ?? cardBorder,
      dialogBackground:
          Color.lerp(dialogBackground, other.dialogBackground, t) ??
          dialogBackground,
      switchSelectedThumb:
          Color.lerp(switchSelectedThumb, other.switchSelectedThumb, t) ??
          switchSelectedThumb,
      switchUnselectedThumb:
          Color.lerp(switchUnselectedThumb, other.switchUnselectedThumb, t) ??
          switchUnselectedThumb,
      switchSelectedTrack:
          Color.lerp(switchSelectedTrack, other.switchSelectedTrack, t) ??
          switchSelectedTrack,
      switchUnselectedTrack:
          Color.lerp(switchUnselectedTrack, other.switchUnselectedTrack, t) ??
          switchUnselectedTrack,
    );
  }
}
