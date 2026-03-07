import 'package:flutter/material.dart';

import '../foundation/app_palette.dart';

// ---------------------------------------------------------------------------
// AppColorTokens — Semantic color extensions beyond M3 ColorScheme roles
// Covers: success, warning, info (each with full M3-style role quartet)
//
// Colors are resolved statically from AppPalette tonal scales, matching the
// Tokyo-inspired theme convention. Light/dark selection mirrors M3 role mapping:
//   light: color=*40, onColor=neutral100, container=*90, onContainer=*10
//   dark:  color=*80, onColor=*20, container=*30, onContainer=*90
// ---------------------------------------------------------------------------
@immutable
class AppColorTokens extends ThemeExtension<AppColorTokens> {
  const AppColorTokens({
    required this.success,
    required this.onSuccess,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.warning,
    required this.onWarning,
    required this.warningContainer,
    required this.onWarningContainer,
    required this.info,
    required this.onInfo,
    required this.infoContainer,
    required this.onInfoContainer,
  });

  final Color success;
  final Color onSuccess;
  final Color successContainer;
  final Color onSuccessContainer;

  final Color warning;
  final Color onWarning;
  final Color warningContainer;
  final Color onWarningContainer;

  final Color info;
  final Color onInfo;
  final Color infoContainer;
  final Color onInfoContainer;

  // ── Static singletons ──────────────────────────────────────────────────
  static const AppColorTokens light = AppColorTokens(
    success: AppPalette.success40,
    onSuccess: AppPalette.neutral100,
    successContainer: AppPalette.success90,
    onSuccessContainer: AppPalette.success10,
    warning: AppPalette.warning40,
    onWarning: AppPalette.neutral100,
    warningContainer: AppPalette.warning90,
    onWarningContainer: AppPalette.warning10,
    info: AppPalette.info40,
    onInfo: AppPalette.neutral100,
    infoContainer: AppPalette.info90,
    onInfoContainer: AppPalette.info10,
  );

  static const AppColorTokens dark = AppColorTokens(
    success: AppPalette.success80,
    onSuccess: AppPalette.success20,
    successContainer: AppPalette.success30,
    onSuccessContainer: AppPalette.success90,
    warning: AppPalette.warning80,
    onWarning: AppPalette.warning20,
    warningContainer: AppPalette.warning30,
    onWarningContainer: AppPalette.warning90,
    info: AppPalette.info80,
    onInfo: AppPalette.info20,
    infoContainer: AppPalette.info30,
    onInfoContainer: AppPalette.info90,
  );

  // Resolves the correct instance based on ColorScheme brightness.
  factory AppColorTokens.fromColorScheme({required ColorScheme colorScheme}) {
    return colorScheme.brightness == Brightness.dark ? dark : light;
  }

  // ── ThemeExtension overrides ───────────────────────────────────────────
  @override
  AppColorTokens copyWith({
    Color? success,
    Color? onSuccess,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? warning,
    Color? onWarning,
    Color? warningContainer,
    Color? onWarningContainer,
    Color? info,
    Color? onInfo,
    Color? infoContainer,
    Color? onInfoContainer,
  }) {
    return AppColorTokens(
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      successContainer: successContainer ?? this.successContainer,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      info: info ?? this.info,
      onInfo: onInfo ?? this.onInfo,
      infoContainer: infoContainer ?? this.infoContainer,
      onInfoContainer: onInfoContainer ?? this.onInfoContainer,
    );
  }

  @override
  AppColorTokens lerp(ThemeExtension<AppColorTokens>? other, double t) {
    if (other is! AppColorTokens) return this;
    return AppColorTokens(
      success: Color.lerp(success, other.success, t) ?? success,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t) ?? onSuccess,
      successContainer:
          Color.lerp(successContainer, other.successContainer, t) ??
          successContainer,
      onSuccessContainer:
          Color.lerp(onSuccessContainer, other.onSuccessContainer, t) ??
          onSuccessContainer,
      warning: Color.lerp(warning, other.warning, t) ?? warning,
      onWarning: Color.lerp(onWarning, other.onWarning, t) ?? onWarning,
      warningContainer:
          Color.lerp(warningContainer, other.warningContainer, t) ??
          warningContainer,
      onWarningContainer:
          Color.lerp(onWarningContainer, other.onWarningContainer, t) ??
          onWarningContainer,
      info: Color.lerp(info, other.info, t) ?? info,
      onInfo: Color.lerp(onInfo, other.onInfo, t) ?? onInfo,
      infoContainer:
          Color.lerp(infoContainer, other.infoContainer, t) ?? infoContainer,
      onInfoContainer:
          Color.lerp(onInfoContainer, other.onInfoContainer, t) ??
          onInfoContainer,
    );
  }

  @override
  int get hashCode => Object.hash(
    success,
    onSuccess,
    successContainer,
    onSuccessContainer,
    warning,
    onWarning,
    warningContainer,
    onWarningContainer,
    info,
    onInfo,
    infoContainer,
    onInfoContainer,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is AppColorTokens &&
        other.success == success &&
        other.onSuccess == onSuccess &&
        other.successContainer == successContainer &&
        other.onSuccessContainer == onSuccessContainer &&
        other.warning == warning &&
        other.onWarning == onWarning &&
        other.warningContainer == warningContainer &&
        other.onWarningContainer == onWarningContainer &&
        other.info == info &&
        other.onInfo == onInfo &&
        other.infoContainer == infoContainer &&
        other.onInfoContainer == onInfoContainer;
  }
}
