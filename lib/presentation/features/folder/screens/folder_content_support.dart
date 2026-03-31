import 'package:lumos/core/theme/app_foundation.dart';
import 'package:flutter/material.dart';

abstract final class FolderContentSupportConst {
  FolderContentSupportConst._();

  static const double listBottomSpacing =
      96;
  static const double loadMoreThreshold =
      96;
  static const double scrollTopOffset =
      0;
  static const double scrollTopTriggerOffset =
      12;
  static const Duration scrollTopDuration =
      AppMotion.fast;
  static const double loadMoreTopSpacing =
      16;
  static const double loadMoreBottomSpacing =
      12;
  static const double createActionSheetHorizontalPadding =
      24;
  static const double createActionSheetVerticalPadding =
      16;
  static const double createActionSheetBottomPadding =
      24;
}

class FolderContentSupportCreateAction {
  const FolderContentSupportCreateAction({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
}
