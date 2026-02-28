import 'package:flutter/material.dart';

import '../../../../core/themes/constants/dimensions.dart';
import '../typography/lumos_text.dart';
import 'lumos_card.dart';

class LumosEntityListItemCardConst {
  const LumosEntityListItemCardConst._();

  static const EdgeInsetsGeometry contentPadding = EdgeInsets.symmetric(
    horizontal: Insets.spacing16,
    vertical: Insets.spacing4,
  );
  static const double subtitleTopSpacing = Insets.spacing4;
}

class LumosEntityListItemCard extends StatelessWidget {
  const LumosEntityListItemCard({
    required this.title,
    super.key,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return LumosCard(
      onTap: onTap,
      variant: LumosCardVariant.outlined,
      padding: EdgeInsets.zero,
      child: ListTile(
        contentPadding: LumosEntityListItemCardConst.contentPadding,
        leading: leading,
        trailing: trailing,
        title: LumosText(
          title,
          style: LumosTextStyle.titleMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: _buildSubtitle(),
      ),
    );
  }

  Widget? _buildSubtitle() {
    if (subtitle == null) {
      return null;
    }
    return Padding(
      padding: const EdgeInsets.only(
        top: LumosEntityListItemCardConst.subtitleTopSpacing,
      ),
      child: LumosText(
        subtitle!,
        style: LumosTextStyle.bodySmall,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
