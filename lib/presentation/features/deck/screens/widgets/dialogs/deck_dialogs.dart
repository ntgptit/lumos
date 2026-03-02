import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/utils/string_utils.dart';
import '../../../../../../domain/entities/deck_models.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/lumos_widgets.dart';
import '../../../providers/deck_provider.dart';
import '../../../providers/states/deck_state.dart';

typedef DeckUpsertSubmit =
    Future<DeckSubmitResult> Function(DeckUpsertInput input);
typedef DeckConfirmSubmit = Future<void> Function();

abstract final class DeckDialogConst {
  DeckDialogConst._();

  static const int deckNameMinLength = DeckStateConst.deckNameMinLength;
  static const int deckNameMaxLength = DeckStateConst.deckNameMaxLength;
  static const int deckDescriptionMaxLength =
      DeckStateConst.deckDescriptionMaxLength;
  static const String emptyValue = '';
  static const int deckDescriptionMaxLines = 3;
}

Future<void> showDeckEditorDialog({
  required BuildContext context,
  required String Function(AppLocalizations l10n) titleBuilder,
  required String Function(AppLocalizations l10n) actionLabelBuilder,
  required DeckNode? initialDeck,
  required DeckUpsertSubmit onSubmitted,
}) async {
  String currentName = initialDeck?.name ?? DeckDialogConst.emptyValue;
  String currentDescription =
      initialDeck?.description ?? DeckDialogConst.emptyValue;
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
                label: l10n.deckNameLabel,
                maxLines: 1,
                cancelText: l10n.commonCancel,
                confirmText: actionLabelBuilder(l10n),
                initialValue: currentName,
                additionalContent: _buildAdditionalContent(
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
                    _handleDeckEditorSubmit(
                      dialogContext: dialogContext,
                      l10n: l10n,
                      rawName: rawName,
                      rawDescription: currentDescription,
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

Future<void> showDeckConfirmDialog({
  required BuildContext context,
  required String Function(AppLocalizations l10n) titleBuilder,
  required String Function(AppLocalizations l10n) messageBuilder,
  required String Function(AppLocalizations l10n) confirmLabelBuilder,
  required DeckConfirmSubmit onConfirmed,
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

Widget _buildAdditionalContent({
  required AppLocalizations l10n,
  required String initialDescription,
  required ValueChanged<String> onDescriptionChanged,
}) {
  return LumosTextField(
    initialValue: initialDescription,
    onChanged: onDescriptionChanged,
    label: l10n.deckDescriptionLabel,
    hint: l10n.deckDescriptionHint,
    maxLines: DeckDialogConst.deckDescriptionMaxLines,
    textInputAction: TextInputAction.newline,
  );
}

Future<void> _handleDeckEditorSubmit({
  required BuildContext dialogContext,
  required AppLocalizations l10n,
  required String rawName,
  required String rawDescription,
  required DeckUpsertSubmit onSubmitted,
  required VoidCallback onSubmitDone,
}) async {
  final String? validationMessage = _resolveFormValidationMessage(
    l10n: l10n,
    rawName: rawName,
    rawDescription: rawDescription,
  );
  if (validationMessage != null) {
    onSubmitDone();
    _showError(context: dialogContext, message: validationMessage);
    return;
  }
  final DeckUpsertInput input = DeckUpsertInput(
    name: StringUtils.normalizeName(rawName),
    description: StringUtils.normalizeName(rawDescription),
  );
  final DeckSubmitResult submitResult = await onSubmitted(input);
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
  _showError(context: dialogContext, message: nameErrorMessage);
}

void _showError({required BuildContext context, required String message}) {
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
  if (normalizedDescription.length > DeckDialogConst.deckDescriptionMaxLength) {
    return l10n.deckDescriptionMaxLengthValidation(
      DeckDialogConst.deckDescriptionMaxLength,
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
    return l10n.deckNameRequiredValidation;
  }
  if (normalized.length < DeckDialogConst.deckNameMinLength) {
    return l10n.deckNameMinLengthValidation(DeckDialogConst.deckNameMinLength);
  }
  if (normalized.length > DeckDialogConst.deckNameMaxLength) {
    return l10n.deckNameMaxLengthValidation(DeckDialogConst.deckNameMaxLength);
  }
  return null;
}
