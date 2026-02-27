import 'package:flutter/material.dart';

import '../../../../core/themes/constants/dimensions.dart';
import '../buttons/lumos_icon_button.dart';
import '../feedback/lumos_progress_bar.dart';
import '../typography/lumos_text.dart';
import 'lumos_card.dart';

class LumosDeckCard extends StatelessWidget {
  const LumosDeckCard({
    required this.title,
    required this.cardCount,
    required this.dueCount,
    required this.progress,
    required this.onTap,
    super.key,
    this.description,
    this.onEdit,
    this.onDelete,
  });

  final String title;
  final String? description;
  final int cardCount;
  final int dueCount;
  final double progress;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return LumosCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: LumosText(
                  title,
                  style: LumosTextStyle.titleMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              ..._buildActions(),
            ],
          ),
          ..._buildDescription(),
          const SizedBox(height: Insets.gapBetweenItems),
          LumosText(
            '$cardCount cards • $dueCount due today',
            style: LumosTextStyle.labelMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: Insets.spacing8),
          LumosProgressBar(value: progress),
        ],
      ),
    );
  }

  List<Widget> _buildDescription() {
    if (description == null) {
      return const <Widget>[];
    }
    return <Widget>[
      const SizedBox(height: Insets.spacing8),
      LumosText(
        description!,
        style: LumosTextStyle.bodySmall,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    ];
  }

  List<Widget> _buildActions() {
    if (onEdit == null && onDelete == null) {
      return const <Widget>[];
    }
    return <Widget>[
      if (onEdit != null)
        LumosIconButton(
          icon: Icons.edit_outlined,
          onPressed: onEdit,
          tooltip: 'Edit deck',
        ),
      if (onDelete != null)
        LumosIconButton(
          icon: Icons.delete_outline,
          onPressed: onDelete,
          tooltip: 'Delete deck',
        ),
    ];
  }
}
