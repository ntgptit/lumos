import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/presentation/shared/composites/lists/lumos_action_list_item.dart';
import 'package:lumos/presentation/shared/composites/text/lumos_inline_text.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_popup_menu_button.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_card.dart';
import 'package:lumos/presentation/shared/primitives/text/lumos_caption_text.dart';

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
    final contentInset = context.component.cardPadding;
    final titleGap = context.spacing.xxs;
    double minHeight =
        context.component.buttonHeight + (context.spacing.sm * 2);
    final double leadingMinHeight =
        context.component.listItemLeadingSize + (contentInset * 2);
    if (leadingMinHeight > minHeight) {
      minHeight = leadingMinHeight;
    }

    return LumosCard(
      minHeight: minHeight,
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(contentInset),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (leading != null) ...<Widget>[
              leading!,
              SizedBox(width: context.spacing.sm),
            ],
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  LumosInlineText(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.titleSmall,
                  ),
                  if (subtitle != null) ...<Widget>[
                    SizedBox(height: titleGap),
                    LumosCaptionText(
                      text: subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            if (actions.isNotEmpty) ...<Widget>[
              SizedBox(width: context.spacing.xs),
              LumosPopupMenuButton<String>(
                onSelected: onActionSelected,
                itemBuilder: (context) {
                  return actions
                      .map((action) {
                        return LumosPopupMenuActionItem<String>(
                          value: action.key,
                          label: action.label,
                          icon: action.icon,
                          supportingText: action.supportingText,
                          tone: action.tone == LumosActionListItemTone.critical
                              ? LumosPopupMenuItemTone.critical
                              : LumosPopupMenuItemTone.standard,
                        );
                      })
                      .toList(growable: false);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
