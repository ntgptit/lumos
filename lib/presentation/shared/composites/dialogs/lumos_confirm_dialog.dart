import 'package:flutter/material.dart';
import 'package:lumos/core/enums/dialog_type.dart';
import 'package:lumos/l10n/l10n.dart';
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
    this.icon,
    this.confirmLabel,
    this.cancelLabel,
    this.onCancel,
    this.type = DialogType.confirm,
    this.isDestructive = false,
  });

  final String title;
  final Widget? content;
  final Widget? icon;
  final VoidCallback onConfirm;
  final String? confirmLabel;
  final String? cancelLabel;
  final VoidCallback? onCancel;
  final DialogType type;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final String resolvedConfirmLabel =
        confirmLabel ?? context.l10n.commonConfirm;
    final String resolvedCancelLabel = cancelLabel ?? context.l10n.commonCancel;
    final Widget confirmAction = isDestructive
        ? LumosDangerButton(text: resolvedConfirmLabel, onPressed: onConfirm)
        : LumosPrimaryButton(text: resolvedConfirmLabel, onPressed: onConfirm);
    return LumosAlertDialog(
      title: title,
      content: content,
      icon: icon,
      type: type,
      actions: [
        LumosOutlineButton(text: resolvedCancelLabel, onPressed: onCancel),
        confirmAction,
      ],
    );
  }
}
