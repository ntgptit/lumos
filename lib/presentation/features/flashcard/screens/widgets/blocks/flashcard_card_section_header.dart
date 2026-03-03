import 'package:flutter/material.dart';

import '../../../../../shared/widgets/lumos_widgets.dart';

class FlashcardCardSectionHeader extends StatelessWidget {
  const FlashcardCardSectionHeader({
    required this.title,
    required this.subtitle,
    required this.sortLabel,
    required this.onSortPressed,
    super.key,
  });

  final String title;
  final String subtitle;
  final String sortLabel;
  final VoidCallback onSortPressed;

  @override
  Widget build(BuildContext context) {
    return LumosListTile(
      title: LumosInlineText(title),
      subtitle: LumosInlineText(subtitle),
      trailing: LumosButton(
        onPressed: onSortPressed,
        icon: Icons.tune_rounded,
        label: sortLabel,
        type: LumosButtonType.outline,
        size: LumosButtonSize.small,
      ),
    );
  }
}
