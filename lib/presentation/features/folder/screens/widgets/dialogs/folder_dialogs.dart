import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/themes/constants/dimensions.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/lumos_widgets.dart';

class FolderDialogsConst {
  const FolderDialogsConst._();

  static const double dialogWidthFactor = 0.84;
  static const double dialogMinWidth = 340;
  static const double dialogMaxWidth = 620;
  static const double dialogHorizontalInset = Insets.spacing16;
  static const double dialogMinScreenInset = Insets.spacing8;
  static const double dialogVerticalInset = Insets.spacing24;
}

typedef FolderNameSubmit = Future<void> Function(String value);
typedef FolderConfirmSubmit = Future<void> Function();

Future<void> showFolderNameDialog({
  required BuildContext context,
  required String Function(AppLocalizations l10n) titleBuilder,
  required String Function(AppLocalizations l10n) actionLabelBuilder,
  required String initialValue,
  required FolderNameSubmit onSubmitted,
}) async {
  await showDialog<void>(
    context: context,
    builder: (BuildContext dialogContext) {
      final AppLocalizations l10n = AppLocalizations.of(dialogContext)!;
      final BoxConstraints constraints = _resolveDialogConstraints(
        context: dialogContext,
      );
      final EdgeInsets insetPadding = _resolveDialogInsetPadding(
        context: dialogContext,
      );
      return LumosPromptDialog(
        title: titleBuilder(l10n),
        label: l10n.folderNameLabel,
        cancelText: l10n.commonCancel,
        confirmText: actionLabelBuilder(l10n),
        initialValue: initialValue,
        constraints: constraints,
        insetPadding: insetPadding,
        onCancel: () => dialogContext.pop(),
        onConfirm: (String value) async {
          dialogContext.pop();
          await onSubmitted(value);
        },
      );
    },
  );
}

Future<void> showFolderConfirmDialog({
  required BuildContext context,
  required String Function(AppLocalizations l10n) titleBuilder,
  required String Function(AppLocalizations l10n) messageBuilder,
  required String Function(AppLocalizations l10n) confirmLabelBuilder,
  required FolderConfirmSubmit onConfirmed,
}) async {
  await showDialog<void>(
    context: context,
    builder: (BuildContext dialogContext) {
      final AppLocalizations l10n = AppLocalizations.of(dialogContext)!;
      final BoxConstraints constraints = _resolveDialogConstraints(
        context: dialogContext,
      );
      final EdgeInsets insetPadding = _resolveDialogInsetPadding(
        context: dialogContext,
      );
      return LumosDialog(
        title: titleBuilder(l10n),
        content: messageBuilder(l10n),
        cancelText: l10n.commonCancel,
        confirmText: confirmLabelBuilder(l10n),
        constraints: constraints,
        insetPadding: insetPadding,
        onCancel: () => dialogContext.pop(),
        onConfirm: () async {
          dialogContext.pop();
          await onConfirmed();
        },
        isDestructive: true,
      );
    },
  );
}

BoxConstraints _resolveDialogConstraints({required BuildContext context}) {
  final double dialogWidth = _resolveDialogWidth(context: context);
  return BoxConstraints(minWidth: dialogWidth, maxWidth: dialogWidth);
}

EdgeInsets _resolveDialogInsetPadding({required BuildContext context}) {
  final double screenWidth = MediaQuery.sizeOf(context).width;
  final double dialogWidth = _resolveDialogWidth(context: context);
  final double rawInset = (screenWidth - dialogWidth) / 2;
  final double horizontalInset = rawInset
      .clamp(FolderDialogsConst.dialogMinScreenInset, screenWidth)
      .toDouble();
  return EdgeInsets.symmetric(
    horizontal: horizontalInset,
    vertical: FolderDialogsConst.dialogVerticalInset,
  );
}

double _resolveDialogWidth({required BuildContext context}) {
  final double screenWidth = MediaQuery.sizeOf(context).width;
  final double maxAvailableWidth =
      screenWidth - (FolderDialogsConst.dialogHorizontalInset * 2);
  if (maxAvailableWidth <= FolderDialogsConst.dialogMinWidth) {
    return maxAvailableWidth;
  }

  final double scaledWidth = screenWidth * FolderDialogsConst.dialogWidthFactor;
  if (scaledWidth < FolderDialogsConst.dialogMinWidth) {
    return FolderDialogsConst.dialogMinWidth;
  }
  if (scaledWidth > FolderDialogsConst.dialogMaxWidth) {
    return FolderDialogsConst.dialogMaxWidth;
  }
  if (scaledWidth > maxAvailableWidth) {
    return maxAvailableWidth;
  }
  return scaledWidth;
}
