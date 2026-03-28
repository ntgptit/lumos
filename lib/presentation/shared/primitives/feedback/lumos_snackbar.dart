import 'package:flutter/material.dart';
import 'package:lumos/core/enums/snackbar_type.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/core/theme/tokens/tokens.dart';

enum LumosSnackbarType { success, error, info, warning }

class LumosSnackbar extends StatelessWidget {
  const LumosSnackbar({
    super.key,
    required this.message,
    this.title,
    this.type = SnackbarType.info,
    this.actionLabel,
    this.onActionPressed,
    this.leading,
  });

  final String message;
  final String? title;
  final Object type;
  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final tone = _tone(context);
    final icon =
        leading ??
        Icon(_iconFor(type), color: tone.foreground, size: context.iconSize.lg);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: tone.background,
        borderRadius: BorderRadius.circular(context.radius.lg),
        border: Border.all(color: tone.border),
      ),
      child: Padding(
        padding: EdgeInsets.all(context.spacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            icon,
            SizedBox(width: context.spacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title != null) ...[
                    Text(
                      title!,
                      style: context.textTheme.titleSmall?.copyWith(
                        color: tone.foreground,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: context.spacing.xxs),
                  ],
                  Text(
                    message,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: tone.foreground.withValues(
                        alpha: AppOpacityTokens.strong,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (actionLabel != null && onActionPressed != null) ...[
              SizedBox(width: context.spacing.sm),
              TextButton(
                onPressed: onActionPressed,
                style: TextButton.styleFrom(foregroundColor: tone.foreground),
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }

  _Tone _tone(BuildContext context) {
    return switch (_resolveType()) {
      SnackbarType.success => _Tone(
        background: context.appColors.successContainer,
        foreground: context.appColors.onSuccessContainer,
        border: context.appColors.success.withValues(
          alpha: AppOpacityTokens.outline,
        ),
      ),
      SnackbarType.error => _Tone(
        background: context.colorScheme.errorContainer,
        foreground: context.colorScheme.onErrorContainer,
        border: context.colorScheme.error.withValues(
          alpha: AppOpacityTokens.outline,
        ),
      ),
      SnackbarType.info => _Tone(
        background: context.appColors.infoContainer,
        foreground: context.appColors.onInfoContainer,
        border: context.appColors.info.withValues(
          alpha: AppOpacityTokens.outline,
        ),
      ),
      SnackbarType.warning => _Tone(
        background: context.appColors.warningContainer,
        foreground: context.appColors.onWarningContainer,
        border: context.appColors.warning.withValues(
          alpha: AppOpacityTokens.outline,
        ),
      ),
    };
  }

  IconData _iconFor(Object type) {
    final resolvedType = _resolveType();
    return switch (resolvedType) {
      SnackbarType.success => Icons.check_circle_rounded,
      SnackbarType.error => Icons.error_rounded,
      SnackbarType.info => Icons.info_rounded,
      SnackbarType.warning => Icons.warning_rounded,
    };
  }

  SnackbarType _resolveType() {
    if (type is SnackbarType) {
      return type as SnackbarType;
    }
    return switch (type) {
      LumosSnackbarType.success => SnackbarType.success,
      LumosSnackbarType.error => SnackbarType.error,
      LumosSnackbarType.warning => SnackbarType.warning,
      _ => SnackbarType.info,
    };
  }
}

class _Tone {
  const _Tone({
    required this.background,
    required this.foreground,
    required this.border,
  });

  final Color background;
  final Color foreground;
  final Color border;
}
