import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';

class AppCounterBadge extends StatelessWidget {
  const AppCounterBadge({
    super.key,
    required this.count,
    required this.child,
    this.maxCount = 99,
    this.isVisible = true,
    this.backgroundColor,
    this.textColor,
  });

  final int count;
  final Widget child;
  final int maxCount;
  final bool isVisible;
  final Color? backgroundColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final displayCount = count > maxCount ? '$maxCount+' : '$count';
    return Badge(
      isLabelVisible: isVisible && count > 0,
      label: Text(displayCount),
      backgroundColor: backgroundColor ?? context.colorScheme.error,
      textColor: textColor ?? context.colorScheme.onError,
      child: child,
    );
  }
}
