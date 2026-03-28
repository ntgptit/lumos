import 'package:flutter/material.dart';

import 'package:lumos/core/theme/responsive/adaptive_radius.dart';

@immutable
class AdaptiveShapeRoles {
  const AdaptiveShapeRoles({
    required this.control,
    required this.chip,
    required this.card,
    required this.sheet,
    required this.dialog,
    required this.hero,
    required this.pill,
  });

  factory AdaptiveShapeRoles.fromRadius(AdaptiveRadius radius) {
    return AdaptiveShapeRoles(
      control: BorderRadius.circular(radius.sm),
      chip: BorderRadius.circular(radius.sm),
      card: BorderRadius.circular(radius.md),
      sheet: BorderRadius.circular(radius.md),
      dialog: BorderRadius.circular(radius.md),
      hero: BorderRadius.circular(radius.lg),
      pill: BorderRadius.circular(radius.pill),
    );
  }

  final BorderRadius control;
  final BorderRadius chip;
  final BorderRadius card;
  final BorderRadius sheet;
  final BorderRadius dialog;
  final BorderRadius hero;
  final BorderRadius pill;
}
