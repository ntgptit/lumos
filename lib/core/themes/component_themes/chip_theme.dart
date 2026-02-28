import 'package:flutter/material.dart';

import '../constants/dimensions.dart';
import '../extensions/theme_extensions.dart';

/// Chip size variants — mirrors [ButtonSize] convention.
///
/// - [small]  : Tag / label, dense lists (28dp height).
/// - [medium] : Default filter, suggestion, input chip (32dp height).
/// - [large]  : Prominent category tabs on tablet/desktop (40dp height).
enum ChipSize { small, medium, large }

/// Centralised chip theming for Social/Lifestyle app.
///
/// Covers all 4 M3 chip roles:
///   - Filter chip  : category tabs, multi-select filters
///   - Assist chip  : suggestion / quick action (non-selectable)
///   - Input chip   : deletable tags (shows delete icon)
///   - Action chip  : single CTA inside a chip (rare)
///
/// Supports:
///   - [ChipSize]   — small / medium / large
///   - [DeviceType] — compact on mobile, relaxed padding on tablet/desktop
///
/// Flutter limitation: [ChipThemeData.side] and [ChipThemeData.shape] both
/// accept concrete types only — not [WidgetStateProperty]. Selected and
/// disabled border states are handled by Flutter's chip widget internally
/// via [ColorScheme] roles (selectedColor, disabledColor). Per-state border
/// overrides must be done at widget level via [chip.side] property directly.
///
/// Usage — global theme:
/// ```dart
/// chipTheme: ChipThemes.build(colorScheme: cs, textTheme: tt),
/// ```
///
/// Usage — per-widget size override:
/// ```dart
/// Theme(
///   data: Theme.of(context).copyWith(
///     chipTheme: ChipThemes.buildSize(
///       colorScheme: colorScheme,
///       textTheme: textTheme,
///       size: ChipSize.small,
///     ),
///   ),
///   child: TagChip(),
/// )
/// ```
abstract final class ChipThemes {
  // Pill radius for filter / input / suggestion chips (M3 standard).
  static const double _radiusPill = Radius.radiusMedium; // 8dp
  // Square radius for category tab-style chips.
  static const double _radiusSquare = Radius.radiusLarge; // 12dp

  // ---------------------------------------------------------------------------
  // Global theme builder
  // ---------------------------------------------------------------------------

  /// Default chip theme — pill shape, medium size, mobile density.
  static ChipThemeData build({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    DeviceType deviceType = DeviceType.mobile,
  }) {
    return _buildTheme(
      colorScheme: colorScheme,
      textTheme: textTheme,
      size: ChipSize.medium,
      deviceType: deviceType,
      radius: _radiusPill,
    );
  }

  // ---------------------------------------------------------------------------
  // Per-widget builders
  // ---------------------------------------------------------------------------

  /// Size-specific chip theme. Wrap with [Theme] widget for local overrides.
  static ChipThemeData buildSize({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    ChipSize size = ChipSize.medium,
    DeviceType deviceType = DeviceType.mobile,
  }) {
    return _buildTheme(
      colorScheme: colorScheme,
      textTheme: textTheme,
      size: size,
      deviceType: deviceType,
      radius: _radiusPill,
    );
  }

  /// Square-ish chip theme for category tab rows.
  /// Uses [radiusLarge] (12dp) to signal "tab" semantics, not "tag".
  static ChipThemeData buildCategoryTab({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    DeviceType deviceType = DeviceType.mobile,
  }) {
    return _buildTheme(
      colorScheme: colorScheme,
      textTheme: textTheme,
      size: ChipSize.medium,
      deviceType: deviceType,
      radius: _radiusSquare,
    );
  }

  // ---------------------------------------------------------------------------
  // Core builder
  // ---------------------------------------------------------------------------

  static ChipThemeData _buildTheme({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    required ChipSize size,
    required DeviceType deviceType,
    required double radius,
  }) {
    return ChipThemeData(
      backgroundColor: colorScheme.surfaceContainerLow,
      selectedColor: colorScheme.secondaryContainer,
      disabledColor: colorScheme.disabledContainerColor,
      deleteIconColor: colorScheme.onSurfaceVariant,
      iconTheme: IconThemeData(
        color: colorScheme.onSurfaceVariant,
        size: _iconSize(size),
      ),

      // Default border — subtle, not heavy.
      // Selected/disabled border states are managed by Flutter chip internally.
      // For explicit per-state border control, override at widget level:
      //   FilterChip(side: BorderSide(...), ...)
      side: BorderSide(
        color: colorScheme.outline,
        width: WidgetSizes.borderWidthRegular, // 1dp
      ),

      // Shape accepts OutlinedBorder? only — no WidgetStateProperty support.
      // Geometry only, border is set via side above.
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),

      labelStyle: _labelStyle(
        textTheme: textTheme,
        size: size,
        color: colorScheme.onSurface,
      ),
      secondaryLabelStyle: _labelStyle(
        textTheme: textTheme,
        size: size,
        color: colorScheme.onSecondaryContainer,
      ),

      padding: _padding(size: size, deviceType: deviceType),
      labelPadding: _labelPadding(size),

      // M3 filter chip shows selection affordance by default.
      showCheckmark: true,

      elevation: WidgetSizes.none,
      pressElevation: WidgetSizes.none,
    );
  }

  // ---------------------------------------------------------------------------
  // Size helpers
  // ---------------------------------------------------------------------------

  static TextStyle? _labelStyle({
    required TextTheme textTheme,
    required ChipSize size,
    required Color color,
  }) {
    final TextStyle? base = switch (size) {
      ChipSize.small => textTheme.labelSmall,
      ChipSize.medium => textTheme.labelMedium,
      ChipSize.large => textTheme.labelLarge,
    };
    return base?.copyWith(color: color);
  }

  static EdgeInsets _padding({
    required ChipSize size,
    required DeviceType deviceType,
  }) {
    final double vPad = switch (size) {
      ChipSize.small => Insets.spacing4, // 4dp → ~28dp total height
      ChipSize.medium => Insets.spacing8, // 8dp → ~32dp total height
      ChipSize.large => Insets.spacing12, // 12dp → ~40dp total height
    };

    final double hBase = switch (size) {
      ChipSize.small => Insets.spacing8,
      ChipSize.medium => Insets.spacing12,
      ChipSize.large => Insets.spacing16,
    };

    final double hExtra = switch (deviceType) {
      DeviceType.mobile => Insets.spacing0,
      DeviceType.tablet => Insets.spacing4,
      DeviceType.desktop => Insets.spacing8,
    };

    return EdgeInsets.symmetric(horizontal: hBase + hExtra, vertical: vPad);
  }

  static EdgeInsets _labelPadding(ChipSize size) {
    return switch (size) {
      ChipSize.small => const EdgeInsets.symmetric(horizontal: Insets.spacing4),
      ChipSize.medium => const EdgeInsets.symmetric(
        horizontal: Insets.spacing8,
      ),
      ChipSize.large => const EdgeInsets.symmetric(horizontal: Insets.spacing8),
    };
  }

  static double _iconSize(ChipSize size) {
    return switch (size) {
      ChipSize.small => IconSizes.iconSmall, // 16dp
      ChipSize.medium => IconSizes.iconSmall, // 16dp — chip icon stays compact
      ChipSize.large => IconSizes.iconMedium, // 24dp
    };
  }
}
