import '../../../../core/themes/foundation/app_foundation.dart';
import 'package:flutter/material.dart';

abstract final class FolderContentSupportConst {
  FolderContentSupportConst._();

  static const double listBottomSpacing = AppSpacing.canvas;
  static const double loadMoreThreshold = AppSpacing.canvas;
  static const double scrollTopOffset = AppSpacing.none;
  static const double scrollTopTriggerOffset = AppSpacing.sm;
  static const Duration scrollTopDuration = AppDurations.fast;
  static const double loadMoreTopSpacing = AppSpacing.md;
  static const double loadMoreBottomSpacing = AppSpacing.sm;
  static const double createActionSheetHorizontalPadding = AppSpacing.lg;
  static const double createActionSheetVerticalPadding = AppSpacing.md;
  static const double createActionSheetBottomPadding = AppSpacing.lg;
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
