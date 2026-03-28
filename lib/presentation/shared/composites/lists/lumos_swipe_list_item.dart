import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/core/theme/tokens/tokens.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_icon.dart';

class LumosSwipeListItem extends StatelessWidget {
  const LumosSwipeListItem({
    super.key,
    required this.child,
    this.onDismissed,
    this.confirmDismiss,
    this.background,
    this.secondaryBackground,
    this.direction = DismissDirection.horizontal,
    this.dismissThresholds,
  });

  final Widget child;
  final DismissDirectionCallback? onDismissed;
  final ConfirmDismissCallback? confirmDismiss;
  final Widget? background;
  final Widget? secondaryBackground;
  final DismissDirection direction;
  final Map<DismissDirection, double>? dismissThresholds;

  @override
  Widget build(BuildContext context) {
    if (onDismissed == null) {
      return child;
    }

    return Dismissible(
      key: key ?? ValueKey<Object>(Object.hash(runtimeType, child.hashCode)),
      direction: direction,
      dismissThresholds:
          dismissThresholds ?? const <DismissDirection, double>{},
      confirmDismiss: confirmDismiss,
      onDismissed: onDismissed!,
      background:
          background ??
          _buildBackground(context, alignment: Alignment.centerLeft),
      secondaryBackground:
          secondaryBackground ??
          _buildBackground(context, alignment: Alignment.centerRight),
      child: child,
    );
  }

  Widget _buildBackground(
    BuildContext context, {
    required Alignment alignment,
  }) {
    return Container(
      alignment: alignment,
      color: context.colorScheme.error.withValues(
        alpha: AppOpacityTokens.subtle,
      ),
      padding: EdgeInsets.symmetric(horizontal: context.spacing.md),
      child: LumosIcon(Icons.delete_rounded, color: context.colorScheme.error),
    );
  }
}
