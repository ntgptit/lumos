import 'package:flutter/material.dart';

@immutable
class AppTextTokens extends ThemeExtension<AppTextTokens> {
  const AppTextTokens({
    required this.bodyMediumStrong,
    required this.bodySmallMuted,
    required this.labelMediumLink,
  });

  final TextStyle bodyMediumStrong;
  final TextStyle bodySmallMuted;
  final TextStyle labelMediumLink;

  factory AppTextTokens.fromTheme({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    final TextStyle baseBodyMedium = textTheme.bodyMedium ?? const TextStyle();
    final TextStyle baseBodySmall = textTheme.bodySmall ?? const TextStyle();
    final TextStyle baseLabelMedium =
        textTheme.labelMedium ?? const TextStyle();
    return AppTextTokens(
      bodyMediumStrong: baseBodyMedium.copyWith(fontWeight: FontWeight.w700),
      bodySmallMuted: baseBodySmall.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
      labelMediumLink: baseLabelMedium.copyWith(
        color: colorScheme.primary,
        decoration: TextDecoration.underline,
      ),
    );
  }

  @override
  AppTextTokens copyWith({
    TextStyle? bodyMediumStrong,
    TextStyle? bodySmallMuted,
    TextStyle? labelMediumLink,
  }) {
    return AppTextTokens(
      bodyMediumStrong: bodyMediumStrong ?? this.bodyMediumStrong,
      bodySmallMuted: bodySmallMuted ?? this.bodySmallMuted,
      labelMediumLink: labelMediumLink ?? this.labelMediumLink,
    );
  }

  @override
  AppTextTokens lerp(ThemeExtension<AppTextTokens>? other, double t) {
    if (other is! AppTextTokens) {
      return this;
    }
    return AppTextTokens(
      bodyMediumStrong:
          TextStyle.lerp(bodyMediumStrong, other.bodyMediumStrong, t) ??
          bodyMediumStrong,
      bodySmallMuted:
          TextStyle.lerp(bodySmallMuted, other.bodySmallMuted, t) ??
          bodySmallMuted,
      labelMediumLink:
          TextStyle.lerp(labelMediumLink, other.labelMediumLink, t) ??
          labelMediumLink,
    );
  }
}
