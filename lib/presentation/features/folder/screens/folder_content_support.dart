import '../../../../core/themes/foundation/app_foundation.dart';
import 'package:flutter/material.dart';

abstract final class FolderContentSupportConst {
  FolderContentSupportConst._();

  static const double listBottomSpacing = LumosSpacing.canvas;
  static const double loadMoreThreshold = LumosSpacing.canvas;
  static const double scrollTopOffset = LumosSpacing.none;
  static const double scrollTopTriggerOffset = LumosSpacing.sm;
  static const Duration scrollTopDuration = AppDurations.fast;
  static const double loadMoreTopSpacing = LumosSpacing.md;
  static const double loadMoreBottomSpacing = LumosSpacing.sm;
  static const double createActionSheetHorizontalPadding = LumosSpacing.lg;
  static const double createActionSheetVerticalPadding = LumosSpacing.md;
  static const double createActionSheetBottomPadding = LumosSpacing.lg;
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
