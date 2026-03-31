import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lumos/core/theme/app_foundation.dart';

import '../../../../../../core/utils/string_utils.dart';
import '../../../../../../domain/entities/deck_models.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../providers/deck_provider.dart';
import '../../../providers/states/deck_state.dart';

typedef DeckDialogsUpsertSubmit =
    Future<DeckSubmitResult> Function(DeckUpsertInput input);
typedef DeckDialogsConfirmSubmit = Future<void> Function();

const int _deckNameMinLength = DeckStateConst.deckNameMinLength;
const int _deckNameMaxLength = DeckStateConst.deckNameMaxLength;
const int _deckDescriptionMaxLength = DeckStateConst.deckDescriptionMaxLength;
const String _emptyDeckDialogValue = '';
const int _deckDescriptionMaxLines = 3;

Future<void> showDeckEditorDialog({
  required BuildContext context,
  required String Function(AppLocalizations l10n) titleBuilder,
  required String Function(AppLocalizations l10n) actionLabelBuilder,
  required DeckNode? initialDeck,
  required DeckDialogsUpsertSubmit onSubmitted,
}) async {
  String currentName = initialDeck?.name ?? _emptyDeckDialogValue;
  String currentDescription = initialDeck?.description ?? _emptyDeckDialogValue;
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
                icon: initialDeck == null
                    ? const LumosDialogIcon(Icons.style_outlined)
                    : const LumosDialogIcon(
                        Icons.drive_file_rename_outline_rounded,
                      ),
                label: l10n.deckNameLabel,
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
                  label: l10n.deckDescriptionLabel,
                  hintText: l10n.deckDescriptionHint,
                  maxLines: _deckDescriptionMaxLines,
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
  required DeckDialogsConfirmSubmit onConfirmed,
}) async {
  await showDialog<void>(
    context: context,
    builder: (BuildContext dialogContext) {
      final AppLocalizations l10n = AppLocalizations.of(dialogContext)!;
      return LumosDialog(
        title: titleBuilder(l10n),
        icon: const LumosDialogIcon.destructive(Icons.delete_outline_rounded),
        message: messageBuilder(l10n),
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

Future<void> _handleDeckEditorSubmit({
  required BuildContext dialogContext,
  required AppLocalizations l10n,
  required String rawName,
  required String rawDescription,
  required DeckDialogsUpsertSubmit onSubmitted,
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
    description: StringUtils.normalizeText(rawDescription),
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
    SnackBar(
      content: LumosSnackbar(message: message, type: LumosSnackbarType.error),
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
  if (normalizedDescription.length > _deckDescriptionMaxLength) {
    return l10n.deckDescriptionMaxLengthValidation(_deckDescriptionMaxLength);
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
  if (normalized.length < _deckNameMinLength) {
    return l10n.deckNameMinLengthValidation(_deckNameMinLength);
  }
  if (normalized.length > _deckNameMaxLength) {
    return l10n.deckNameMaxLengthValidation(_deckNameMaxLength);
  }
  return null;
}
