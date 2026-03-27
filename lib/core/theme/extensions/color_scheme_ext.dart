import 'package:flutter/material.dart';
import 'package:lumos/core/theme/tokens/tokens.dart';

@immutable
class ColorSchemeExt extends ThemeExtension<ColorSchemeExt> {
  const ColorSchemeExt({
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

  factory ColorSchemeExt.fallback() {
    return const ColorSchemeExt(
      success: AppColorTokens.success,
      onSuccess: AppColorTokens.onSuccess,
      successContainer: AppColorTokens.successContainer,
      onSuccessContainer: AppColorTokens.onSuccessContainer,
      warning: AppColorTokens.warning,
      onWarning: AppColorTokens.onWarning,
      warningContainer: AppColorTokens.warningContainer,
      onWarningContainer: AppColorTokens.onWarningContainer,
      info: AppColorTokens.info,
      onInfo: AppColorTokens.onInfo,
      infoContainer: AppColorTokens.infoContainer,
      onInfoContainer: AppColorTokens.onInfoContainer,
    );
  }

  factory ColorSchemeExt.fromBrightness(Brightness brightness) {
    if (brightness == Brightness.dark) {
      return const ColorSchemeExt(
        success: AppColorTokens.darkSuccess,
        onSuccess: AppColorTokens.darkOnSuccess,
        successContainer: AppColorTokens.darkSuccessContainer,
        onSuccessContainer: AppColorTokens.darkOnSuccessContainer,
        warning: AppColorTokens.darkWarning,
        onWarning: AppColorTokens.darkOnWarning,
        warningContainer: AppColorTokens.darkWarningContainer,
        onWarningContainer: AppColorTokens.darkOnWarningContainer,
        info: AppColorTokens.darkInfo,
        onInfo: AppColorTokens.darkOnInfo,
        infoContainer: AppColorTokens.darkInfoContainer,
        onInfoContainer: AppColorTokens.darkOnInfoContainer,
      );
    }

    return ColorSchemeExt.fallback();
  }

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

  @override
  ColorSchemeExt copyWith({
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
    return ColorSchemeExt(
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
  ColorSchemeExt lerp(ThemeExtension<ColorSchemeExt>? other, double t) {
    if (other is! ColorSchemeExt) {
      return this;
    }
    return ColorSchemeExt(
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
