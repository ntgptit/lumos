import 'package:flutter/material.dart';

import '../../../../core/themes/constants/dimensions.dart';
import '../typography/lumos_text.dart';
import 'lumos_card.dart';

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
      padding: const EdgeInsets.all(Insets.spacing12),
      child: Row(
        children: <Widget>[
          if (leading case final Widget value) ...<Widget>[
            value,
            const SizedBox(width: Insets.spacing12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                LumosText(
                  title,
                  style: LumosTextStyle.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle case final String value)
                  LumosText(value, style: LumosTextStyle.labelSmall),
              ],
            ),
          ),
          if (trailing case final Widget value) ...<Widget>[
            const SizedBox(width: Insets.spacing8),
            value,
          ],
        ],
      ),
    );
  }
}
