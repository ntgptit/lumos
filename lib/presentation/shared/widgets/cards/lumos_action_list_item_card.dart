import 'package:flutter/material.dart';

import '../../../../core/themes/constants/dimensions.dart';
import '../buttons/lumos_icon_button.dart';
import '../navigation/lumos_menu_widgets.dart';
import 'lumos_entity_list_item_card.dart';

class LumosActionListItemCardConst {
  const LumosActionListItemCardConst._();

  static const EdgeInsets popupItemPadding = EdgeInsets.symmetric(
    horizontal: Insets.spacing12,
    vertical: Insets.spacing8,
  );
  static const EdgeInsetsGeometry badgePadding = EdgeInsets.symmetric(
    horizontal: Insets.spacing8,
    vertical: Insets.spacing4,
  );
  static const double menuItemSpacing = Insets.spacing12;
  static const double contentSpacing = Insets.spacing4;
}

enum LumosActionListItemTone { neutral, critical }

class LumosActionListItem {
  const LumosActionListItem({
    required this.key,
    required this.label,
    this.icon,
    this.supportingText,
    this.badgeLabel,
    this.tone = LumosActionListItemTone.neutral,
    this.isEnabled = true,
  });

  final String key;
  final String label;
  final IconData? icon;
  final String? supportingText;
  final String? badgeLabel;
  final LumosActionListItemTone tone;
  final bool isEnabled;
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
    final Widget trailingMenu = _buildTrailingMenu();
    return LumosEntityListItemCard(
      title: title,
      subtitle: subtitle,
      leading: leading,
      onTap: onTap,
      trailing: trailingMenu,
    );
  }

  Widget _buildTrailingMenu() {
    return LumosPopupMenuButton<String>(
      onSelected: onActionSelected,
      icon: const LumosIconButton(
        icon: Icons.more_vert_rounded,
        variant: LumosIconButtonVariant.outlined,
      ),
      itemBuilder: (BuildContext context) {
        return actions
            .map((LumosActionListItem action) {
              return PopupMenuItem<String>(
                value: action.key,
                enabled: action.isEnabled,
                height: WidgetSizes.minTouchTarget,
                padding: LumosActionListItemCardConst.popupItemPadding,
                child: _ActionMenuItem(action: action),
              );
            })
            .toList(growable: false);
      },
    );
  }
}

class _ActionMenuItem extends StatelessWidget {
  const _ActionMenuItem({required this.action});

  final LumosActionListItem action;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final ColorScheme colorScheme = theme.colorScheme;
    final Color labelColor = _resolveLabelColor(colorScheme: colorScheme);
    final Widget content = _buildContent(
      textTheme: textTheme,
      labelColor: labelColor,
      colorScheme: colorScheme,
    );
    return IconTheme.merge(
      data: IconThemeData(color: labelColor, size: IconSizes.iconSmall),
      child: content,
    );
  }

  Widget _buildContent({
    required TextTheme textTheme,
    required Color labelColor,
    required ColorScheme colorScheme,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (action.icon case final IconData iconValue) ...<Widget>[
          Icon(iconValue),
          const SizedBox(width: LumosActionListItemCardConst.menuItemSpacing),
        ],
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                action.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyMedium?.copyWith(color: labelColor),
              ),
              if (action.supportingText case final String supportingTextValue)
                Padding(
                  padding: const EdgeInsets.only(
                    top: LumosActionListItemCardConst.contentSpacing,
                  ),
                  child: Text(
                    supportingTextValue,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (action.badgeLabel case final String badgeLabelValue) ...<Widget>[
          const SizedBox(width: LumosActionListItemCardConst.menuItemSpacing),
          _ActionBadge(label: badgeLabelValue, colorScheme: colorScheme),
        ],
      ],
    );
  }

  Color _resolveLabelColor({required ColorScheme colorScheme}) {
    if (!action.isEnabled) {
      return colorScheme.onSurfaceVariant;
    }
    if (action.tone == LumosActionListItemTone.critical) {
      return colorScheme.error;
    }
    return colorScheme.onSurface;
  }
}

class _ActionBadge extends StatelessWidget {
  const _ActionBadge({required this.label, required this.colorScheme});

  final String label;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: BorderRadii.large,
      ),
      child: Padding(
        padding: LumosActionListItemCardConst.badgePadding,
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme.labelSmall?.copyWith(
            color: colorScheme.onSecondaryContainer,
          ),
        ),
      ),
    );
  }
}
