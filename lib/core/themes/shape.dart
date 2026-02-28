import 'package:flutter/material.dart';

import 'constants/dimensions.dart';

/// Centralized shape definitions for the app.
///
/// All methods return [ShapeBorder] instances built from [BorderRadii] and
/// [Radius] constants. Pass [side] only when a border is semantically required
/// (e.g. outlined card, focused input) — never apply a border as a visual hack.
abstract final class AppShape {
  // ---------------------------------------------------------------------------
  // Button
  // ---------------------------------------------------------------------------

  /// Standard pill-style button shape used across all button variants.
  static RoundedRectangleBorder button({BorderSide side = BorderSide.none}) {
    return RoundedRectangleBorder(
      borderRadius: BorderRadii.medium, // 8dp
      side: side,
    );
  }

  // ---------------------------------------------------------------------------
  // Card
  // ---------------------------------------------------------------------------

  /// Default card shape. [radius] defaults to [Radius.radiusCard] (12dp).
  /// Pass a custom [radius] for content-specific overrides (e.g. hero cards).
  static RoundedRectangleBorder card({
    BorderSide side = BorderSide.none,
    double radius = Radius.radiusCard,
  }) {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
      side: side,
    );
  }

  /// Large-radius card for prominent surfaces (e.g. story card, banner).
  static RoundedRectangleBorder cardLarge({BorderSide side = BorderSide.none}) {
    return RoundedRectangleBorder(
      borderRadius: BorderRadii.large, // 12dp
      side: side,
    );
  }

  // ---------------------------------------------------------------------------
  // Dialog / Sheet
  // ---------------------------------------------------------------------------

  static RoundedRectangleBorder dialog() {
    return const RoundedRectangleBorder(borderRadius: BorderRadii.large);
  }

  /// Bottom sheet — only top corners rounded.
  static RoundedRectangleBorder bottomSheet() {
    return const RoundedRectangleBorder(borderRadius: BorderRadii.topMedium);
  }

  // ---------------------------------------------------------------------------
  // Navigation
  // ---------------------------------------------------------------------------

  static ContinuousRectangleBorder navigation() {
    return const ContinuousRectangleBorder(borderRadius: BorderRadii.medium);
  }

  // ---------------------------------------------------------------------------
  // Input
  // ---------------------------------------------------------------------------

  static OutlineInputBorder input({
    required Color borderColor,
    double width = WidgetSizes.borderWidthRegular,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadii.medium,
      borderSide: BorderSide(color: borderColor, width: width),
    );
  }

  /// Focused input — same shape, caller provides the focused border color.
  static OutlineInputBorder inputFocused({required Color borderColor}) {
    return input(
      borderColor: borderColor,
      width: WidgetSizes.borderWidthRegular * 1.5,
    );
  }
}
