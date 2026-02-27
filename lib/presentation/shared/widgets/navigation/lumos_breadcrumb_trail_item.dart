import 'package:flutter/material.dart';

import '../../../../core/themes/constants/dimensions.dart';

class LumosBreadcrumbTrailItem extends StatelessWidget {
  const LumosBreadcrumbTrailItem({
    required this.label,
    required this.icon,
    required this.isCurrent,
    required this.isInteractive,
    required this.onPressed,
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.iconBadgeSize,
    required this.iconSize,
    required this.mobileLabelMaxWidth,
    required this.tabletLabelMaxWidth,
    required this.desktopLabelMaxWidth,
    super.key,
  });

  final String label;
  final IconData icon;
  final bool isCurrent;
  final bool isInteractive;
  final VoidCallback onPressed;
  final double horizontalPadding;
  final double verticalPadding;
  final double iconBadgeSize;
  final double iconSize;
  final double mobileLabelMaxWidth;
  final double tabletLabelMaxWidth;
  final double desktopLabelMaxWidth;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final Widget content = AnimatedContainer(
      duration: AppDurations.fast,
      curve: Curves.easeOutCubic,
      constraints: const BoxConstraints(minHeight: WidgetSizes.minTouchTarget),
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        color: _resolveBackgroundColor(colorScheme: colorScheme),
        borderRadius: BorderRadii.large,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: iconBadgeSize,
            height: iconBadgeSize,
            decoration: BoxDecoration(
              color: _resolveIconBadgeColor(colorScheme: colorScheme),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: iconSize,
              color: _resolveIconColor(colorScheme: colorScheme),
            ),
          ),
          const SizedBox(width: Insets.spacing8),
          SizedBox(
            width: _resolveLabelWidth(context: context),
            child: Text(
              label,
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: _resolveForegroundColor(colorScheme: colorScheme),
                fontWeight: _resolveFontWeight(),
              ),
            ),
          ),
        ],
      ),
    );
    if (!isInteractive) {
      return content;
    }
    return InkWell(
      borderRadius: BorderRadii.large,
      onTap: onPressed,
      child: content,
    );
  }

  FontWeight _resolveFontWeight() {
    if (isInteractive) {
      return FontWeight.w500;
    }
    return FontWeight.w600;
  }

  Color _resolveBackgroundColor({required ColorScheme colorScheme}) {
    if (isCurrent) {
      return colorScheme.surface;
    }
    if (isInteractive) {
      return colorScheme.surfaceContainerHighest;
    }
    return colorScheme.surface;
  }

  Color _resolveForegroundColor({required ColorScheme colorScheme}) {
    if (isInteractive) {
      return colorScheme.onSurfaceVariant;
    }
    return colorScheme.onSurface;
  }

  Color _resolveIconBadgeColor({required ColorScheme colorScheme}) {
    if (isCurrent) {
      return colorScheme.surfaceContainerHigh;
    }
    return colorScheme.surface;
  }

  Color _resolveIconColor({required ColorScheme colorScheme}) {
    if (isInteractive) {
      return colorScheme.onSurfaceVariant;
    }
    return colorScheme.onSurface;
  }

  double _resolveLabelWidth({required BuildContext context}) {
    if (context.isMobile) {
      return mobileLabelMaxWidth;
    }
    if (context.isTablet) {
      return tabletLabelMaxWidth;
    }
    return desktopLabelMaxWidth;
  }
}
