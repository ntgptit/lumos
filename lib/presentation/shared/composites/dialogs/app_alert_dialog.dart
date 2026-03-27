import 'package:flutter/material.dart';
import 'package:lumos/core/enums/dialog_type.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';

class AppAlertDialog extends StatelessWidget {
  const AppAlertDialog({
    super.key,
    required this.title,
    this.content,
    this.type = DialogType.info,
    this.icon,
    this.actions,
    this.constraints,
  });

  final String title;
  final Widget? content;
  final DialogType type;
  final Widget? icon;
  final List<Widget>? actions;
  final BoxConstraints? constraints;

  @override
  Widget build(BuildContext context) {
    final tone = _tone(context);
    return AlertDialog(
      icon: icon ?? Icon(tone.icon, color: tone.foreground),
      iconPadding: EdgeInsets.only(top: context.spacing.xs),
      title: Text(title),
      content: content,
      actions: actions,
      insetPadding: EdgeInsets.all(context.spacing.lg),
      constraints:
          constraints ??
          BoxConstraints(maxWidth: context.layout.dialogMaxWidth),
      backgroundColor: tone.background,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.radius.lg),
      ),
    );
  }

  _DialogTone _tone(BuildContext context) {
    return switch (type) {
      DialogType.info => _DialogTone(
        background: context.colorScheme.surface,
        foreground: context.colorScheme.primary,
        icon: Icons.info_rounded,
      ),
      DialogType.warning => _DialogTone(
        background: context.colorScheme.surface,
        foreground: context.appColors.warning,
        icon: Icons.warning_rounded,
      ),
      DialogType.error => _DialogTone(
        background: context.colorScheme.surface,
        foreground: context.colorScheme.error,
        icon: Icons.error_rounded,
      ),
      DialogType.confirm => _DialogTone(
        background: context.colorScheme.surface,
        foreground: context.colorScheme.primary,
        icon: Icons.help_rounded,
      ),
    };
  }
}

class _DialogTone {
  const _DialogTone({
    required this.background,
    required this.foreground,
    required this.icon,
  });

  final Color background;
  final Color foreground;
  final IconData icon;
}
