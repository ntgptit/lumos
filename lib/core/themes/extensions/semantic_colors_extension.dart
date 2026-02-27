import 'package:flutter/material.dart';

class AppSemanticColorsConst {
  const AppSemanticColorsConst._();

  static const Color successSeed = Color(0xFF2E7D32);
  static const Color warningSeed = Color(0xFFF9A825);
  static const Color infoSeed = Color(0xFF1565C0);
}

class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  const AppSemanticColors({
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

  factory AppSemanticColors.fromColorScheme({
    required ColorScheme colorScheme,
  }) {
    final Brightness brightness = colorScheme.brightness;
    final ColorScheme successScheme = ColorScheme.fromSeed(
      seedColor: AppSemanticColorsConst.successSeed,
      brightness: brightness,
    );
    final ColorScheme warningScheme = ColorScheme.fromSeed(
      seedColor: AppSemanticColorsConst.warningSeed,
      brightness: brightness,
    );
    final ColorScheme infoScheme = ColorScheme.fromSeed(
      seedColor: AppSemanticColorsConst.infoSeed,
      brightness: brightness,
    );
    return AppSemanticColors(
      success: successScheme.primary,
      onSuccess: successScheme.onPrimary,
      successContainer: successScheme.primaryContainer,
      onSuccessContainer: successScheme.onPrimaryContainer,
      warning: warningScheme.primary,
      onWarning: warningScheme.onPrimary,
      warningContainer: warningScheme.primaryContainer,
      onWarningContainer: warningScheme.onPrimaryContainer,
      info: infoScheme.primary,
      onInfo: infoScheme.onPrimary,
      infoContainer: infoScheme.primaryContainer,
      onInfoContainer: infoScheme.onPrimaryContainer,
    );
  }

  @override
  AppSemanticColors copyWith({
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
    return AppSemanticColors(
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
  AppSemanticColors lerp(
    covariant ThemeExtension<AppSemanticColors>? other,
    double t,
  ) {
    if (other is! AppSemanticColors) {
      return this;
    }
    return AppSemanticColors(
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
}
