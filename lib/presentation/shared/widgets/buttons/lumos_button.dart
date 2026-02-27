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
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final ButtonStyle themeStyle = _resolveThemeStyle(theme: theme);
    final _ButtonStyleTokens tokens = _resolveButtonStyleTokens(
      colorScheme: colorScheme,
    );
    final ButtonStyle baseStyle = _buildBaseStyle(tokens: tokens);
    final ButtonStyle mergedStyle = themeStyle.merge(baseStyle);
    final ButtonStyle customStyle = _buildCustomColorStyle(
      colorScheme: colorScheme,
    );
    final ButtonStyle resolvedStyle = mergedStyle.merge(customStyle);
    return _withStateOverlay(style: resolvedStyle, colorScheme: colorScheme);
  }

  ButtonStyle _resolveThemeStyle({required ThemeData theme}) {
    if (type == LumosButtonType.primary) {
      return theme.filledButtonTheme.style ?? const ButtonStyle();
    }
    if (type == LumosButtonType.secondary) {
      return theme.filledButtonTheme.style ?? const ButtonStyle();
    }
    if (type == LumosButtonType.outline) {
      return theme.outlinedButtonTheme.style ?? const ButtonStyle();
    }
    return theme.textButtonTheme.style ?? const ButtonStyle();
  }

  _ButtonStyleTokens _resolveButtonStyleTokens({
    required ColorScheme colorScheme,
  }) {
    final double buttonHeight = _resolveButtonHeight();
    final EdgeInsetsGeometry buttonPadding = _resolveButtonPadding();
    final OutlinedBorder shape = const RoundedRectangleBorder(
      borderRadius: BorderRadii.medium,
    );
    return _ButtonStyleTokens(
      buttonHeight: buttonHeight,
      buttonPadding: buttonPadding,
      shape: shape,
      colorScheme: colorScheme,
    );
  }

  ButtonStyle _buildBaseStyle({required _ButtonStyleTokens tokens}) {
    final ButtonStyle baseStyle = ButtonStyle(
      minimumSize: WidgetStatePropertyAll<Size>(
        Size(WidgetSizes.minTouchTarget, tokens.buttonHeight),
      ),
      padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(tokens.buttonPadding),
      shape: WidgetStatePropertyAll<OutlinedBorder>(tokens.shape),
    );
    if (type != LumosButtonType.outline) {
      return baseStyle;
    }
    final BorderSide side = BorderSide(
      color: tokens.colorScheme.primary,
      width: WidgetSizes.borderWidthRegular,
    );
    return baseStyle.copyWith(side: WidgetStatePropertyAll<BorderSide>(side));
  }

  ButtonStyle _buildCustomColorStyle({required ColorScheme colorScheme}) {
    if (customColor == null) {
      return const ButtonStyle();
    }
    if (type == LumosButtonType.outline) {
      return ButtonStyle(
        foregroundColor: WidgetStatePropertyAll<Color>(customColor!),
        side: WidgetStatePropertyAll<BorderSide>(
          BorderSide(
            color: customColor!,
            width: WidgetSizes.borderWidthRegular,
          ),
        ),
      );
    }
    if (type == LumosButtonType.text) {
      return ButtonStyle(
        foregroundColor: WidgetStatePropertyAll<Color>(customColor!),
      );
    }
    final Color foreground = colorScheme.onPrimary;
    return ButtonStyle(
      backgroundColor: WidgetStatePropertyAll<Color>(customColor!),
      foregroundColor: WidgetStatePropertyAll<Color>(foreground),
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

  ButtonStyle _withStateOverlay({
    required ButtonStyle style,
    required ColorScheme colorScheme,
  }) {
    final Color overlayBaseColor = _resolveOverlayBaseColor(
      colorScheme: colorScheme,
    );
    return style.copyWith(
      overlayColor: WidgetStateProperty.resolveWith<Color?>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.pressed)) {
          return overlayBaseColor.withValues(alpha: WidgetOpacities.statePress);
        }
        if (states.contains(WidgetState.focused)) {
          return overlayBaseColor.withValues(alpha: WidgetOpacities.stateFocus);
        }
        if (states.contains(WidgetState.hovered)) {
          return overlayBaseColor.withValues(alpha: WidgetOpacities.stateHover);
        }
        return null;
      }),
      shadowColor: WidgetStatePropertyAll<Color>(
        colorScheme.surface.withValues(alpha: WidgetOpacities.transparent),
      ),
      surfaceTintColor: WidgetStatePropertyAll<Color>(
        colorScheme.surface.withValues(alpha: WidgetOpacities.transparent),
      ),
    );
  }

  Color _resolveOverlayBaseColor({required ColorScheme colorScheme}) {
    if (type == LumosButtonType.primary) {
      return colorScheme.primary;
    }
    if (type == LumosButtonType.secondary) {
      return colorScheme.primary;
    }
    return colorScheme.onSurface;
  }
}

class _ButtonStyleTokens {
  const _ButtonStyleTokens({
    required this.buttonHeight,
    required this.buttonPadding,
    required this.shape,
    required this.colorScheme,
  });

  final double buttonHeight;
  final EdgeInsetsGeometry buttonPadding;
  final OutlinedBorder shape;
  final ColorScheme colorScheme;
}
