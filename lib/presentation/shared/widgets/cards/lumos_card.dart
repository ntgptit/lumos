import 'package:flutter/material.dart';

import '../../../../core/themes/constants/dimensions.dart';

class LumosCardConst {
  const LumosCardConst._();

  static const EdgeInsetsGeometry defaultPadding = EdgeInsets.all(
    Insets.paddingScreen,
  );
}

class LumosCard extends StatelessWidget {
  const LumosCard({
    required this.child,
    super.key,
    this.onTap,
    this.padding = LumosCardConst.defaultPadding,
    this.elevation,
    this.color,
    this.borderRadius,
    this.isSelected = false,
    this.margin,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final double? elevation;
  final Color? color;
  final BorderRadius? borderRadius;
  final bool isSelected;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final BorderRadius resolvedBorderRadius =
        borderRadius ?? BorderRadii.medium;
    final BorderSide borderSide = _resolveBorderSide(context);
    final Widget content = Padding(padding: padding, child: child);
    final Widget cardChild = _buildCardChild(
      content: content,
      borderRadius: resolvedBorderRadius,
    );
    return Card(
      elevation: elevation,
      color: color,
      margin: margin,
      shape: RoundedRectangleBorder(
        borderRadius: resolvedBorderRadius,
        side: borderSide,
      ),
      child: cardChild,
    );
  }

  BorderSide _resolveBorderSide(BuildContext context) {
    if (!isSelected) {
      return BorderSide.none;
    }
    return BorderSide(
      color: Theme.of(context).colorScheme.primary,
      width: WidgetSizes.borderWidthRegular,
    );
  }

  Widget _buildCardChild({
    required Widget content,
    required BorderRadius borderRadius,
  }) {
    if (onTap == null) {
      return content;
    }
    return InkWell(borderRadius: borderRadius, onTap: onTap, child: content);
  }
}
