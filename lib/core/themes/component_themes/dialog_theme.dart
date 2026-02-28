import 'package:flutter/material.dart';

import '../constants/dimensions.dart';
import '../extensions/color_scheme_state_extensions.dart';
import '../shape.dart';

/// Dialog visual variants.
///
/// - [alert]      : Confirmation, destructive action, error notice.
/// - [bottomSheet]: Action sheet, options picker, filter panel.
/// - [fullScreen] : Multi-step flow, media viewer, form.
/// - [custom]     : Rich content, onboarding, feature highlight.
enum DialogVariant { alert, bottomSheet, fullScreen, custom }

/// Centralised dialog theming for Social/Lifestyle app.
///
/// Supports:
///   - [DialogVariant]  — alert / bottomSheet / fullScreen / custom
///   - Brightness       — light / dark surface roles
///   - DeviceType       — compact inset on mobile, centered+constrained on tablet/desktop
///   - Scrim            — brightness-aware barrier opacity
///
/// Usage — global theme (alert dialog as default):
/// ```dart
/// dialogTheme: DialogThemes.build(colorScheme: cs, textTheme: tt),
/// bottomSheetTheme: DialogThemes.buildBottomSheet(colorScheme: cs, textTheme: tt),
/// ```
///
/// Usage — per-call variant via showDialog helper:
/// ```dart
/// DialogThemes.showVariant(
///   context: context,
///   variant: DialogVariant.custom,
///   builder: (context) => MyDialog(),
/// );
/// ```
abstract final class DialogThemes {
  // ---------------------------------------------------------------------------
  // Elevation
  // M3: dialogs use elevation 3 to lift above scrim and content.
  // Bottom sheet uses elevation 1 — it slides in, scrim handles separation.
  // Full-screen: 0 — occupies entire screen, no floating needed.
  // ---------------------------------------------------------------------------
  static const double _elevationDialog = 3.0;
  static const double _elevationBottomSheet = 1.0;
  static const double _elevationFullScreen = 0.0;

  // ---------------------------------------------------------------------------
  // Global theme builders — wire into ThemeData
  // ---------------------------------------------------------------------------

  /// Alert/confirm dialog theme — default [DialogThemeData] for ThemeData.
  static DialogThemeData build({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    DeviceType deviceType = DeviceType.mobile,
  }) {
    return DialogThemeData(
      // M3 alert dialogs use a raised surface container.
      backgroundColor: colorScheme.surfaceContainerHigh,
      elevation: _elevationDialog,
      shadowColor: colorScheme.shadow.withValues(
        alpha: WidgetOpacities.elevationLevel2, // 0.08
      ),
      // Scrim: darker on dark mode to maintain contrast with deep surface.
      barrierColor: colorScheme.modalBarrierScrimColor,
      shape: AppShape.dialog(),
      alignment: _dialogAlignment(deviceType),
      insetPadding: _dialogInset(deviceType),
      titleTextStyle: textTheme.titleLarge?.copyWith(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
      contentTextStyle: textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }

  /// Bottom sheet theme — wire into ThemeData.bottomSheetTheme.
  static BottomSheetThemeData buildBottomSheet({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    DeviceType deviceType = DeviceType.mobile,
  }) {
    return BottomSheetThemeData(
      backgroundColor: colorScheme.surfaceContainerLow,
      elevation: _elevationBottomSheet,
      shadowColor: colorScheme.shadow.withValues(
        alpha: WidgetOpacities.elevationLevel1, // 0.05
      ),
      modalBarrierColor: colorScheme.modalBarrierScrimColor,
      // Only top corners rounded — bottom flush with screen edge.
      shape: AppShape.bottomSheet(),
      clipBehavior: Clip.antiAlias,
      // Modal sheet: constrained width on tablet/desktop so it doesn't stretch full screen.
      constraints: _bottomSheetConstraints(deviceType),
      showDragHandle: true,
      dragHandleColor: colorScheme.onSurfaceVariant.withValues(
        alpha: WidgetOpacities.elevationLevel3, // 0.11 — subtle handle
      ),
      dragHandleSize: const Size(Insets.spacing32, Insets.spacing4),
    );
  }

  /// Full-screen dialog style — apply via Theme override when pushing route.
  ///
  /// Full-screen dialogs are routes, not overlays — ThemeData.dialogTheme
  /// does not cover them. Use this to wrap the route's scaffold:
  /// ```dart
  /// Navigator.push(context, MaterialPageRoute(
  ///   fullscreenDialog: true,
  ///   builder: (_) => Theme(
  ///     data: Theme.of(context).copyWith(
  ///       dialogTheme: DialogThemes.buildFullScreen(colorScheme: cs, textTheme: tt),
  ///     ),
  ///     child: FullScreenDialogPage(),
  ///   ),
  /// ));
  /// ```
  static DialogThemeData buildFullScreen({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return DialogThemeData(
      // Full-screen uses surface directly — it IS the surface.
      backgroundColor: colorScheme.surface,
      elevation: _elevationFullScreen,
      shadowColor: colorScheme.shadow.withValues(
        alpha: WidgetOpacities.transparent,
      ),
      // No scrim — full-screen dialog covers entire screen.
      barrierColor: colorScheme.scrim.withValues(
        alpha: WidgetOpacities.transparent,
      ),
      shape: const RoundedRectangleBorder(), // no radius — edge-to-edge
      alignment: Alignment.center,
      insetPadding: EdgeInsets.zero,
      titleTextStyle: textTheme.titleLarge?.copyWith(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
      contentTextStyle: textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }

  /// Custom content dialog theme — generous padding, slightly larger radius.
  /// Use for onboarding, feature highlights, rich media dialogs.
  static DialogThemeData buildCustom({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    DeviceType deviceType = DeviceType.mobile,
  }) {
    return DialogThemeData(
      backgroundColor: colorScheme.surfaceContainerHigh,
      elevation: _elevationDialog,
      shadowColor: colorScheme.shadow.withValues(
        alpha: WidgetOpacities.elevationLevel2,
      ),
      barrierColor: colorScheme.modalBarrierScrimColor,
      // cardLarge (12dp radius) — softer, more editorial feel for rich content.
      shape: AppShape.cardLarge(),
      alignment: _dialogAlignment(deviceType),
      insetPadding: _customDialogInset(deviceType),
      titleTextStyle: textTheme.headlineSmall?.copyWith(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
      contentTextStyle: textTheme.bodyLarge?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Responsive helpers
  // ---------------------------------------------------------------------------

  /// Alert dialog alignment:
  /// Mobile  → center (default M3 behavior).
  /// Tablet+ → slightly above center for better visual balance on large screens.
  static AlignmentGeometry _dialogAlignment(DeviceType deviceType) {
    return switch (deviceType) {
      DeviceType.mobile => Alignment.center,
      DeviceType.tablet => const Alignment(0, -0.2),
      DeviceType.desktop => const Alignment(0, -0.2),
    };
  }

  /// Alert dialog inset — controls max width indirectly via horizontal inset.
  /// Mobile  : 40dp horizontal → dialog fills most of screen width.
  /// Tablet  : 120dp horizontal → dialog is comfortably narrower.
  /// Desktop : 240dp horizontal → dialog stays compact in large viewport.
  static EdgeInsets _dialogInset(DeviceType deviceType) {
    return switch (deviceType) {
      DeviceType.mobile => const EdgeInsets.symmetric(
        horizontal: Insets.spacing32,
        vertical: Insets.spacing48,
      ),
      DeviceType.tablet => const EdgeInsets.symmetric(
        horizontal: 120,
        vertical: Insets.spacing48,
      ),
      DeviceType.desktop => const EdgeInsets.symmetric(
        horizontal: 240,
        vertical: Insets.spacing48,
      ),
    };
  }

  /// Custom dialog inset — tighter than alert on mobile for richer layouts.
  static EdgeInsets _customDialogInset(DeviceType deviceType) {
    return switch (deviceType) {
      DeviceType.mobile => const EdgeInsets.symmetric(
        horizontal: Insets.spacing16,
        vertical: Insets.spacing48,
      ),
      DeviceType.tablet => const EdgeInsets.symmetric(
        horizontal: 80,
        vertical: Insets.spacing48,
      ),
      DeviceType.desktop => const EdgeInsets.symmetric(
        horizontal: 200,
        vertical: Insets.spacing48,
      ),
    };
  }

  /// Bottom sheet max width — prevents sheet from stretching full width on tablet/desktop.
  static BoxConstraints? _bottomSheetConstraints(DeviceType deviceType) {
    return switch (deviceType) {
      DeviceType.mobile => null, // full width on mobile
      DeviceType.tablet => const BoxConstraints(maxWidth: 480),
      DeviceType.desktop => const BoxConstraints(maxWidth: 560),
    };
  }
}
