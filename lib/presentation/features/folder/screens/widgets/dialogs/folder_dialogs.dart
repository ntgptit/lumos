import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/constants/dimensions.dart';
import '../../../../../../core/utils/string_utils.dart';
import '../../../../../../domain/entities/folder_models.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/lumos_widgets.dart';
import '../../../providers/folder_provider.dart';
import '../../../providers/states/folder_state.dart';

typedef FolderUpsertSubmit =
    Future<FolderSubmitResult> Function(FolderUpsertInput input);
typedef FolderConfirmSubmit = Future<void> Function();

abstract final class FolderDialogConst {
  FolderDialogConst._();

  static const int folderNameMinLength = FolderStateConst.folderNameMinLength;
  static const int folderNameMaxLength = FolderStateConst.folderNameMaxLength;
  static const int folderDescriptionMaxLength =
      FolderStateConst.folderDescriptionMaxLength;
  static const String emptyValue = '';
  static const int folderDescriptionMaxLines = 3;
  static const double sectionSpacing = Insets.spacing12;
}

Future<void> showFolderEditorDialog({
  required BuildContext context,
  required String Function(AppLocalizations l10n) titleBuilder,
  required String Function(AppLocalizations l10n) actionLabelBuilder,
  required FolderNode? initialFolder,
  required FolderUpsertSubmit onSubmitted,
}) async {
  String currentName = initialFolder?.name ?? FolderDialogConst.emptyValue;
  String currentDescription =
      initialFolder?.description ?? FolderDialogConst.emptyValue;
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
                additionalContent: _buildEditorAdditionalContent(
                  l10n: l10n,
                  initialDescription: currentDescription,
                  onDescriptionChanged: (String value) {
                    setDialogState(() {
                      currentDescription = value;
                    });
                  },
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

Widget _buildEditorAdditionalContent({
  required AppLocalizations l10n,
  required String initialDescription,
  required ValueChanged<String> onDescriptionChanged,
}) {
  return LumosTextField(
    initialValue: initialDescription,
    onChanged: onDescriptionChanged,
    label: l10n.folderDescriptionLabel,
    hint: l10n.folderDescriptionHint,
    maxLines: FolderDialogConst.folderDescriptionMaxLines,
    textInputAction: TextInputAction.newline,
  );
}

Future<void> _handleFolderEditorSubmit({
  required BuildContext dialogContext,
  required AppLocalizations l10n,
  required String rawName,
  required String rawDescription,
  required int? parentId,
  required FolderUpsertSubmit onSubmitted,
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
    description: StringUtils.normalizeName(rawDescription),
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
    LumosSnackbar(
      context: context,
      message: message,
      type: LumosSnackbarType.error,
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
  final String normalizedDescription = StringUtils.normalizeName(
    rawDescription,
  );
  if (normalizedDescription.length >
      FolderDialogConst.folderDescriptionMaxLength) {
    return l10n.folderDescriptionMaxLengthValidation(
      FolderDialogConst.folderDescriptionMaxLength,
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
