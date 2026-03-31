import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/core/theme/tokens/tokens.dart';

enum AppButtonVariant { primary, secondary, outline, text, danger }

enum LumosButtonSize { medium, large }

class LumosButton extends StatelessWidget {
  const LumosButton.primary({
    required this.text,
    this.onPressed,
    this.expand = false,
    this.isLoading = false,
    this.leading,
    this.trailing,
    this.size = LumosButtonSize.large,
    super.key,
  }) : variant = AppButtonVariant.primary;

  const LumosButton.secondary({
    required this.text,
    this.onPressed,
    this.expand = false,
    this.isLoading = false,
    this.leading,
    this.trailing,
    this.size = LumosButtonSize.large,
    super.key,
  }) : variant = AppButtonVariant.secondary;

  const LumosButton.outline({
    required this.text,
    this.onPressed,
    this.expand = false,
    this.isLoading = false,
    this.leading,
    this.trailing,
    this.size = LumosButtonSize.large,
    super.key,
  }) : variant = AppButtonVariant.outline;

  const LumosButton.text({
    required this.text,
    this.onPressed,
    this.expand = false,
    this.isLoading = false,
    this.leading,
    this.trailing,
    this.size = LumosButtonSize.large,
    super.key,
  }) : variant = AppButtonVariant.text;

  const LumosButton.danger({
    required this.text,
    this.onPressed,
    this.expand = false,
    this.isLoading = false,
    this.leading,
    this.trailing,
    this.size = LumosButtonSize.large,
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
    this.size = LumosButtonSize.large,
  });

  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool expand;
  final bool isLoading;
  final Widget? leading;
  final Widget? trailing;
  final LumosButtonSize size;

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
        child: child,
      ),
      AppButtonVariant.secondary => FilledButton.tonal(
        onPressed: isLoading ? null : onPressed,
        child: child,
      ),
      AppButtonVariant.outline => OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        child: child,
      ),
      AppButtonVariant.text => TextButton(
        onPressed: isLoading ? null : onPressed,
        child: child,
      ),
      AppButtonVariant.danger => FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: _dangerStyle(context),
        child: child,
      ),
    };

    return SizedBox(
      width: expand ? double.infinity : null,
      height: _resolveHeight(context),
      child: button,
    );
  }

  double _resolveHeight(BuildContext context) {
    if (size == LumosButtonSize.large) {
      return context.component.buttonHeight;
    }
    return context.component.buttonHeight - context.spacing.xxs;
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
    final Widget indicator = SizedBox.square(
      dimension: context.iconSize.sm,
      child: CircularProgressIndicator(
        strokeWidth: AppBorderTokens.regular,
        valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
      ),
    );

    final List<Widget> contentChildren = <Widget>[
      if (leading != null) leading!,
      Flexible(
        child: Text(
          text,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          textAlign: TextAlign.center,
        ),
      ),
      if (trailing != null) trailing!,
    ];

    final Widget content = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: _withSpacing(contentChildren, context.spacing.xs),
    );

    return AnimatedSwitcher(
      duration: AppMotionTokens.fast,
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      child: isLoading
          ? KeyedSubtree(
              key: const ValueKey<String>('loading'),
              child: indicator,
            )
          : KeyedSubtree(
              key: const ValueKey<String>('content'),
              child: content,
            ),
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
