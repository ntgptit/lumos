import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/utils/string_utils.dart';
import '../../../../../../domain/entities/folder_models.dart';
import '../../../../../../l10n/app_localizations.dart';
import 'package:lumos/presentation/shared/composites/dialogs/lumos_dialog.dart';
import 'package:lumos/presentation/shared/composites/dialogs/lumos_prompt_dialog.dart';
import 'package:lumos/presentation/shared/primitives/feedback/lumos_snackbar.dart';
import 'package:lumos/presentation/shared/primitives/inputs/lumos_text_field.dart';
import '../../../providers/folder_provider.dart';
import '../../../providers/states/folder_state.dart';

typedef FolderDialogsUpsertSubmit =
    Future<FolderSubmitResult> Function(FolderUpsertInput input);
typedef FolderDialogsConfirmSubmit = Future<void> Function();

const int _folderNameMinLength = FolderStateConst.folderNameMinLength;
const int _folderNameMaxLength = FolderStateConst.folderNameMaxLength;
const int _folderDescriptionMaxLength =
    FolderStateConst.folderDescriptionMaxLength;
const String _emptyFolderDialogValue = '';
const int _folderDescriptionMaxLines = 3;

Future<void> showFolderEditorDialog({
  required BuildContext context,
  required String Function(AppLocalizations l10n) titleBuilder,
  required String Function(AppLocalizations l10n) actionLabelBuilder,
  required FolderNode? initialFolder,
  required FolderDialogsUpsertSubmit onSubmitted,
}) async {
  String currentName = initialFolder?.name ?? _emptyFolderDialogValue;
  String currentDescription =
      initialFolder?.description ?? _emptyFolderDialogValue;
  bool isSubmitting = false;
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      final AppLocalizations l10n = AppLocalizations.of(dialogContext)!;
      return StatefulBuilder(
        builder:
            (BuildContext _, void Function(void Function()) setDialogState) {
              return LumosPromptDialog(
                title: titleBuilder(l10n),
                label: l10n.folderNameLabel,
                maxLines: 1,
                cancelText: l10n.commonCancel,
                confirmText: actionLabelBuilder(l10n),
                initialValue: currentName,
                additionalContent: LumosTextField(
                  initialValue: currentDescription,
                  onChanged: (String value) {
                    setDialogState(() {
                      currentDescription = value;
                    });
                  },
                  label: l10n.folderDescriptionLabel,
                  hint: l10n.folderDescriptionHint,
                  maxLines: _folderDescriptionMaxLines,
                  textInputAction: TextInputAction.newline,
                ),
                isCancelEnabled: !isSubmitting,
                isConfirmEnabled: !isSubmitting,
                onCancel: () {
                  if (isSubmitting) {
                    return;
                  }
                  dialogContext.pop();
                },
                onConfirm: (String rawName) {
                  if (isSubmitting) {
                    return;
                  }
                  setDialogState(() {
                    currentName = rawName;
                    isSubmitting = true;
                  });
                  unawaited(
                    _handleFolderEditorSubmit(
                      dialogContext: dialogContext,
                      l10n: l10n,
                      rawName: rawName,
                      rawDescription: currentDescription,
                      parentId: initialFolder?.parentId,
                      onSubmitted: onSubmitted,
                      onSubmitDone: () {
                        if (!dialogContext.mounted) {
                          return;
                        }
                        setDialogState(() {
                          isSubmitting = false;
                        });
                      },
                    ),
                  );
                },
              );
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
  required FolderDialogsConfirmSubmit onConfirmed,
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

Future<void> _handleFolderEditorSubmit({
  required BuildContext dialogContext,
  required AppLocalizations l10n,
  required String rawName,
  required String rawDescription,
  required int? parentId,
  required FolderDialogsUpsertSubmit onSubmitted,
  required VoidCallback onSubmitDone,
}) async {
  final String? validationMessage = _resolveFormValidationMessage(
    l10n: l10n,
    rawName: rawName,
    rawDescription: rawDescription,
  );
  if (validationMessage != null) {
    onSubmitDone();
    _showFolderDialogError(context: dialogContext, message: validationMessage);
    return;
  }
  final FolderUpsertInput input = FolderUpsertInput(
    name: StringUtils.normalizeName(rawName),
    description: StringUtils.normalizeText(rawDescription),
    parentId: parentId,
  );
  final FolderSubmitResult submitResult = await onSubmitted(input);
  if (!dialogContext.mounted) {
    return;
  }
  if (submitResult.isSuccess) {
    dialogContext.pop();
    return;
  }
  onSubmitDone();
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
    SnackBar(
      content: LumosSnackbar(
        message: message,
        type: LumosSnackbarType.error,
      ),
    ),
  );
}

String? _resolveFormValidationMessage({
  required AppLocalizations l10n,
  required String rawName,
  required String rawDescription,
}) {
  final String? nameValidationMessage = _resolveNameValidationMessage(
    l10n: l10n,
    rawValue: rawName,
  );
  if (nameValidationMessage != null) {
    return nameValidationMessage;
  }
  final String normalizedDescription = StringUtils.normalizeText(
    rawDescription,
  );
  if (normalizedDescription.length > _folderDescriptionMaxLength) {
    return l10n.folderDescriptionMaxLengthValidation(
      _folderDescriptionMaxLength,
    );
  }
  return null;
}

String? _resolveNameValidationMessage({
  required AppLocalizations l10n,
  required String rawValue,
}) {
  final String normalized = StringUtils.normalizeName(rawValue);
  if (normalized.isEmpty) {
    return l10n.folderNameRequiredValidation;
  }
  if (normalized.length < _folderNameMinLength) {
    return l10n.folderNameMinLengthValidation(_folderNameMinLength);
  }
  if (normalized.length > _folderNameMaxLength) {
    return l10n.folderNameMaxLengthValidation(_folderNameMaxLength);
  }
  return null;
}

