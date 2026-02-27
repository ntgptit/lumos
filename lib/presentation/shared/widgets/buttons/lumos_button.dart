import 'package:flutter/material.dart';

import '../../../../core/themes/constants/dimensions.dart';

class LumosButtonConst {
  const LumosButtonConst._();

  static const LumosButtonType defaultType = LumosButtonType.primary;
  static const LumosButtonSize defaultSize = LumosButtonSize.medium;
}

enum LumosButtonType { primary, secondary, outline, text }

enum LumosButtonSize { small, medium, large }

class LumosButton extends StatelessWidget {
  const LumosButton({
    required this.label,
    super.key,
    this.onPressed,
    this.type = LumosButtonConst.defaultType,
    this.size = LumosButtonConst.defaultSize,
    this.isLoading = false,
    this.icon,
    this.expanded = false,
    this.customColor,
  });

  final String label;
  final VoidCallback? onPressed;
  final LumosButtonType type;
  final LumosButtonSize size;
  final bool isLoading;
  final IconData? icon;
  final bool expanded;
  final Color? customColor;

  @override
  Widget build(BuildContext context) {
    final VoidCallback? resolvedOnPressed = _resolveOnPressed();
    final Widget child = _buildChild(context);
    final ButtonStyle style = _resolveButtonStyle(context);
    final Widget button = _buildButton(
      onPressed: resolvedOnPressed,
      style: style,
      child: child,
    );
    if (!expanded) {
      return button;
    }
    return SizedBox(width: double.infinity, child: button);
  }

  VoidCallback? _resolveOnPressed() {
    if (isLoading) {
      return null;
    }
    return onPressed;
  }

  Widget _buildChild(BuildContext context) {
    if (isLoading) {
      return _buildLoadingChild(context);
    }
    if (icon == null) {
      return Text(label, overflow: TextOverflow.ellipsis);
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, size: IconSizes.iconButton),
        const SizedBox(width: Insets.spacing8),
        Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
      ],
    );
  }

  Widget _buildLoadingChild(BuildContext context) {
    final Color indicatorColor = _resolveForegroundColor(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          width: IconSizes.iconSmall,
          height: IconSizes.iconSmall,
          child: CircularProgressIndicator(
            strokeWidth: WidgetSizes.borderWidthRegular,
            valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
          ),
        ),
        const SizedBox(width: Insets.spacing8),
        Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
      ],
    );
  }

  ButtonStyle _resolveButtonStyle(BuildContext context) {
    final double buttonHeight = _resolveButtonHeight();
    final EdgeInsetsGeometry buttonPadding = _resolveButtonPadding();
    final OutlinedBorder shape = const RoundedRectangleBorder(
      borderRadius: BorderRadii.medium,
    );
    if (type == LumosButtonType.primary) {
      return FilledButton.styleFrom(
        minimumSize: Size(WidgetSizes.minTouchTarget, buttonHeight),
        padding: buttonPadding,
        shape: shape,
        backgroundColor: customColor,
      );
    }
    if (type == LumosButtonType.secondary) {
      return FilledButton.styleFrom(
        minimumSize: Size(WidgetSizes.minTouchTarget, buttonHeight),
        padding: buttonPadding,
        shape: shape,
        backgroundColor: customColor,
      );
    }
    if (type == LumosButtonType.outline) {
      final Color borderColor =
          customColor ?? Theme.of(context).colorScheme.outline;
      return OutlinedButton.styleFrom(
        minimumSize: Size(WidgetSizes.minTouchTarget, buttonHeight),
        padding: buttonPadding,
        shape: shape,
        side: BorderSide(
          color: borderColor,
          width: WidgetSizes.borderWidthRegular,
        ),
        foregroundColor: customColor,
      );
    }
    return TextButton.styleFrom(
      minimumSize: Size(WidgetSizes.minTouchTarget, buttonHeight),
      padding: buttonPadding,
      shape: shape,
      foregroundColor: customColor,
    );
  }

  double _resolveButtonHeight() {
    if (size == LumosButtonSize.small) {
      return WidgetSizes.buttonHeightSmall;
    }
    if (size == LumosButtonSize.large) {
      return WidgetSizes.buttonHeightLarge;
    }
    return WidgetSizes.buttonHeightMedium;
  }

  EdgeInsetsGeometry _resolveButtonPadding() {
    if (size == LumosButtonSize.small) {
      return const EdgeInsets.symmetric(
        horizontal: Insets.spacing12,
        vertical: Insets.spacing4,
      );
    }
    if (size == LumosButtonSize.large) {
      return const EdgeInsets.symmetric(
        horizontal: Insets.spacing24,
        vertical: Insets.spacing12,
      );
    }
    return const EdgeInsets.symmetric(
      horizontal: Insets.spacing16,
      vertical: Insets.spacing8,
    );
  }

  Widget _buildButton({
    required VoidCallback? onPressed,
    required ButtonStyle style,
    required Widget child,
  }) {
    if (type == LumosButtonType.primary) {
      return FilledButton(onPressed: onPressed, style: style, child: child);
    }
    if (type == LumosButtonType.secondary) {
      return FilledButton.tonal(
        onPressed: onPressed,
        style: style,
        child: child,
      );
    }
    if (type == LumosButtonType.outline) {
      return OutlinedButton(onPressed: onPressed, style: style, child: child);
    }
    return TextButton(onPressed: onPressed, style: style, child: child);
  }

  Color _resolveForegroundColor(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    if (type == LumosButtonType.primary) {
      return colorScheme.onPrimary;
    }
    if (type == LumosButtonType.secondary) {
      return colorScheme.onSecondaryContainer;
    }
    return colorScheme.primary;
  }
}
