import 'package:flutter/material.dart';

@immutable
class AppThemeContractTokens extends ThemeExtension<AppThemeContractTokens> {
  const AppThemeContractTokens({required this.version});

  static const int currentVersion = 1;
  static const AppThemeContractTokens defaults = AppThemeContractTokens(
    version: currentVersion,
  );

  final int version;

  @override
  AppThemeContractTokens copyWith({int? version}) {
    return AppThemeContractTokens(version: version ?? this.version);
  }

  @override
  AppThemeContractTokens lerp(
    ThemeExtension<AppThemeContractTokens>? other,
    double t,
  ) {
    if (other is! AppThemeContractTokens) {
      return this;
    }
    if (t < 0.5) {
      return this;
    }
    return other;
  }

  @override
  int get hashCode => version.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is AppThemeContractTokens && other.version == version;
  }
}
