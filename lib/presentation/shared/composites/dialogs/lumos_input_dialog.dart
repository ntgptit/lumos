import 'package:flutter/material.dart';
import 'package:lumos/core/enums/dialog_type.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/l10n/l10n.dart';
import 'package:lumos/presentation/shared/composites/dialogs/lumos_alert_dialog.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_outline_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_primary_button.dart';
import 'package:lumos/presentation/shared/primitives/inputs/lumos_text_field.dart';

class LumosInputDialog extends StatefulWidget {
  const LumosInputDialog({
    super.key,
    required this.title,
    required this.onSubmitted,
    this.content,
    this.icon,
    this.initialValue,
    this.hintText,
    this.confirmLabel,
    this.cancelLabel,
    this.onCancel,
    this.type = DialogType.info,
    this.keyboardType,
    this.maxLines = 1,
  });

  final String title;
  final Widget? content;
  final Widget? icon;
  final String? initialValue;
  final String? hintText;
  final String? confirmLabel;
  final String? cancelLabel;
  final VoidCallback? onCancel;
  final DialogType type;
  final TextInputType? keyboardType;
  final int? maxLines;
  final ValueChanged<String> onSubmitted;

  @override
  State<LumosInputDialog> createState() => _AppInputDialogState();
}

class _AppInputDialogState extends State<LumosInputDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String resolvedConfirmLabel =
        widget.confirmLabel ?? context.l10n.commonSave;
    final String resolvedCancelLabel =
        widget.cancelLabel ?? context.l10n.commonCancel;
    return LumosAlertDialog(
      title: widget.title,
      type: widget.type,
      icon: widget.icon,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.content != null) ...[
            widget.content!,
            SizedBox(height: context.spacing.md),
          ],
          LumosTextField(
            controller: _controller,
            hintText: widget.hintText,
            keyboardType: widget.keyboardType,
            maxLines: widget.maxLines,
            onSubmitted: (_) => _submit(),
            onEditingComplete: _submit,
          ),
        ],
      ),
      actions: [
        LumosOutlineButton(
          text: resolvedCancelLabel,
          onPressed: widget.onCancel,
        ),
        LumosPrimaryButton(text: resolvedConfirmLabel, onPressed: _submit),
      ],
    );
  }

  void _submit() {
    widget.onSubmitted(_controller.text);
  }
}
