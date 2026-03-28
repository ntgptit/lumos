import 'package:flutter/material.dart';
import 'package:lumos/core/enums/dialog_type.dart';
import 'package:lumos/presentation/shared/composites/dialogs/lumos_alert_dialog.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_outline_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_primary_button.dart';
import 'package:lumos/presentation/shared/primitives/inputs/lumos_text_field.dart';
import 'package:lumos/presentation/shared/primitives/layout/lumos_spacing.dart';

class LumosPromptDialog extends StatefulWidget {
  const LumosPromptDialog({
    super.key,
    required this.title,
    this.onConfirm,
    this.onCancel,
    this.controller,
    this.initialValue,
    this.hintText,
    this.label,
    this.additionalContent,
    this.confirmText = 'Save',
    this.cancelText = 'Cancel',
    this.isCancelEnabled = true,
    this.isConfirmEnabled = true,
    this.type = DialogType.info,
    this.maxLines = 1,
  });

  final String title;
  final ValueChanged<String>? onConfirm;
  final VoidCallback? onCancel;
  final TextEditingController? controller;
  final String? initialValue;
  final String? hintText;
  final String? label;
  final Widget? additionalContent;
  final String confirmText;
  final String cancelText;
  final bool isCancelEnabled;
  final bool isConfirmEnabled;
  final DialogType type;
  final int maxLines;

  @override
  State<LumosPromptDialog> createState() => _LumosPromptDialogState();
}

class _LumosPromptDialogState extends State<LumosPromptDialog> {
  late final TextEditingController _controller;
  late final bool _ownsController;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller =
        widget.controller ??
        TextEditingController(text: widget.initialValue ?? '');
  }

  @override
  void dispose() {
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LumosAlertDialog(
      title: widget.title,
      type: widget.type,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LumosTextField(
            controller: _controller,
            label: widget.label,
            hintText: widget.hintText,
            maxLines: widget.maxLines,
          ),
          if (widget.additionalContent != null) ...[
            SizedBox(height: LumosSpacing.md),
            widget.additionalContent!,
          ],
        ],
      ),
      actions: [
        LumosOutlineButton(
          text: widget.cancelText,
          onPressed: widget.isCancelEnabled ? widget.onCancel : null,
        ),
        LumosPrimaryButton(
          text: widget.confirmText,
          onPressed: widget.isConfirmEnabled ? _submit : null,
        ),
      ],
    );
  }

  void _submit() {
    final callback = widget.onConfirm;
    if (callback == null) {
      return;
    }
    callback(_controller.text);
  }
}
