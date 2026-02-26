import 'package:flutter/material.dart';

import '../../../../core/constants/dimensions.dart';
import '../buttons/lumos_button.dart';
import '../lumos_models.dart';

class LumosDialog extends StatelessWidget {
  const LumosDialog({
    required this.title,
    super.key,
    this.content,
    this.cancelText,
    this.confirmText,
    this.onConfirm,
    this.onCancel,
    this.isDestructive = false,
  });

  final String title;
  final String? content;
  final String? cancelText;
  final String? confirmText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, overflow: TextOverflow.ellipsis),
      content: _buildContent(),
      actions: _buildActions(),
    );
  }

  Widget? _buildContent() {
    if (content == null) {
      return null;
    }
    return Text(content!, maxLines: 5, overflow: TextOverflow.ellipsis);
  }

  List<Widget> _buildActions() {
    return <Widget>[
      if (cancelText != null)
        LumosButton(
          label: cancelText!,
          onPressed: onCancel,
          type: LumosButtonType.text,
          size: LumosButtonSize.small,
        ),
      if (confirmText != null)
        LumosButton(
          label: confirmText!,
          onPressed: onConfirm,
          type: isDestructive
              ? LumosButtonType.outline
              : LumosButtonType.primary,
          size: LumosButtonSize.small,
        ),
    ];
  }
}

class LumosBottomSheet extends StatelessWidget {
  const LumosBottomSheet({
    required this.child,
    super.key,
    this.initialHeight,
    this.isScrollControlled = true,
  });

  final Widget child;
  final double? initialHeight;
  final bool isScrollControlled;

  @override
  Widget build(BuildContext context) {
    final double height = initialHeight ?? WidgetSizes.maxContentWidth * 0.4;
    return Container(
      constraints: BoxConstraints(
        minHeight: WidgetSizes.minTouchTarget,
        maxHeight: height,
      ),
      padding: Insets.screenPadding,
      decoration: const BoxDecoration(borderRadius: BorderRadii.topMedium),
      child: child,
    );
  }
}

class LumosActionSheet extends StatelessWidget {
  const LumosActionSheet({required this.actions, super.key, this.cancelText});

  final List<LumosActionItem> actions;
  final String? cancelText;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ...actions.map(_buildActionButton),
        if (cancelText != null)
          Padding(
            padding: const EdgeInsets.only(top: Insets.gapBetweenItems),
            child: LumosButton(
              label: cancelText!,
              onPressed: null,
              type: LumosButtonType.text,
            ),
          ),
      ],
    );
  }

  Widget _buildActionButton(LumosActionItem action) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Insets.spacing8),
      child: LumosButton(
        label: action.label,
        icon: action.icon,
        onPressed: action.onPressed,
        type: action.isDestructive
            ? LumosButtonType.outline
            : LumosButtonType.text,
        expanded: true,
      ),
    );
  }
}
