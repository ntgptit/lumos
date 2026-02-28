import 'package:flutter/material.dart';

import '../../../../core/themes/constants/dimensions.dart';
import '../buttons/lumos_button.dart';
import '../inputs/lumos_form_widgets.dart';
import '../lumos_models.dart';

abstract final class LumosDialogSizingConst {
  LumosDialogSizingConst._();

  static const double dialogWidthFactor = 0.84;
  static const double dialogMinWidth = 340;
  static const double dialogMaxWidth = 620;
  static const double dialogHorizontalInset = Insets.spacing16;
  static const double dialogMinScreenInset = Insets.spacing8;
  static const double dialogVerticalInset = Insets.spacing24;
  static const EdgeInsetsGeometry dialogActionsPadding = EdgeInsets.fromLTRB(
    Insets.spacing16,
    Insets.spacing0,
    Insets.spacing16,
    Insets.spacing16,
  );
  static const EdgeInsetsGeometry dialogActionButtonPadding = EdgeInsets.only(
    left: Insets.spacing8,
  );
}

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
    this.constraints,
    this.insetPadding,
  });

  final String title;
  final String? content;
  final String? cancelText;
  final String? confirmText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool isDestructive;
  final BoxConstraints? constraints;
  final EdgeInsets? insetPadding;

  @override
  Widget build(BuildContext context) {
    final BoxConstraints resolvedConstraints =
        constraints ?? _resolveDialogConstraints(context: context);
    final EdgeInsets resolvedInsetPadding =
        insetPadding ??
        _resolveDialogInsetPadding(
          context: context,
          constraints: resolvedConstraints,
        );
    return AlertDialog(
      constraints: resolvedConstraints,
      insetPadding: resolvedInsetPadding,
      scrollable: true,
      actionsPadding: LumosDialogSizingConst.dialogActionsPadding,
      buttonPadding: LumosDialogSizingConst.dialogActionButtonPadding,
      title: Text(title, overflow: TextOverflow.ellipsis),
      content: _buildContent(),
      actions: _buildActions(),
    );
  }

  Widget? _buildContent() {
    if (content == null) {
      return null;
    }
    return Text(content!);
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

class LumosPromptDialog extends StatelessWidget {
  const LumosPromptDialog({
    required this.title,
    required this.label,
    required this.cancelText,
    required this.confirmText,
    required this.onCancel,
    required this.onConfirm,
    super.key,
    this.initialValue = '',
    this.constraints,
    this.insetPadding,
  });

  final String title;
  final String label;
  final String cancelText;
  final String confirmText;
  final VoidCallback onCancel;
  final ValueChanged<String> onConfirm;
  final String initialValue;
  final BoxConstraints? constraints;
  final EdgeInsets? insetPadding;

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController(
      text: initialValue,
    );
    final BoxConstraints resolvedConstraints =
        constraints ?? _resolveDialogConstraints(context: context);
    final EdgeInsets resolvedInsetPadding =
        insetPadding ??
        _resolveDialogInsetPadding(
          context: context,
          constraints: resolvedConstraints,
        );
    return AlertDialog(
      constraints: resolvedConstraints,
      insetPadding: resolvedInsetPadding,
      scrollable: true,
      actionsPadding: LumosDialogSizingConst.dialogActionsPadding,
      buttonPadding: LumosDialogSizingConst.dialogActionButtonPadding,
      title: Text(title, overflow: TextOverflow.ellipsis),
      content: LumosTextField(controller: controller, label: label),
      actions: <Widget>[
        LumosButton(
          label: cancelText,
          onPressed: onCancel,
          type: LumosButtonType.text,
          size: LumosButtonSize.small,
        ),
        LumosButton(
          label: confirmText,
          onPressed: () {
            onConfirm(controller.text);
          },
          type: LumosButtonType.primary,
          size: LumosButtonSize.small,
        ),
      ],
    );
  }
}

BoxConstraints _resolveDialogConstraints({required BuildContext context}) {
  final double dialogWidth = _resolveDialogWidth(context: context);
  return BoxConstraints(minWidth: dialogWidth, maxWidth: dialogWidth);
}

EdgeInsets _resolveDialogInsetPadding({
  required BuildContext context,
  required BoxConstraints constraints,
}) {
  final double screenWidth = MediaQuery.sizeOf(context).width;
  final double dialogWidth = constraints.maxWidth;
  final double rawInset = (screenWidth - dialogWidth) / 2;
  final double horizontalInset = rawInset
      .clamp(LumosDialogSizingConst.dialogMinScreenInset, screenWidth)
      .toDouble();
  return EdgeInsets.symmetric(
    horizontal: horizontalInset,
    vertical: LumosDialogSizingConst.dialogVerticalInset,
  );
}

double _resolveDialogWidth({required BuildContext context}) {
  final double screenWidth = MediaQuery.sizeOf(context).width;
  final double maxAvailableWidth =
      screenWidth - (LumosDialogSizingConst.dialogHorizontalInset * 2);
  if (maxAvailableWidth <= LumosDialogSizingConst.dialogMinWidth) {
    return maxAvailableWidth;
  }

  final double scaledWidth =
      screenWidth * LumosDialogSizingConst.dialogWidthFactor;
  if (scaledWidth < LumosDialogSizingConst.dialogMinWidth) {
    return LumosDialogSizingConst.dialogMinWidth;
  }
  if (scaledWidth > LumosDialogSizingConst.dialogMaxWidth) {
    return LumosDialogSizingConst.dialogMaxWidth;
  }
  if (scaledWidth > maxAvailableWidth) {
    return maxAvailableWidth;
  }
  return scaledWidth;
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
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double resolvedHeight = initialHeight ?? (screenHeight * 0.9);
    final double maxHeight = resolvedHeight
        .clamp(WidgetSizes.minTouchTarget, screenHeight)
        .toDouble();
    return Container(
      constraints: BoxConstraints(
        minHeight: WidgetSizes.minTouchTarget,
        maxHeight: maxHeight,
      ),
      padding: Insets.screenPadding,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadii.topMedium,
      ),
      child: child,
    );
  }
}

class LumosActionSheet extends StatelessWidget {
  const LumosActionSheet({
    required this.actions,
    super.key,
    this.cancelText,
    this.onCancel,
  });

  final List<LumosActionItem> actions;
  final String? cancelText;
  final VoidCallback? onCancel;

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
              onPressed: onCancel,
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
