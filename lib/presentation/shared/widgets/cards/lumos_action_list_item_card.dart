import 'package:flutter/material.dart';

import '../navigation/lumos_menu_widgets.dart';
import 'lumos_entity_list_item_card.dart';

class LumosActionListItem {
  const LumosActionListItem({
    required this.key,
    required this.label,
  });

  final String key;
  final String label;
}

class LumosActionListItemCard extends StatelessWidget {
  const LumosActionListItemCard({
    required this.title,
    required this.actions,
    required this.onActionSelected,
    super.key,
    this.subtitle,
    this.leading,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final List<LumosActionListItem> actions;
  final ValueChanged<String> onActionSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return LumosEntityListItemCard(
      title: title,
      subtitle: subtitle,
      leading: leading,
      onTap: onTap,
      trailing: LumosPopupMenuButton<String>(
        onSelected: onActionSelected,
        itemBuilder: (BuildContext context) {
          return actions
              .map(
                (LumosActionListItem action) => PopupMenuItem<String>(
                  value: action.key,
                  child: Text(action.label),
                ),
              )
              .toList(growable: false);
        },
      ),
    );
  }
}
