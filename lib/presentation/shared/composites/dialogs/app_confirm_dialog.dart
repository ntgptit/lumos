import 'package:flutter/material.dart';
import 'package:lumos/core/enums/dialog_type.dart';
import 'package:lumos/presentation/shared/composites/dialogs/app_alert_dialog.dart';
import 'package:lumos/presentation/shared/primitives/buttons/app_danger_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/app_outline_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/app_primary_button.dart';

class AppConfirmDialog extends StatelessWidget {
  const AppConfirmDialog({
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
    return AppAlertDialog(
      title: title,
      content: content,
      type: type,
      actions: [
        AppOutlineButton(text: cancelLabel, onPressed: onCancel),
        if (isDestructive)
          AppDangerButton(text: confirmLabel, onPressed: onConfirm)
        else
          AppPrimaryButton(text: confirmLabel, onPressed: onConfirm),
      ],
    );
  }
}
