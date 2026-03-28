import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/core/theme/tokens/tokens.dart';

enum AppButtonVariant { primary, secondary, outline, text, danger }

class LumosButton extends StatelessWidget {
  const LumosButton.primary({
    required this.text,
    this.onPressed,
    this.expand = false,
    this.isLoading = false,
    this.leading,
    this.trailing,
    this.style,
    super.key,
  }) : variant = AppButtonVariant.primary;

  const LumosButton.secondary({
    required this.text,
    this.onPressed,
    this.expand = false,
    this.isLoading = false,
    this.leading,
    this.trailing,
    this.style,
    super.key,
  }) : variant = AppButtonVariant.secondary;

  const LumosButton.outline({
    required this.text,
    this.onPressed,
    this.expand = false,
    this.isLoading = false,
    this.leading,
    this.trailing,
    this.style,
    super.key,
  }) : variant = AppButtonVariant.outline;

  const LumosButton.text({
    required this.text,
    this.onPressed,
    this.expand = false,
    this.isLoading = false,
    this.leading,
    this.trailing,
    this.style,
    super.key,
  }) : variant = AppButtonVariant.text;

  const LumosButton.danger({
    required this.text,
    this.onPressed,
    this.expand = false,
    this.isLoading = false,
    this.leading,
    this.trailing,
    this.style,
    super.key,
  }) : variant = AppButtonVariant.danger;

  const LumosButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.expand = false,
    this.isLoading = false,
    this.leading,
    this.trailing,
    this.style,
  });

  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool expand;
  final bool isLoading;
  final Widget? leading;
  final Widget? trailing;
  final ButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    final indicatorColor = switch (variant) {
      AppButtonVariant.primary => context.colorScheme.onPrimary,
      AppButtonVariant.secondary => context.colorScheme.onSecondaryContainer,
      AppButtonVariant.outline => context.colorScheme.primary,
      AppButtonVariant.text => context.colorScheme.primary,
      AppButtonVariant.danger => context.colorScheme.onError,
    };
    final child = _AppButtonContent(
      text: text,
      isLoading: isLoading,
      leading: leading,
      trailing: trailing,
      indicatorColor: indicatorColor,
    );
    final button = switch (variant) {
      AppButtonVariant.primary => FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: style,
        child: child,
      ),
      AppButtonVariant.secondary => FilledButton.tonal(
        onPressed: isLoading ? null : onPressed,
        style: style,
        child: child,
      ),
      AppButtonVariant.outline => OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: style,
        child: child,
      ),
      AppButtonVariant.text => TextButton(
        onPressed: isLoading ? null : onPressed,
        style: style,
        child: child,
      ),
      AppButtonVariant.danger => FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: _dangerStyle(context).merge(style),
        child: child,
      ),
    };

    return SizedBox(
      width: expand ? double.infinity : null,
      height: context.component.buttonHeight,
      child: button,
    );
  }

  ButtonStyle _dangerStyle(BuildContext context) {
    return FilledButton.styleFrom(
      backgroundColor: context.colorScheme.error,
      foregroundColor: context.colorScheme.onError,
      disabledBackgroundColor: context.colorScheme.onSurface.withValues(
        alpha: AppOpacityTokens.disabledContainer,
      ),
      disabledForegroundColor: context.colorScheme.onSurface.withValues(
        alpha: AppOpacityTokens.disabledForeground,
      ),
    );
  }
}

class _AppButtonContent extends StatelessWidget {
  const _AppButtonContent({
    required this.text,
    required this.isLoading,
    required this.indicatorColor,
    this.leading,
    this.trailing,
  });

  final String text;
  final bool isLoading;
  final Color indicatorColor;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final indicator = SizedBox.square(
      dimension: context.iconSize.sm,
      child: CircularProgressIndicator(
        strokeWidth: AppBorderTokens.regular,
        valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
      ),
    );

    final children = <Widget>[
      if (isLoading) indicator,
      if (!isLoading && leading != null) leading!,
      Text(
        text,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        textAlign: TextAlign.center,
      ),
      if (!isLoading && trailing != null) trailing!,
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: _withSpacing(children, context.spacing.xs),
    );
  }

  List<Widget> _withSpacing(List<Widget> children, double spacing) {
    final result = <Widget>[];
    for (var index = 0; index < children.length; index++) {
      if (index > 0) {
        result.add(SizedBox(width: spacing));
      }
      result.add(children[index]);
    }
    return result;
  }
}
