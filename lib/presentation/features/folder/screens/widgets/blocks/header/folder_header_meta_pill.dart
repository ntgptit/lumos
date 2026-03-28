import 'package:flutter/material.dart';

import '../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../shared/widgets/lumos_widgets.dart';

class FolderHeaderMetaPill extends StatelessWidget {
  const FolderHeaderMetaPill({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    this.expandLabel = false,
    super.key,
  });

  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final bool expandLabel;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final EdgeInsets padding = ResponsiveDimensions.compactInsets(
      context: context,
      baseInsets: const EdgeInsets.symmetric(
        horizontal: LumosSpacing.sm,
        vertical: LumosSpacing.xs,
      ),
    );
    final double inlineGap = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.xs,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadii.medium,
      ),
      child: Row(
        mainAxisSize: expandLabel ? MainAxisSize.max : MainAxisSize.min,
        children: <Widget>[
          IconTheme(
            data: IconThemeData(color: foregroundColor),
            child: LumosIcon(icon, size: IconSizes.iconSmall),
          ),
          SizedBox(width: inlineGap),
          if (expandLabel)
            Expanded(
              child: LumosInlineText(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.labelMedium?.copyWith(color: foregroundColor),
              ),
            ),
          if (!expandLabel)
            LumosInlineText(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.labelMedium?.copyWith(color: foregroundColor),
            ),
        ],
      ),
    );
  }
}
