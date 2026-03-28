import 'package:flutter/material.dart';
import 'package:lumos/core/enums/dialog_type.dart';
import 'package:lumos/presentation/shared/composites/dialogs/lumos_alert_dialog.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_danger_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_outline_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_primary_button.dart';

class LumosConfirmDialog extends StatelessWidget {
  const LumosConfirmDialog({
    super.key,
    required this.title,
    required this.onConfirm,
    this.content,
    this.confirmLabel = 'Confirm',
    this.cancelLabel = 'Cancel',
    this.onCancel,
    this.type = DialogType.confirm,
    this.isDestructive = false,
  });

  final String title;
  final Widget? content;
  final VoidCallback onConfirm;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback? onCancel;
  final DialogType type;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    return LumosAlertDialog(
      title: title,
      content: content,
      type: type,
      actions: [
        LumosOutlineButton(text: cancelLabel, onPressed: onCancel),
        if (isDestructive)
          LumosDangerButton(text: confirmLabel, onPressed: onConfirm)
        else
          LumosPrimaryButton(text: confirmLabel, onPressed: onConfirm),
      ],
    );
  }
}
