import 'package:flutter/material.dart';
import 'package:lumos/core/enums/dialog_type.dart';
import 'package:lumos/core/theme/tokens/tokens.dart';
import 'package:lumos/presentation/shared/composites/dialogs/lumos_alert_dialog.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_danger_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_outline_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_primary_button.dart';
import 'package:lumos/presentation/shared/primitives/text/lumos_text.dart';

class LumosDialog extends StatelessWidget {
  const LumosDialog({
    super.key,
    required this.title,
    this.content,
    this.message,
    this.actions,
    this.icon,
    this.type = DialogType.info,
    this.cancelText,
    this.confirmText,
    this.onCancel,
    this.onConfirm,
    this.isDestructive = false,
  });

  final String title;
  final Widget? content;
  final String? message;
  final List<Widget>? actions;
  final Widget? icon;
  final DialogType type;
  final String? cancelText;
  final String? confirmText;
  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    return LumosAlertDialog(
      title: title,
      content: _resolveContent(),
      actions: actions ?? _resolveActions(),
      icon: icon,
      type: type,
    );
  }

  Widget? _resolveContent() {
    if (content == null) {
      if (message == null) {
        return null;
      }
      return LumosText(
        message!,
        style: LumosTextStyle.bodyMedium,
        tone: LumosTextTone.secondary,
        align: TextAlign.center,
        height: AppTypographyTokens.bodyHeight,
      );
    }
    return content;
  }

  List<Widget>? _resolveActions() {
    if (cancelText == null && confirmText == null) {
      return null;
    }
    return [
      if (cancelText != null)
        LumosOutlineButton(text: cancelText!, onPressed: onCancel),
      if (confirmText != null)
        isDestructive
            ? LumosDangerButton(text: confirmText!, onPressed: onConfirm)
            : LumosPrimaryButton(text: confirmText!, onPressed: onConfirm),
    ];
  }
}
