import 'package:flutter/material.dart';

import '../../../../core/themes/constants/dimensions.dart';
import '../typography/lumos_text.dart';
import 'lumos_card.dart';

// ---------------------------------------------------------------------------
// Constants
// ---------------------------------------------------------------------------

abstract final class LumosEntityListItemCardConst {
  LumosEntityListItemCardConst._();

  static const double minHeight = WidgetSizes.minTouchTarget; // 48dp

  // Horizontal content padding — matches screen padding for visual alignment.
  static const EdgeInsets contentPaddingMobile = EdgeInsets.symmetric(
    horizontal: Insets.spacing16,
    vertical: Insets.spacing12,
  );
  static const EdgeInsets contentPaddingTablet = EdgeInsets.symmetric(
    horizontal: Insets.spacing20,
    vertical: Insets.spacing12,
  );

  // Gap between leading widget and text content.
  static const double leadingGap = Insets.spacing12;

  // Gap between text content and trailing widget.
  static const double trailingGap = Insets.spacing8;

  // Gap between title and subtitle.
  static const double subtitleGap = Insets.spacing4;

  // Checkbox size in multi-select mode.
  static const double checkboxSize = IconSizes.iconMedium; // 24dp

  // Swipe action panel width per action button.
  static const double swipeActionWidth = 64.0;

  // Swipe reveal threshold (fraction of widget width).
  static const double swipeExtentRatio = 0.25;

  static const Duration swipeAnimationDuration = AppDurations.medium;
}

// ---------------------------------------------------------------------------
// Swipe action model
// ---------------------------------------------------------------------------

/// Defines a single swipe action revealed when the user swipes left.
class LumosSwipeAction {
  const LumosSwipeAction({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.backgroundColor,
    this.iconColor,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  /// Defaults to [ColorScheme.secondaryContainer] if null.
  final Color? backgroundColor;

  /// Defaults to [ColorScheme.onSecondaryContainer] if null.
  final Color? iconColor;
}

// ---------------------------------------------------------------------------
// Context menu item model
// ---------------------------------------------------------------------------

/// Defines a single item in the long-press context menu.
class LumosContextMenuItem {
  const LumosContextMenuItem({
    required this.label,
    required this.onPressed,
    this.icon,
    this.isDestructive = false,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  /// Destructive items render in [ColorScheme.error].
  final bool isDestructive;
}

// ---------------------------------------------------------------------------
// LumosEntityListItemCard
// ---------------------------------------------------------------------------

/// A list item card supporting single/multi-select, swipe actions,
/// long-press context menu, disabled state, loading skeleton,
/// and responsive padding.
///
/// Interaction model:
///   Single select   → [isSelected] + [onTap]
///   Multi select    → [isMultiSelectMode] shows checkbox; [onTap] toggles selection
///   Swipe actions   → [swipeActions] (mobile only — revealed on left swipe)
///   Long press menu → [contextMenuItems] shown as [showMenu] on long press
///   Disabled        → [isEnabled: false] suppresses all interactions + dims content
///
/// Example:
/// ```dart
/// LumosEntityListItemCard(
///   title: 'John Doe',
///   subtitle: 'john@example.com',
///   leading: Avatar(url: user.avatarUrl),
///   isSelected: _selectedIds.contains(user.id),
///   isMultiSelectMode: _isMultiSelect,
///   swipeActions: [
///     LumosSwipeAction(
///       icon: Icons.delete_outline,
///       tooltip: 'Delete',
///       onPressed: () => deleteUser(user.id),
///       backgroundColor: colorScheme.errorContainer,
///       iconColor: colorScheme.onErrorContainer,
///     ),
///   ],
///   contextMenuItems: [
///     LumosContextMenuItem(label: 'Edit', icon: Icons.edit_outlined, onPressed: () => edit()),
///     LumosContextMenuItem(label: 'Delete', icon: Icons.delete_outline, onPressed: () => delete(), isDestructive: true),
///   ],
///   onTap: () => selectUser(user.id),
///   deviceType: context.deviceType,
/// )
/// ```
class LumosEntityListItemCard extends StatefulWidget {
  const LumosEntityListItemCard({
    required this.title,
    super.key,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.isSelected = false,
    this.isMultiSelectMode = false,
    this.isEnabled = true,
    this.isLoading = false,
    this.swipeActions = const [],
    this.contextMenuItems = const [],
    this.deviceType = DeviceType.mobile,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool isMultiSelectMode;
  final bool isEnabled;
  final bool isLoading;
  final List<LumosSwipeAction> swipeActions;
  final List<LumosContextMenuItem> contextMenuItems;
  final DeviceType deviceType;

  @override
  State<LumosEntityListItemCard> createState() =>
      _LumosEntityListItemCardState();
}

class _LumosEntityListItemCardState extends State<LumosEntityListItemCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _swipeController;
  late final Animation<Offset> _swipeAnimation;

  @override
  void initState() {
    super.initState();
    _swipeController = AnimationController(
      vsync: this,
      duration: LumosEntityListItemCardConst.swipeAnimationDuration,
    );
    _swipeAnimation =
        Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(-LumosEntityListItemCardConst.swipeExtentRatio, 0),
        ).animate(
          CurvedAnimation(parent: _swipeController, curve: Curves.easeInOut),
        );
  }

  @override
  void dispose() {
    _swipeController.dispose();
    super.dispose();
  }

  bool get _hasSwipeActions =>
      widget.swipeActions.isNotEmpty &&
      widget.isEnabled &&
      widget.deviceType == DeviceType.mobile;

  bool get _hasContextMenu =>
      widget.contextMenuItems.isNotEmpty && widget.isEnabled;

  void _handleSwipeUpdate(DragUpdateDetails details) {
    if (details.primaryDelta == null || details.primaryDelta! > 0) return;
    _swipeController.value -=
        details.primaryDelta! /
        (MediaQuery.sizeOf(context).width *
            LumosEntityListItemCardConst.swipeExtentRatio);
  }

  void _handleSwipeEnd(DragEndDetails details) {
    _swipeController.value > 0.5
        ? _swipeController.forward()
        : _swipeController.reverse();
  }

  void _closeSwipe() => _swipeController.reverse();

  void _showContextMenu() {
    if (!_hasContextMenu) return;
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset offset = box.localToGlobal(Offset.zero);
    showMenu<void>(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy,
        offset.dx + box.size.width,
        offset.dy + box.size.height,
      ),
      items: widget.contextMenuItems
          .map(_buildContextMenuItem)
          .toList(growable: false),
    );
  }

  PopupMenuItem<void> _buildContextMenuItem(LumosContextMenuItem item) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color labelColor = item.isDestructive
        ? colorScheme.error
        : colorScheme.onSurface;

    return PopupMenuItem<void>(
      onTap: item.onPressed,
      height: WidgetSizes.minTouchTarget,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (item.icon != null) ...[
            Icon(item.icon, size: IconSizes.iconSmall, color: labelColor),
            const SizedBox(width: Insets.spacing8),
          ],
          Text(
            item.label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: labelColor),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return LumosCard(
        isLoading: true,
        variant: LumosCardVariant.outlined,
        padding: EdgeInsets.zero,
        deviceType: widget.deviceType,
        child: const SizedBox.shrink(),
      );
    }

    final Widget card = _buildCard(context);

    if (!_hasSwipeActions) return card;

    return Stack(
      children: [
        Positioned.fill(
          child: Align(
            alignment: Alignment.centerRight,
            child: _SwipeActionPanel(
              actions: widget.swipeActions,
              onClose: _closeSwipe,
            ),
          ),
        ),
        GestureDetector(
          onHorizontalDragUpdate: _handleSwipeUpdate,
          onHorizontalDragEnd: _handleSwipeEnd,
          child: SlideTransition(position: _swipeAnimation, child: card),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Card
  // ---------------------------------------------------------------------------

  Widget _buildCard(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Opacity(
      // Dim entire card when disabled — communicates non-interactivity.
      opacity: widget.isEnabled ? 1.0 : WidgetOpacities.disabledContent,
      child: LumosCard(
        onTap: widget.isEnabled ? widget.onTap : null,
        onLongPress: _hasContextMenu ? _showContextMenu : null,
        isSelected: widget.isSelected,
        variant: LumosCardVariant.outlined,
        padding: EdgeInsets.zero,
        deviceType: widget.deviceType,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: LumosEntityListItemCardConst.minHeight,
          ),
          child: _buildContent(colorScheme),
        ),
      ),
    );
  }

  Widget _buildContent(ColorScheme colorScheme) {
    final EdgeInsets padding = switch (widget.deviceType) {
      DeviceType.mobile => LumosEntityListItemCardConst.contentPaddingMobile,
      DeviceType.tablet => LumosEntityListItemCardConst.contentPaddingTablet,
      DeviceType.desktop => LumosEntityListItemCardConst.contentPaddingTablet,
    };

    return Padding(
      padding: padding,
      child: Row(
        children: [
          // Checkbox — shown in multi-select mode, animated in/out.
          AnimatedSize(
            duration: AppDurations.fast,
            curve: Curves.easeInOut,
            child: widget.isMultiSelectMode
                ? _buildCheckbox(colorScheme)
                : const SizedBox.shrink(),
          ),
          // Leading widget (avatar, icon, etc.).
          if (widget.leading != null) ...[
            widget.leading!,
            const SizedBox(width: LumosEntityListItemCardConst.leadingGap),
          ],
          // Text content — expands to fill available space.
          Expanded(child: _buildTextContent()),
          // Trailing widget (badge, icon button, etc.).
          if (widget.trailing != null) ...[
            const SizedBox(width: LumosEntityListItemCardConst.trailingGap),
            widget.trailing!,
          ],
        ],
      ),
    );
  }

  Widget _buildCheckbox(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(
        right: LumosEntityListItemCardConst.leadingGap,
      ),
      child: SizedBox(
        width: LumosEntityListItemCardConst.checkboxSize,
        height: LumosEntityListItemCardConst.checkboxSize,
        child: Checkbox(
          value: widget.isSelected,
          onChanged: widget.isEnabled ? (_) => widget.onTap?.call() : null,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        ),
      ),
    );
  }

  Widget _buildTextContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LumosText(
          widget.title,
          style: LumosTextStyle.titleMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (widget.subtitle case final String subtitle) ...[
          const SizedBox(height: LumosEntityListItemCardConst.subtitleGap),
          LumosText(
            subtitle,
            style: LumosTextStyle.bodySmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Swipe action panel
// ---------------------------------------------------------------------------

class _SwipeActionPanel extends StatelessWidget {
  const _SwipeActionPanel({required this.actions, required this.onClose});

  final List<LumosSwipeAction> actions;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: actions
          .map((action) {
            final Color bg =
                action.backgroundColor ?? colorScheme.secondaryContainer;
            final Color fg =
                action.iconColor ?? colorScheme.onSecondaryContainer;

            return Tooltip(
              message: action.tooltip,
              child: InkWell(
                onTap: () {
                  onClose();
                  action.onPressed();
                },
                child: Container(
                  width: LumosEntityListItemCardConst.swipeActionWidth,
                  color: bg,
                  alignment: Alignment.center,
                  child: Icon(
                    action.icon,
                    color: fg,
                    size: IconSizes.iconMedium,
                  ),
                ),
              ),
            );
          })
          .toList(growable: false),
    );
  }
}
