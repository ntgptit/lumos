import 'package:flutter/material.dart';

import '../../../../../../core/themes/constants/dimensions.dart';
import '../../../../../shared/widgets/lumos_widgets.dart';

class FolderHeaderMetaPill extends StatelessWidget {
  const FolderHeaderMetaPill({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    super.key,
  });

  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Insets.spacing8,
        vertical: Insets.spacing4,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadii.medium,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconTheme(
            data: IconThemeData(color: foregroundColor),
            child: LumosIcon(icon, size: IconSizes.iconSmall),
          ),
          const SizedBox(width: Insets.spacing4),
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
