import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/utils/string_utils.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/lumos_widgets.dart';
import '../../../providers/folder_provider.dart';
import '../../../providers/states/folder_state.dart';

typedef FolderNameSubmit = Future<FolderSubmitResult> Function(String value);
typedef FolderConfirmSubmit = Future<void> Function();

abstract final class FolderDialogConst {
  FolderDialogConst._();

  static const int folderNameMinLength = FolderStateConst.folderNameMinLength;
  static const int folderNameMaxLength = FolderStateConst.folderNameMaxLength;
}

Future<void> showFolderNameDialog({
  required BuildContext context,
  required String Function(AppLocalizations l10n) titleBuilder,
  required String Function(AppLocalizations l10n) actionLabelBuilder,
  required String initialValue,
  required FolderNameSubmit onSubmitted,
}) async {
  final ValueNotifier<bool> isSubmitting = ValueNotifier<bool>(false);
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      final AppLocalizations l10n = AppLocalizations.of(dialogContext)!;
      return LumosPromptDialog(
        title: titleBuilder(l10n),
        label: l10n.folderNameLabel,
        cancelText: l10n.commonCancel,
        confirmText: actionLabelBuilder(l10n),
        initialValue: initialValue,
        onCancel: () {
          if (isSubmitting.value) {
            return;
          }
          dialogContext.pop();
        },
        onConfirm: (String value) {
          unawaited(
            _handleFolderNameSubmit(
              dialogContext: dialogContext,
              l10n: l10n,
              rawValue: value,
              onSubmitted: onSubmitted,
              isSubmitting: isSubmitting,
            ),
          );
        },
      );
    },
  );
  isSubmitting.dispose();
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
      return LumosDialog(
        title: titleBuilder(l10n),
        content: messageBuilder(l10n),
        cancelText: l10n.commonCancel,
        confirmText: confirmLabelBuilder(l10n),
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

Future<void> _handleFolderNameSubmit({
  required BuildContext dialogContext,
  required AppLocalizations l10n,
  required String rawValue,
  required FolderNameSubmit onSubmitted,
  required ValueNotifier<bool> isSubmitting,
}) async {
  if (isSubmitting.value) {
    return;
  }
  final String? validationMessage = _resolveNameValidationMessage(
    l10n: l10n,
    rawValue: rawValue,
  );
  if (validationMessage != null) {
    _showFolderDialogError(context: dialogContext, message: validationMessage);
    return;
  }
  isSubmitting.value = true;
  final FolderSubmitResult submitResult = await onSubmitted(rawValue);
  if (!dialogContext.mounted) {
    return;
  }
  isSubmitting.value = false;
  if (submitResult.isSuccess) {
    dialogContext.pop();
    return;
  }
  final String? nameErrorMessage = submitResult.nameErrorMessage;
  if (nameErrorMessage == null) {
    dialogContext.pop();
    return;
  }
  _showFolderDialogError(context: dialogContext, message: nameErrorMessage);
}

void _showFolderDialogError({
  required BuildContext context,
  required String message,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    LumosSnackbar(
      context: context,
      message: message,
      type: LumosSnackbarType.error,
    ),
  );
}

String? _resolveNameValidationMessage({
  required AppLocalizations l10n,
  required String rawValue,
}) {
  final String normalized = StringUtils.normalizeName(rawValue);
  if (normalized.isEmpty) {
    return l10n.folderNameRequiredValidation;
  }
  if (normalized.length < FolderDialogConst.folderNameMinLength) {
    return l10n.folderNameMinLengthValidation(
      FolderDialogConst.folderNameMinLength,
    );
  }
  if (normalized.length > FolderDialogConst.folderNameMaxLength) {
    return l10n.folderNameMaxLengthValidation(
      FolderDialogConst.folderNameMaxLength,
    );
  }
  return null;
}
