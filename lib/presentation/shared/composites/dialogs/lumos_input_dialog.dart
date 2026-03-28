import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lumos/core/enums/dialog_type.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
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
    this.initialValue,
    this.hintText,
    this.confirmLabel = 'Save',
    this.cancelLabel = 'Cancel',
    this.type = DialogType.info,
    this.keyboardType,
    this.maxLines = 1,
  });

  final String title;
  final Widget? content;
  final String? initialValue;
  final String? hintText;
  final String confirmLabel;
  final String cancelLabel;
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
    return LumosAlertDialog(
      title: widget.title,
      type: widget.type,
      content: Column(
        mainAxisSize: MainAxisSize.min,
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
          text: widget.cancelLabel,
          onPressed: () => context.pop(),
        ),
        LumosPrimaryButton(text: widget.confirmLabel, onPressed: _submit),
      ],
    );
  }

  void _submit() {
    context.pop();
    widget.onSubmitted(_controller.text);
  }
}
