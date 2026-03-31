import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';

class HomeSplitFocusItem extends StatelessWidget {
  const HomeSplitFocusItem({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.progressValue,
    required this.itemSpacing,
    required this.inlineGap,
    super.key,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final double progressValue;
  final double itemSpacing;
  final double inlineGap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        IconTheme(
          data: IconThemeData(color: iconColor),
          child: LumosIcon(
            icon,
            size: context.iconSize.sm,
          ),
        ),
        SizedBox(width: inlineGap),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              LumosText(label, style: LumosTextStyle.bodySmall),
              SizedBox(height: itemSpacing * 0.5),
              LumosValueBar(value: progressValue),
            ],
          ),
        ),
      ],
    );
  }
}
