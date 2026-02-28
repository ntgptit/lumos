import 'package:flutter/material.dart';

import '../../../../core/themes/constants/dimensions.dart';
import '../../../../core/themes/extensions/theme_extensions.dart';
import '../buttons/lumos_icon_button.dart';
import '../navigation/lumos_menu_widgets.dart';
import 'lumos_entity_list_item_card.dart';

// ---------------------------------------------------------------------------
// Constants
// ---------------------------------------------------------------------------

abstract final class LumosActionListItemCardConst {
  LumosActionListItemCardConst._();

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

  // Swipe threshold: fraction of card width to trigger action.
  static const double swipeThreshold = WidgetRatios.swipeRevealThreshold;
  static const double swipeIconSize = IconSizes.iconMedium;
  static const double swipeRevealWidth = WidgetSizes.swipeActionWidth;
}

// ---------------------------------------------------------------------------
// Tone enum — drives color of label, icon, and badge
// ---------------------------------------------------------------------------

/// Visual tone for a [LumosActionListItem].
///
/// - [neutral]  : Standard action — onSurface color.
/// - [warning]  : Cautionary action — tertiary color.
/// - [critical] : Destructive action — error color.
enum LumosActionListItemTone { neutral, warning, critical }

// ---------------------------------------------------------------------------
// Action model
// ---------------------------------------------------------------------------

/// Data model for a single action in [LumosActionListItemCard].
///
/// [key] must be unique within the actions list — it is passed to
/// [onActionSelected] as the identifier when the user selects an action.
class LumosActionListItem {
  const LumosActionListItem({
    required this.key,
    required this.label,
    this.icon,
    this.supportingText,
    this.badgeLabel,
    this.tone = LumosActionListItemTone.neutral,
    this.isEnabled = true,
    this.isLoading = false,
    this.showDividerAfter = false,
  });

  /// Unique identifier passed to [LumosActionListItemCard.onActionSelected].
  final String key;
  final String label;
  final IconData? icon;
  final String? supportingText;
  final String? badgeLabel;
  final LumosActionListItemTone tone;
  final bool isEnabled;

  /// Shows a loading indicator in place of [icon] while async action is running.
  final bool isLoading;

  /// Renders a [Divider] below this item in the popup menu.
  /// Useful for grouping related actions (e.g. edit/share | delete).
  final bool showDividerAfter;
}

// ---------------------------------------------------------------------------
// Swipe action model — for swipe-to-action behavior
// ---------------------------------------------------------------------------

/// Defines a single swipe reveal action shown when the user swipes the card.
class LumosSwipeAction {
  const LumosSwipeAction({
    required this.key,
    required this.icon,
    required this.label,
    this.tone = LumosActionListItemTone.neutral,
  });

  final String key;
  final IconData icon;
  final String label;
  final LumosActionListItemTone tone;
}

// ---------------------------------------------------------------------------
// Main widget
// ---------------------------------------------------------------------------

/// A list item card with a popup action menu and optional swipe-to-action.
///
/// Supports:
///   - Popup menu with [actions] (neutral / warning / critical tones)
///   - Dividers between action groups via [LumosActionListItem.showDividerAfter]
///   - Loading state per action via [LumosActionListItem.isLoading]
///   - Swipe-to-action via [swipeActions] (max 2 actions recommended)
///
/// Example — file list with swipe:
/// ```dart
/// LumosActionListItemCard(
///   title: 'Report Q4.pdf',
///   subtitle: '2.4 MB',
///   actions: [
///     LumosActionListItem(key: 'share', label: 'Share', icon: Icons.share),
///     LumosActionListItem(key: 'rename', label: 'Rename', icon: Icons.edit),
///     LumosActionListItem(showDividerAfter: true, key: 'divider', label: ''),
///     LumosActionListItem(
///       key: 'delete', label: 'Delete',
///       icon: Icons.delete, tone: LumosActionListItemTone.critical,
///     ),
///   ],
///   swipeActions: [
///     LumosSwipeAction(key: 'delete', icon: Icons.delete, tone: LumosActionListItemTone.critical, label: 'Delete'),
///   ],
///   onActionSelected: (key) => _handleAction(key),
/// )
/// ```
class LumosActionListItemCard extends StatelessWidget {
  const LumosActionListItemCard({
    required this.title,
    required this.actions,
    required this.onActionSelected,
    super.key,
    this.subtitle,
    this.leading,
    this.onTap,
    this.swipeActions,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final List<LumosActionListItem> actions;
  final ValueChanged<String> onActionSelected;
  final VoidCallback? onTap;

  /// Optional swipe-to-action. Recommended max 2 actions.
  /// Right swipe is not supported — only left swipe (end direction).
  final List<LumosSwipeAction>? swipeActions;

  @override
  Widget build(BuildContext context) {
    final Widget card = LumosEntityListItemCard(
      title: title,
      subtitle: subtitle,
      leading: leading,
      onTap: onTap,
      trailing: _buildTrailingMenu(),
    );

    final List<LumosSwipeAction>? resolvedSwipeActions = swipeActions;
    if (resolvedSwipeActions == null || resolvedSwipeActions.isEmpty) {
      return card;
    }

    return _SwipeActionWrapper(
      actions: resolvedSwipeActions,
      onActionSelected: onActionSelected,
      child: card,
    );
  }

  Widget _buildTrailingMenu() {
    return LumosPopupMenuButton<String>(
      onSelected: onActionSelected,
      icon: const LumosIconButton(
        icon: Icons.more_vert_rounded,
        variant: LumosIconButtonVariant.outlined,
      ),
      itemBuilder: (BuildContext context) => _buildMenuItems(context),
    );
  }

  List<PopupMenuEntry<String>> _buildMenuItems(BuildContext context) {
    final List<PopupMenuEntry<String>> entries = [];

    for (final LumosActionListItem action in actions) {
      // Divider-only item: renders a separator, not selectable.
      if (action.showDividerAfter && action.label.isEmpty) {
        entries.add(const PopupMenuDivider());
        continue;
      }

      entries.add(
        PopupMenuItem<String>(
          value: action.key,
          enabled: action.isEnabled && !action.isLoading,
          height: WidgetSizes.minTouchTarget,
          padding: LumosActionListItemCardConst.popupItemPadding,
          child: _ActionMenuItem(action: action),
        ),
      );

      if (action.showDividerAfter) {
        entries.add(const PopupMenuDivider());
      }
    }

    return entries;
  }
}

// ---------------------------------------------------------------------------
// Popup menu item
// ---------------------------------------------------------------------------

class _ActionMenuItem extends StatelessWidget {
  const _ActionMenuItem({required this.action});

  final LumosActionListItem action;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final Color labelColor = _resolveLabelColor(colorScheme: colorScheme);
    final IconThemeData iconTheme = theme.iconTheme.withResolvedColorAndSize(
      color: labelColor,
      size: IconSizes.iconSmall,
    );

    return IconTheme.merge(
      data: iconTheme,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildLeading(labelColor: labelColor),
          const SizedBox(width: LumosActionListItemCardConst.menuItemSpacing),
          Expanded(
            child: _buildLabelColumn(
              textTheme: theme.textTheme,
              colorScheme: colorScheme,
              labelColor: labelColor,
            ),
          ),
          if (action.badgeLabel case final String badgeLabelValue) ...[
            const SizedBox(width: LumosActionListItemCardConst.menuItemSpacing),
            _ActionBadge(label: badgeLabelValue),
          ],
        ],
      ),
    );
  }

  /// Leading slot: loading spinner when [isLoading], icon otherwise.
  Widget _buildLeading({required Color labelColor}) {
    if (action.isLoading) {
      return SizedBox.square(
        dimension: IconSizes.iconSmall,
        child: CircularProgressIndicator(
          strokeWidth: WidgetSizes.progressIndicatorStrokeWidth,
          color: labelColor,
        ),
      );
    }
    if (action.icon case final IconData iconValue) {
      return Icon(iconValue);
    }
    // Reserve space for alignment when no icon — keeps labels aligned across items.
    return const SizedBox(width: IconSizes.iconSmall);
  }

  Widget _buildLabelColumn({
    required TextTheme textTheme,
    required ColorScheme colorScheme,
    required Color labelColor,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          action.label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme.bodyMedium.withResolvedColor(labelColor),
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
              style: textTheme.labelSmall.withResolvedColor(
                colorScheme.onSurfaceVariant,
              ),
            ),
          ),
      ],
    );
  }

  Color _resolveLabelColor({required ColorScheme colorScheme}) {
    if (!action.isEnabled || action.isLoading) {
      return colorScheme.onSurfaceVariant;
    }
    return switch (action.tone) {
      LumosActionListItemTone.neutral => colorScheme.onSurface,
      LumosActionListItemTone.warning => colorScheme.tertiary,
      LumosActionListItemTone.critical => colorScheme.error,
    };
  }
}

// ---------------------------------------------------------------------------
// Badge
// ---------------------------------------------------------------------------

class _ActionBadge extends StatelessWidget {
  const _ActionBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

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
          style: theme.textTheme.labelSmall.withResolvedColor(
            colorScheme.onSecondaryContainer,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Swipe-to-action wrapper
// ---------------------------------------------------------------------------

class _SwipeActionWrapper extends StatefulWidget {
  const _SwipeActionWrapper({
    required this.actions,
    required this.onActionSelected,
    required this.child,
  });

  final List<LumosSwipeAction> actions;
  final ValueChanged<String> onActionSelected;
  final Widget child;

  @override
  State<_SwipeActionWrapper> createState() => _SwipeActionWrapperState();
}

class _SwipeActionWrapperState extends State<_SwipeActionWrapper> {
  final ValueNotifier<double> _dragExtentNotifier = ValueNotifier<double>(
    Insets.spacing0,
  );

  @override
  void dispose() {
    _dragExtentNotifier.dispose();
    super.dispose();
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    // Only allow left swipe (negative delta = end direction).
    if (details.delta.dx > 0 && _dragExtentNotifier.value == Insets.spacing0) {
      return;
    }
    final double nextExtent = (_dragExtentNotifier.value + details.delta.dx)
        .clamp(-LumosActionListItemCardConst.swipeRevealWidth, Insets.spacing0)
        .toDouble();
    _dragExtentNotifier.value = nextExtent;
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    final double threshold =
        LumosActionListItemCardConst.swipeRevealWidth *
        LumosActionListItemCardConst.swipeThreshold;
    final bool shouldReveal = _dragExtentNotifier.value.abs() >= threshold;
    if (shouldReveal) {
      _dragExtentNotifier.value =
          -LumosActionListItemCardConst.swipeRevealWidth;
      return;
    }
    _dragExtentNotifier.value = Insets.spacing0;
  }

  void _closeSwipe() {
    _dragExtentNotifier.value = Insets.spacing0;
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return ValueListenableBuilder<double>(
      valueListenable: _dragExtentNotifier,
      builder: (BuildContext context, double dragExtent, _) {
        return GestureDetector(
          onHorizontalDragUpdate: _onHorizontalDragUpdate,
          onHorizontalDragEnd: _onHorizontalDragEnd,
          child: Stack(
            children: [
              // Reveal layer — action buttons behind the card.
              Positioned.fill(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: _buildRevealActions(colorScheme: colorScheme),
                ),
              ),
              // Slide layer — card slides left to reveal actions.
              Transform.translate(
                offset: Offset(dragExtent, Insets.spacing0),
                child: GestureDetector(
                  onTap: dragExtent != Insets.spacing0 ? _closeSwipe : null,
                  child: widget.child,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRevealActions({required ColorScheme colorScheme}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: widget.actions
          .map((LumosSwipeAction action) {
            return _SwipeActionButton(
              action: action,
              colorScheme: colorScheme,
              onTap: () {
                _closeSwipe();
                widget.onActionSelected(action.key);
              },
            );
          })
          .toList(growable: false),
    );
  }
}

// ---------------------------------------------------------------------------
// Swipe action button
// ---------------------------------------------------------------------------

class _SwipeActionButton extends StatelessWidget {
  const _SwipeActionButton({
    required this.action,
    required this.colorScheme,
    required this.onTap,
  });

  final LumosSwipeAction action;
  final ColorScheme colorScheme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color bgColor = _resolveBackground();
    final Color fgColor = _resolveForeground();
    final TextTheme textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: LumosActionListItemCardConst.swipeRevealWidth,
        color: bgColor,
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              action.icon,
              color: fgColor,
              size: LumosActionListItemCardConst.swipeIconSize,
            ),
            const SizedBox(height: LumosActionListItemCardConst.contentSpacing),
            Text(
              action.label,
              style: textTheme.labelSmall.withResolvedColor(fgColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Color _resolveBackground() {
    return switch (action.tone) {
      LumosActionListItemTone.neutral => colorScheme.secondaryContainer,
      LumosActionListItemTone.warning => colorScheme.tertiaryContainer,
      LumosActionListItemTone.critical => colorScheme.errorContainer,
    };
  }

  Color _resolveForeground() {
    return switch (action.tone) {
      LumosActionListItemTone.neutral => colorScheme.onSecondaryContainer,
      LumosActionListItemTone.warning => colorScheme.onTertiaryContainer,
      LumosActionListItemTone.critical => colorScheme.onErrorContainer,
    };
  }
}
