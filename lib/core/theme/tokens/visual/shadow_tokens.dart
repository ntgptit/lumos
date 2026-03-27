import 'package:flutter/material.dart';
import 'color_tokens.dart';

abstract final class AppShadowTokens {
  static const soft = [
    BoxShadow(
      color: AppColorTokens.shadow,
      blurRadius: 12,
      offset: Offset(0, 6),
    ),
  ];

  static const medium = [
    BoxShadow(
      color: AppColorTokens.shadow,
      blurRadius: 18,
      offset: Offset(0, 10),
    ),
  ];

  static const strong = [
    BoxShadow(
      color: AppColorTokens.shadow,
      blurRadius: 28,
      offset: Offset(0, 16),
    ),
  ];
}
