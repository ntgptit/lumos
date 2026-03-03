import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/utils/string_utils.dart';
import '../../../../../../domain/entities/flashcard_models.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/lumos_widgets.dart';
import '../../../providers/flashcard_provider.dart';

typedef FlashcardUpsertSubmit =
    Future<FlashcardSubmitResult> Function(FlashcardUpsertInput input);
typedef FlashcardConfirmSubmit = Future<void> Function();

abstract final class FlashcardDialogConst {
  FlashcardDialogConst._();

  static const int backTextMaxLines = 4;
}

Future<void> showFlashcardEditorDialog({
  required BuildContext context,
  required String Function(AppLocalizations l10n) titleBuilder,
  required String Function(AppLocalizations l10n) actionLabelBuilder,
  required FlashcardNode? initialFlashcard,
  required FlashcardUpsertSubmit onSubmitted,
}) async {
  String currentFrontText = initialFlashcard?.frontText ?? '';
  String currentBackText = initialFlashcard?.backText ?? '';
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
                label: l10n.flashcardFrontLabel,
                hint: l10n.flashcardFrontHint,
                cancelText: l10n.commonCancel,
                confirmText: actionLabelBuilder(l10n),
                initialValue: currentFrontText,
                additionalContent: LumosTextField(
                  initialValue: currentBackText,
                  onChanged: (String value) {
                    setDialogState(() {
                      currentBackText = value;
                    });
                  },
                  label: l10n.flashcardBackLabel,
                  hint: l10n.flashcardBackHint,
                  maxLines: FlashcardDialogConst.backTextMaxLines,
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
                onConfirm: (String rawFrontText) {
                  if (isSubmitting) {
                    return;
                  }
                  setDialogState(() {
                    currentFrontText = rawFrontText;
                    isSubmitting = true;
                  });
                  unawaited(
                    _handleSubmit(
                      dialogContext: dialogContext,
                      l10n: l10n,
                      rawFrontText: rawFrontText,
                      rawBackText: currentBackText,
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

Future<void> showFlashcardConfirmDialog({
  required BuildContext context,
  required String Function(AppLocalizations l10n) titleBuilder,
  required String Function(AppLocalizations l10n) messageBuilder,
  required String Function(AppLocalizations l10n) confirmLabelBuilder,
  required FlashcardConfirmSubmit onConfirmed,
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

Future<void> _handleSubmit({
  required BuildContext dialogContext,
  required AppLocalizations l10n,
  required String rawFrontText,
  required String rawBackText,
  required FlashcardUpsertSubmit onSubmitted,
  required VoidCallback onSubmitDone,
}) async {
  final String? validationMessage = _resolveValidationMessage(
    l10n: l10n,
    rawFrontText: rawFrontText,
    rawBackText: rawBackText,
  );
  if (validationMessage != null) {
    onSubmitDone();
    _showError(context: dialogContext, message: validationMessage);
    return;
  }
  final FlashcardUpsertInput input = FlashcardUpsertInput(
    frontText: StringUtils.normalizeName(rawFrontText),
    backText: StringUtils.normalizeName(rawBackText),
    frontLangCode: null,
    backLangCode: null,
  );
  final FlashcardSubmitResult submitResult = await onSubmitted(input);
  if (!dialogContext.mounted) {
    return;
  }
  if (submitResult.isSuccess) {
    dialogContext.pop();
    return;
  }
  onSubmitDone();
  final String message = submitResult.formErrorMessage ?? l10n.commonRetry;
  _showError(context: dialogContext, message: message);
}

String? _resolveValidationMessage({
  required AppLocalizations l10n,
  required String rawFrontText,
  required String rawBackText,
}) {
  final String frontText = StringUtils.normalizeName(rawFrontText);
  if (frontText.isEmpty) {
    return l10n.flashcardFrontRequiredValidation;
  }
  if (frontText.length > FlashcardDomainConst.frontTextMaxLength) {
    return l10n.flashcardFrontMaxLengthValidation(
      FlashcardDomainConst.frontTextMaxLength,
    );
  }
  final String backText = StringUtils.normalizeName(rawBackText);
  if (backText.isEmpty) {
    return l10n.flashcardBackRequiredValidation;
  }
  if (backText.length > FlashcardDomainConst.backTextMaxLength) {
    return l10n.flashcardBackMaxLengthValidation(
      FlashcardDomainConst.backTextMaxLength,
    );
  }
  return null;
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
