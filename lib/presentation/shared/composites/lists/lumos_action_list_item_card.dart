import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/presentation/shared/composites/lists/lumos_action_list_item.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_card.dart';

class LumosActionListItemCard extends StatelessWidget {
  const LumosActionListItemCard({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.onTap,
    this.actions = const <LumosActionListItem>[],
    this.onActionSelected,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final VoidCallback? onTap;
  final List<LumosActionListItem> actions;
  final ValueChanged<String>? onActionSelected;

  @override
  Widget build(BuildContext context) {
    final minHeight =
        context.component.listItemLeadingSize + (context.spacing.lg * 2);

    return LumosCard(
      minHeight: minHeight,
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: context.component.cardPadding,
          vertical: context.spacing.xs,
        ),
        leading: leading,
        title: Text(title),
        subtitle: subtitle == null ? null : Text(subtitle!),
        trailing: actions.isEmpty
            ? null
            : PopupMenuButton<String>(
                onSelected: onActionSelected,
                itemBuilder: (context) {
                  return actions
                      .map((action) {
                        final color =
                            action.tone == LumosActionListItemTone.critical
                            ? context.colorScheme.error
                            : null;
                        return PopupMenuItem<String>(
                          value: action.key,
                          child: Row(
                            children: [
                              Icon(action.icon, color: color),
                              SizedBox(width: context.spacing.sm),
                              Expanded(
                                child: Text(
                                  action.label,
                                  style: color == null
                                      ? null
                                      : TextStyle(color: color),
                                ),
                              ),
                            ],
                          ),
                        );
                      })
                      .toList(growable: false);
                },
              ),
      ),
    );
  }
}
