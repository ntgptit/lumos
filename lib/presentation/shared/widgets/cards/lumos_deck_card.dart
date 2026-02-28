import 'package:flutter/material.dart';

import '../../../../core/themes/constants/dimensions.dart';
import '../buttons/lumos_icon_button.dart';
import '../feedback/lumos_progress_bar.dart';
import '../typography/lumos_text.dart';
import 'lumos_card.dart';

// ---------------------------------------------------------------------------
// Constants
// ---------------------------------------------------------------------------

abstract final class LumosDeckCardConst {
  LumosDeckCardConst._();

  // Swipe threshold: how far user must drag to reveal action (fraction of card width).
  static const double swipeExtentRatio = WidgetRatios.swipeRevealExtent;

  // Action button width in swipe panel.
  static const double swipeActionWidth = WidgetSizes.buttonMinWidth;

  // Spring animation for swipe return.
  static const Duration swipeAnimationDuration = AppDurations.medium;

  // Responsive max width for card content on tablet/desktop.
  static const double maxContentWidthTablet = WidgetSizes.overlayMaxWidthTablet;
  static const double maxContentWidthDesktop =
      WidgetSizes.overlayMaxWidthDesktop;
}

// ---------------------------------------------------------------------------
// LumosDeckCard
// ---------------------------------------------------------------------------

/// A card displaying a learning deck (flashcard set, course, quiz, reading list)
/// with progress tracking, optional swipe-to-action, selected state, and skeleton.
///
/// Layout:
///   - Header: title + optional inline actions (tablet/desktop only)
///   - Body: optional description
///   - Footer: stats label + progress bar
///
/// Interaction patterns:
///   - Mobile  : swipe left to reveal edit/delete actions (saves header space)
///   - Tablet+ : inline edit/delete icon buttons in header (more screen space)
///   - All     : tap to open, long press reserved for multi-select
///
/// Example:
/// ```dart
/// LumosDeckCard(
///   title: 'Japanese N3 Vocab',
///   statsLabel: '120 cards • 14 due today',
///   progress: 0.65,
///   onTap: () => openDeck(deck),
///   onEdit: () => editDeck(deck),
///   onDelete: () => deleteDeck(deck),
///   isSelected: _selectedIds.contains(deck.id),
///   deviceType: context.deviceType,
/// )
/// ```
class LumosDeckCard extends StatefulWidget {
  const LumosDeckCard({
    required this.title,
    required this.statsLabel,
    required this.progress,
    required this.onTap,
    super.key,
    this.description,
    this.onEdit,
    this.onDelete,
    this.isSelected = false,
    this.isLoading = false,
    this.deviceType = DeviceType.mobile,
  });

  final String title;
  final String? description;

  /// Pre-formatted stats string — caller owns the formatting logic.
  /// Example: '120 cards • 14 due today'
  final String statsLabel;

  /// Progress value from 0.0 to 1.0.
  final double progress;

  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isSelected;
  final bool isLoading;
  final DeviceType deviceType;

  @override
  State<LumosDeckCard> createState() => _LumosDeckCardState();
}

class _LumosDeckCardState extends State<LumosDeckCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _swipeController;
  late final Animation<Offset> _swipeAnimation;

  @override
  void initState() {
    super.initState();
    _swipeController = AnimationController(
      vsync: this,
      duration: LumosDeckCardConst.swipeAnimationDuration,
    );
    _swipeAnimation =
        Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(-LumosDeckCardConst.swipeExtentRatio, 0),
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
      (widget.onEdit != null || widget.onDelete != null) &&
      widget.deviceType == DeviceType.mobile;

  bool get _hasInlineActions =>
      (widget.onEdit != null || widget.onDelete != null) &&
      widget.deviceType != DeviceType.mobile;

  void _handleSwipeUpdate(DragUpdateDetails details) {
    // Only allow left swipe (negative dx).
    if (details.primaryDelta == null || details.primaryDelta! > 0) return;
    _swipeController.value -=
        details.primaryDelta! /
        (MediaQuery.sizeOf(context).width *
            LumosDeckCardConst.swipeExtentRatio);
  }

  void _handleSwipeEnd(DragEndDetails details) {
    if (_swipeController.value > 0.5) {
      _swipeController.forward();
    } else {
      _swipeController.reverse();
    }
  }

  void _closeSwipe() => _swipeController.reverse();

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return LumosCard(
        isLoading: true,
        deviceType: widget.deviceType,
        child: const SizedBox.shrink(),
      );
    }

    return _buildResponsiveWrapper(
      child: _hasSwipeActions ? _buildSwipeable(context) : _buildCard(context),
    );
  }

  // ---------------------------------------------------------------------------
  // Responsive width constraint
  // ---------------------------------------------------------------------------

  Widget _buildResponsiveWrapper({required Widget child}) {
    final double? maxWidth = switch (widget.deviceType) {
      DeviceType.mobile => null,
      DeviceType.tablet => LumosDeckCardConst.maxContentWidthTablet,
      DeviceType.desktop => LumosDeckCardConst.maxContentWidthDesktop,
    };

    if (maxWidth == null) return child;

    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Swipe-to-reveal (mobile only)
  // ---------------------------------------------------------------------------

  Widget _buildSwipeable(BuildContext context) {
    return Stack(
      children: [
        // Action panel revealed behind card on swipe left.
        Positioned.fill(
          child: Align(
            alignment: Alignment.centerRight,
            child: _SwipeActionPanel(
              onEdit: widget.onEdit,
              onDelete: widget.onDelete,
              onClose: _closeSwipe,
            ),
          ),
        ),
        // Card slides left via SlideTransition.
        GestureDetector(
          onHorizontalDragUpdate: _handleSwipeUpdate,
          onHorizontalDragEnd: _handleSwipeEnd,
          child: SlideTransition(
            position: _swipeAnimation,
            child: _buildCard(context),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Card content
  // ---------------------------------------------------------------------------

  Widget _buildCard(BuildContext context) {
    return LumosCard(
      onTap: widget.onTap,
      isSelected: widget.isSelected,
      deviceType: widget.deviceType,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildHeader(),
          if (widget.description case final String desc) ...[
            const SizedBox(height: Insets.spacing8),
            LumosText(
              desc,
              style: LumosTextStyle.bodySmall,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: Insets.gapBetweenItems),
          LumosText(
            widget.statsLabel,
            style: LumosTextStyle.labelMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: Insets.spacing8),
          LumosProgressBar(value: widget.progress),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: LumosText(
            widget.title,
            style: LumosTextStyle.titleMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // Inline actions: tablet/desktop only — enough space to avoid crowding.
        if (_hasInlineActions) _buildInlineActions(),
      ],
    );
  }

  Widget _buildInlineActions() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (widget.onEdit != null)
          LumosIconButton(
            icon: Icons.edit_outlined,
            onPressed: widget.onEdit,
            tooltip: 'Edit deck',
          ),
        if (widget.onDelete != null)
          LumosIconButton(
            icon: Icons.delete_outline,
            onPressed: widget.onDelete,
            tooltip: 'Delete deck',
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Swipe action panel — revealed behind card on left swipe (mobile)
// ---------------------------------------------------------------------------

class _SwipeActionPanel extends StatelessWidget {
  const _SwipeActionPanel({required this.onClose, this.onEdit, this.onDelete});

  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (onEdit != null)
          _SwipeActionButton(
            icon: Icons.edit_outlined,
            color: colorScheme.secondaryContainer,
            iconColor: colorScheme.onSecondaryContainer,
            tooltip: 'Edit deck',
            onPressed: () {
              onClose();
              onEdit!();
            },
          ),
        if (onDelete != null)
          _SwipeActionButton(
            icon: Icons.delete_outline,
            color: colorScheme.errorContainer,
            iconColor: colorScheme.onErrorContainer,
            tooltip: 'Delete deck',
            onPressed: () {
              onClose();
              onDelete!();
            },
          ),
      ],
    );
  }
}

class _SwipeActionButton extends StatelessWidget {
  const _SwipeActionButton({
    required this.icon,
    required this.color,
    required this.iconColor,
    required this.onPressed,
    required this.tooltip,
  });

  final IconData icon;
  final Color color;
  final Color iconColor;
  final VoidCallback onPressed;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          width: LumosDeckCardConst.swipeActionWidth,
          color: color,
          alignment: Alignment.center,
          child: Icon(icon, color: iconColor, size: IconSizes.iconMedium),
        ),
      ),
    );
  }
}
