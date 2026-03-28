import 'package:flutter/material.dart';
import 'package:lumos/core/enums/dialog_type.dart';
import 'package:lumos/presentation/shared/composites/dialogs/lumos_alert_dialog.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_outline_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_primary_button.dart';
import 'package:lumos/presentation/shared/primitives/inputs/lumos_text_field.dart';

class LumosPromptDialog extends StatefulWidget {
  const LumosPromptDialog({
    super.key,
    required this.title,
    this.onSubmitted,
    this.onConfirm,
    this.onCancel,
    this.controller,
    this.initialValue,
    this.hintText,
    this.hint,
    this.label,
    this.additionalContent,
    this.confirmLabel = 'Save',
    this.cancelLabel = 'Cancel',
    this.confirmText,
    this.cancelText,
    this.isCancelEnabled = true,
    this.isConfirmEnabled = true,
    this.type = DialogType.info,
    this.maxLines = 1,
  });

  final String title;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onConfirm;
  final VoidCallback? onCancel;
  final TextEditingController? controller;
  final String? initialValue;
  final String? hintText;
  final String? hint;
  final String? label;
  final Widget? additionalContent;
  final String confirmLabel;
  final String cancelLabel;
  final String? confirmText;
  final String? cancelText;
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
            hint: widget.hint ?? widget.hintText,
            maxLines: widget.maxLines,
          ),
          if (widget.additionalContent != null) ...[
            const SizedBox(height: 16),
            widget.additionalContent!,
          ],
        ],
      ),
      actions: [
        LumosOutlineButton(
          text: widget.cancelText ?? widget.cancelLabel,
          onPressed: widget.isCancelEnabled ? widget.onCancel : null,
        ),
        LumosPrimaryButton(
          text: widget.confirmText ?? widget.confirmLabel,
          onPressed: widget.isConfirmEnabled ? _submit : null,
        ),
      ],
    );
  }

  void _submit() {
    final callback = widget.onConfirm ?? widget.onSubmitted;
    if (callback == null) {
      return;
    }
    callback(_controller.text);
  }
}
