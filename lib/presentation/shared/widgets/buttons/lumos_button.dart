import 'package:flutter/material.dart';

import '../../../../core/themes/builders/app_button_style_builder.dart';
import '../../../../core/themes/foundation/app_foundation.dart';
import '../../../../core/themes/extensions/theme_extensions.dart';

abstract final class LumosButtonConst {
  LumosButtonConst._();

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
  });

  final String label;
  final VoidCallback? onPressed;
  final LumosButtonType type;
  final LumosButtonSize size;
  final bool isLoading;
  final IconData? icon;
  final bool expanded;

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
    final Color indicatorColor = _resolveLoadingIndicatorColor(context);
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
    final ThemeData theme = context.theme;
    final AppButtonSize componentSize = _resolveComponentButtonSize();
    final buttonTokens = context.appButton;
    if (type == LumosButtonType.primary) {
      return AppButtonStyleBuilder.filledStyle(
        colorScheme: theme.colorScheme,
        textTheme: theme.textTheme,
        size: componentSize,
        buttonTokens: buttonTokens,
      );
    }
    if (type == LumosButtonType.secondary) {
      return AppButtonStyleBuilder.tonalStyle(
        colorScheme: theme.colorScheme,
        textTheme: theme.textTheme,
        size: componentSize,
        buttonTokens: buttonTokens,
      );
    }
    if (type == LumosButtonType.outline) {
      return AppButtonStyleBuilder.outlinedStyle(
        colorScheme: theme.colorScheme,
        textTheme: theme.textTheme,
        size: componentSize,
        buttonTokens: buttonTokens,
      );
    }
    return AppButtonStyleBuilder.textStyle(
      colorScheme: theme.colorScheme,
      textTheme: theme.textTheme,
      size: componentSize,
      buttonTokens: buttonTokens,
    );
  }

  AppButtonSize _resolveComponentButtonSize() {
    if (size == LumosButtonSize.small) {
      return AppButtonSize.small;
    }
    if (size == LumosButtonSize.large) {
      return AppButtonSize.large;
    }
    return AppButtonSize.medium;
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

  Color _resolveLoadingIndicatorColor(BuildContext context) {
    final ColorScheme colorScheme = context.colorScheme;
    if (type == LumosButtonType.primary) {
      return colorScheme.onPrimary;
    }
    if (type == LumosButtonType.secondary) {
      return colorScheme.onSecondaryContainer;
    }
    return colorScheme.primary;
  }
}
