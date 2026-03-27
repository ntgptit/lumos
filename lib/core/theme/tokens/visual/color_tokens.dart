import 'package:flutter/material.dart';

abstract final class AppColorTokens {
  // Tokyo dashboard palettes are separated into explicit light and dark token
  // families so each theme branch can stay true to its own source project.
  static const white = Color(0xFFFFFFFF);

  static const seed = Color(0xFF0E6D68);

  static const primary = Color(0xFF0E6D68);
  static const primaryContainer = Color(0xFFBDE9E2);
  static const secondary = Color(0xFFC06B2C);
  static const secondaryContainer = Color(0xFFFFDCC0);
  static const tertiary = Color(0xFF296C93);
  static const tertiaryContainer = Color(0xFFCBE7FA);

  static const lightPrimary = Color(0xFF5569FF);
  static const lightPrimaryLight = Color(0xFF8896FF);
  static const lightPrimaryDark = Color(0xFF4454CC);
  static const lightPrimaryContainer = Color(0xFFEEF0FF);

  static const lightSecondary = Color(0xFF6E759F);
  static const lightSecondaryLight = Color(0xFF9A9EBC);
  static const lightSecondaryDark = Color(0xFF585E7F);
  static const lightSecondaryContainer = Color(0xFFF1F1F5);

  static const lightTextPrimary = Color(0xFF223354);
  static const lightTextSecondary = Color(0xFF647087);
  static const lightTextDisabled = Color(0xFF9199AA);

  static const lightBackground = Color(0xFFF2F5F9);
  static const lightSurface = white;
  static const lightSurfaceContainerLow = Color(0xFFF4F5F6);
  static const lightSurfaceContainer = Color(0xFFF2F5F9);
  static const lightSurfaceContainerHigh = Color(0xFFE9EBEE);
  static const lightSurfaceContainerHighest = Color(0xFFDDE2E9);
  static const lightOutline = Color(0xFFBDC2CC);
  static const lightOutlineVariant = Color(0xFFE9EBEE);
  static const lightShadow = Color(0x339FA2BF);

  static const lightSidebarBackground = white;
  static const lightSidebarText = lightSecondary;
  static const lightSidebarDivider = lightBackground;
  static const lightSidebarMenuItem = Color(0xFF242E6F);
  static const lightSidebarMenuItemActive = lightPrimary;
  static const lightSidebarMenuItemBackground = white;
  static const lightSidebarMenuItemBackgroundActive = lightBackground;
  static const lightSidebarMenuItemIcon = lightSecondaryLight;
  static const lightSidebarMenuItemIconActive = lightPrimary;
  static const lightSidebarMenuHeading = Color(0xFF4D526F);

  static const lightHeaderBackground = white;
  static const lightHeaderForeground = lightSecondary;

  static const primaryAlpha05 = Color(0x0D5569FF);
  static const primaryAlpha10 = Color(0x1A5569FF);
  static const blackAlpha05 = Color(0x0D223354);
  static const blackAlpha10 = Color(0x1A223354);
  static const blackAlpha30 = Color(0x4D223354);

  static const darkPrimary = Color(0xFF8C7CF0);
  static const darkPrimaryDark = Color(0xFF7063C0);
  static const darkPrimaryDeeper = Color(0xFF6257A8);
  static const darkPrimaryGlow = Color(0xFFDDD8FB);
  static const darkPrimaryContainer = Color(0x1A8C7CF0);
  static const darkPrimaryContainerStrong = Color(0x4D8C7CF0);
  static const darkPrimaryContainerOpaque = Color(0xFF1D2046);

  static const darkSecondary = Color(0xFF9EA4C1);
  static const darkSecondaryDark = Color(0xFF7E839A);
  static const darkSecondaryHeading = Color(0xFF6F7387);
  static const darkSecondaryContainer = Color(0x1A9EA4C1);
  static const darkSecondaryContainerStrong = Color(0x4D9EA4C1);
  static const darkSecondaryContainerOpaque = Color(0xFF1F2441);

  static const darkTextPrimary = Color(0xFFCBCCD2);
  static const darkTextSecondary = Color(0xB3CBCCD2);
  static const darkTextDisabled = Color(0x80CBCCD2);
  static const darkTextMuted = Color(0x4DCBCCD2);
  static const darkTextSubtle = Color(0x1ACBCCD2);
  static const darkTextMinimal = Color(0x05CBCCD2);

  static const darkBackground = Color(0xFF070C27);
  static const darkSurface = Color(0xFF111633);
  static const darkSurfaceContainerLow = Color(0xFF151A36);
  static const darkSurfaceContainer = Color(0xFF1A1F3B);
  static const darkSurfaceContainerHigh = Color(0xFF242843);
  static const darkSurfaceContainerHighest = Color(0xFF272C48);
  static const darkDialogSurface = Color(0xFF090B1A);
  static const darkOutline = Color(0x4DCBCCD2);
  static const darkOutlineVariant = Color(0xFF272C48);
  static const darkShadow = Color(0x33000000);
  static const darkCardStroke = Color(0xFF6A7199);
  static const darkScrim = Color(0x66040614);

  static const darkSidebarBackground = darkSurface;
  static const darkSidebarText = darkSecondary;
  static const darkSidebarDivider = darkOutlineVariant;
  static const darkSidebarMenuItem = darkSecondary;
  static const darkSidebarMenuItemActive = white;
  static const darkSidebarMenuItemBackground = darkSurface;
  static const darkSidebarMenuItemBackgroundActive = Color(0x992B304D);
  static const darkSidebarMenuItemIcon = Color(0xFF444A6B);
  static const darkSidebarMenuItemIconActive = white;
  static const darkSidebarMenuHeading = darkSecondaryHeading;

  static const darkHeaderBackground = darkSurface;
  static const darkHeaderBackgroundFrosted = Color(0xF2111633);
  static const darkHeaderForeground = darkSecondary;
  static const darkHeaderHairlineGlow = Color(0x26DDD8FB);

  static const darkSuccess = Color(0xFF57CA22);
  static const darkSuccessDark = Color(0xFF46A21B);
  static const darkSuccessContainer = Color(0x1A57CA22);
  static const darkSuccessContainerStrong = Color(0x4D57CA22);
  static const darkOnSuccess = white;
  static const darkOnSuccessContainer = darkSuccess;

  static const darkWarning = Color(0xFFFFA319);
  static const darkWarningDark = Color(0xFFCC8214);
  static const darkWarningContainer = Color(0x1AFFA319);
  static const darkWarningContainerStrong = Color(0x4DFFA319);
  static const darkOnWarning = white;
  static const darkOnWarningContainer = darkWarning;

  static const darkError = Color(0xFFFF1943);
  static const darkErrorDark = Color(0xFFCC1436);
  static const darkErrorContainer = Color(0x1AFF1943);
  static const darkErrorContainerStrong = Color(0x4DFF1943);
  static const darkOnError = white;
  static const darkOnErrorContainer = darkError;

  static const darkInfo = Color(0xFF33C2FF);
  static const darkInfoDark = Color(0xFF299BCC);
  static const darkInfoContainer = Color(0x1A33C2FF);
  static const darkInfoContainerStrong = Color(0x4D33C2FF);
  static const darkOnInfo = white;
  static const darkOnInfoContainer = darkInfo;

  static const success = Color(0xFF2F8F4E);
  static const successContainer = Color(0xFFCBEFD6);
  static const onSuccess = white;
  static const onSuccessContainer = Color(0xFF103920);

  static const warning = Color(0xFFB86A07);
  static const warningContainer = Color(0xFFFFE2BF);
  static const onWarning = white;
  static const onWarningContainer = Color(0xFF3F2400);

  static const error = Color(0xFFB3261E);
  static const errorContainer = Color(0xFFF9DEDC);
  static const info = Color(0xFF1565C0);
  static const infoContainer = Color(0xFFD6E7FF);
  static const onInfo = white;
  static const onInfoContainer = Color(0xFF001D36);

  static const dividerLight = Color(0x1F1B2A24);
  static const dividerDark = darkTextSubtle;
  static const overlayLight = Color(0x14000000);
  static const overlayDark = darkScrim;
  static const shadow = Color(0x1A000000);

  static Color surface(Brightness brightness) {
    return brightness == Brightness.dark ? darkSurface : lightSurface;
  }

  static Color background(Brightness brightness) {
    return brightness == Brightness.dark ? darkBackground : lightBackground;
  }

  static Color outline(Brightness brightness) {
    return brightness == Brightness.dark ? darkOutline : lightOutline;
  }

  static Color divider(Brightness brightness) {
    return brightness == Brightness.dark ? dividerDark : dividerLight;
  }
}
