import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';

class FlashcardStudyActionCard extends StatelessWidget {
  const FlashcardStudyActionCard({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.onPressed,
    required this.isFullWidth,
    required this.minHeight,
    required this.iconContainerSize,
    required this.iconSize,
    required this.titleTopSpacing,
    required this.subtitleTopSpacing,
    required this.cardVerticalPadding,
    required this.cardHorizontalPadding,
    required this.backgroundColor,
    required this.containerColor,
    required this.iconColor,
    required this.titleColor,
    required this.subtitleColor,
    super.key,
  });

  final String label;
  final String subtitle;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isFullWidth;
  final double minHeight;
  final double iconContainerSize;
  final double iconSize;
  final double titleTopSpacing;
  final double subtitleTopSpacing;
  final double cardVerticalPadding;
  final double cardHorizontalPadding;
  final Color backgroundColor;
  final Color containerColor;
  final Color iconColor;
  final Color titleColor;
  final Color subtitleColor;

  @override
  Widget build(BuildContext context) {
    final TextStyle? titleStyle = isFullWidth
        ? Theme.of(context).textTheme.titleLarge?.copyWith(
            color: titleColor,
            fontWeight: FontWeight.w700,
          )
        : Theme.of(context).textTheme.titleMedium?.copyWith(
            color: titleColor,
            fontWeight: FontWeight.w700,
          );
    final TextStyle? subtitleStyle = Theme.of(
      context,
    ).textTheme.bodySmall?.copyWith(color: subtitleColor);
    final Widget iconBadge = Container(
      width: iconContainerSize,
      height: iconContainerSize,
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: context.shapes.card,
      ),
      child: IconTheme(
        data: IconThemeData(color: iconColor, size: iconSize),
        child: LumosIcon(icon),
      ),
    );
    final Widget content = isFullWidth
        ? Row(
            children: <Widget>[
              iconBadge,
              SizedBox(width: titleTopSpacing),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    LumosInlineText(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: titleStyle,
                    ),
                    SizedBox(height: subtitleTopSpacing),
                    LumosInlineText(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: subtitleStyle,
                    ),
                  ],
                ),
              ),
              IconTheme(
                data: IconThemeData(
                  color: subtitleColor,
                  size: IconSizes.iconMedium,
                ),
                child: const LumosIcon(Icons.chevron_right_rounded),
              ),
            ],
          )
        : Column(
            children: <Widget>[
              ConstrainedBox(
                constraints: BoxConstraints(minHeight: _contentMinHeight()),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    iconBadge,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        LumosInlineText(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: titleStyle,
                        ),
                        SizedBox(height: subtitleTopSpacing),
                        LumosInlineText(
                          subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: subtitleStyle,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
    return Theme(
      data: Theme.of(context).copyWith(
        cardTheme: Theme.of(context).cardTheme.copyWith(color: backgroundColor),
      ),
      child: LumosCard(
        minHeight: minHeight,
        padding: EdgeInsets.symmetric(
          horizontal: cardHorizontalPadding,
          vertical: cardVerticalPadding,
        ),
        borderRadius: context.shapes.card,
        elevation: LumosSpacing.none,
        onTap: onPressed,
        child: content,
      ),
    );
  }

  double _contentMinHeight() {
    final double resolvedHeight = minHeight - (cardVerticalPadding * 2);
    if (resolvedHeight < LumosSpacing.none) {
      return LumosSpacing.none;
    }
    return resolvedHeight;
  }
}
