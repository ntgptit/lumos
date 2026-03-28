import 'package:flutter/material.dart';
import 'package:lumos/core/theme/tokens/layout/radius_tokens.dart';

abstract final class BorderRadii {
  static const BorderRadius small = BorderRadius.all(
    Radius.circular(AppRadiusTokens.sm),
  );
  static const BorderRadius medium = BorderRadius.all(
    Radius.circular(AppRadiusTokens.md),
  );
  static const BorderRadius large = BorderRadius.all(
    Radius.circular(AppRadiusTokens.lg),
  );
  static const BorderRadius xLarge = BorderRadius.all(
    Radius.circular(AppRadiusTokens.xl),
  );
  static const BorderRadius extraLarge = BorderRadius.all(
    Radius.circular(AppRadiusTokens.xl),
  );
  static const BorderRadius pill = BorderRadius.all(
    Radius.circular(AppRadiusTokens.pill),
  );
}
