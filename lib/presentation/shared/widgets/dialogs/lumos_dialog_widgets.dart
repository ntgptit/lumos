import 'package:flutter/material.dart';

import '../../../../core/themes/foundation/app_foundation.dart';
import '../../../../core/themes/extensions/theme_extensions.dart';
import '../buttons/lumos_buttons.dart';
import '../inputs/lumos_form_widgets.dart';
import '../lumos_models.dart';

abstract final class LumosDialogSizingConst {
  LumosDialogSizingConst._();

  static const double dialogWidthFactor = WidgetRatios.dialogWidthFactor;
  static const double dialogMinWidth = WidgetSizes.dialogMinWidth;
  static const double dialogMaxWidth = WidgetSizes.overlayMaxWidthDesktop;
  static const double dialogHorizontalInset = AppSpacing.lg;
  static const double dialogMinScreenInset = AppSpacing.sm;
  static const double dialogVerticalInset = AppSpacing.xxl;
  static const EdgeInsetsGeometry dialogActionsPadding = EdgeInsets.fromLTRB(
    AppSpacing.lg,
    AppSpacing.none,
    AppSpacing.lg,
    AppSpacing.lg,
  );
  static const EdgeInsetsGeometry dialogActionButtonPadding = EdgeInsets.only(
    left: AppSpacing.sm,
  );
  static const double promptContentSpacing = AppSpacing.md;
  static const double bottomSheetHorizontalInset = AppSpacing.md;
  static const double bottomSheetTopInset = AppSpacing.sm;
  static const double bottomSheetBottomInset = AppSpacing.sm;
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
        LumosButtonFactory.text(
          label: cancelText!,
          onPressed: onCancel,
          size: LumosButtonSize.small,
        ),
      if (confirmText != null)
        LumosButtonFactory.build(
          type: _resolveConfirmButtonType(),
          label: confirmText!,
          onPressed: onConfirm,
          size: LumosButtonSize.small,
        ),
    ];
  }

  LumosButtonType _resolveConfirmButtonType() {
    if (isDestructive) {
      return LumosButtonType.danger;
    }
    return LumosButtonType.primary;
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
    this.hint,
    this.maxLines = 1,
    this.controller,
    this.additionalContent,
    this.isCancelEnabled = true,
    this.isConfirmEnabled = true,
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
  final String? hint;
  final int? maxLines;
  final TextEditingController? controller;
  final Widget? additionalContent;
  final bool isCancelEnabled;
  final bool isConfirmEnabled;
  final BoxConstraints? constraints;
  final EdgeInsets? insetPadding;

  @override
  Widget build(BuildContext context) {
    final TextEditingController resolvedController =
        controller ?? TextEditingController(text: initialValue);
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
      content: _buildContent(controller: resolvedController),
      actions: <Widget>[
        LumosButtonFactory.text(
          label: cancelText,
          onPressed: isCancelEnabled ? onCancel : null,
          size: LumosButtonSize.small,
        ),
        LumosButtonFactory.primary(
          label: confirmText,
          onPressed: isConfirmEnabled
              ? () {
                  onConfirm(resolvedController.text);
                }
              : null,
          size: LumosButtonSize.small,
        ),
      ],
    );
  }

  Widget _buildContent({required TextEditingController controller}) {
    final Widget textField = LumosTextField(
      controller: controller,
      label: label,
      hint: hint,
      maxLines: maxLines,
    );
    if (additionalContent == null) {
      return textField;
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        textField,
        const SizedBox(height: LumosDialogSizingConst.promptContentSpacing),
        additionalContent!,
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
    this.showHandle = true,
  });

  final Widget child;
  final double? initialHeight;
  final bool isScrollControlled;
  final bool showHandle;

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double bottomInset = MediaQuery.paddingOf(context).bottom;
    final double resolvedHeight =
        initialHeight ??
        (screenHeight * WidgetRatios.bottomSheetInitialHeightFactor);
    final double maxHeight = resolvedHeight
        .clamp(WidgetSizes.minTouchTarget, screenHeight)
        .toDouble();
    final ColorScheme colorScheme = context.colorScheme;
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          LumosDialogSizingConst.bottomSheetHorizontalInset,
          LumosDialogSizingConst.bottomSheetTopInset,
          LumosDialogSizingConst.bottomSheetHorizontalInset,
          LumosDialogSizingConst.bottomSheetBottomInset + bottomInset,
        ),
        child: Container(
          constraints: BoxConstraints(
            minHeight: WidgetSizes.minTouchTarget,
            maxHeight: maxHeight,
          ),
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLow,
            borderRadius: BorderRadii.xLarge,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (showHandle)
                Align(
                  child: Container(
                    width: AppSpacing.xxl,
                    height: AppSpacing.xxs,
                    decoration: BoxDecoration(
                      color: colorScheme.onSurfaceVariant.withValues(
                        alpha: AppOpacity.stateFocus,
                      ),
                      borderRadius: BorderRadii.pill,
                    ),
                  ),
                ),
              if (showHandle) const SizedBox(height: AppSpacing.md),
              Flexible(child: child),
            ],
          ),
        ),
      ),
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
            padding: const EdgeInsets.only(top: AppSpacing.md),
            child: LumosButtonFactory.text(
              label: cancelText!,
              onPressed: onCancel,
            ),
          ),
      ],
    );
  }

  Widget _buildActionButton(LumosActionItem action) {
    final LumosButtonType buttonType = _resolveActionButtonType(action: action);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: LumosButtonFactory.build(
        type: buttonType,
        label: action.label,
        icon: action.icon,
        onPressed: action.onPressed,
        expanded: true,
      ),
    );
  }

  LumosButtonType _resolveActionButtonType({required LumosActionItem action}) {
    if (action.isDestructive) {
      return LumosButtonType.danger;
    }
    return LumosButtonType.text;
  }
}
