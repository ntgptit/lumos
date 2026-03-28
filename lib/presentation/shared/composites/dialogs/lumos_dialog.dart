import 'package:flutter/material.dart';
import 'package:lumos/core/enums/dialog_type.dart';
import 'package:lumos/presentation/shared/composites/dialogs/lumos_alert_dialog.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_danger_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_outline_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_primary_button.dart';

class LumosDialog extends StatelessWidget {
  const LumosDialog({
    super.key,
    required this.title,
    this.content,
    this.actions,
    this.type = DialogType.info,
    this.cancelText,
    this.confirmText,
    this.onCancel,
    this.onConfirm,
    this.isDestructive = false,
  });

  final String title;
  final Object? content;
  final List<Widget>? actions;
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
      type: type,
    );
  }

  Widget? _resolveContent() {
    if (content == null) {
      return null;
    }
    if (content is Widget) {
      return content! as Widget;
    }
    return Text(content as String);
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
