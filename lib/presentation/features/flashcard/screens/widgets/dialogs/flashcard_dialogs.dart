import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/utils/string_utils.dart';
import '../../../../../../domain/entities/flashcard_models.dart';
import '../../../../../../l10n/app_localizations.dart';
import 'package:lumos/presentation/shared/composites/dialogs/lumos_dialog.dart';
import 'package:lumos/presentation/shared/composites/dialogs/lumos_prompt_dialog.dart';
import 'package:lumos/presentation/shared/primitives/feedback/lumos_snackbar.dart';
import 'package:lumos/presentation/shared/primitives/inputs/lumos_text_field.dart';
import '../../../providers/flashcard_dialog_form_provider.dart';
import '../../../providers/flashcard_provider.dart';
import '../../../providers/states/flashcard_dialog_form_state.dart';

typedef FlashcardDialogsUpsertSubmit =
    Future<FlashcardSubmitResult> Function(FlashcardUpsertInput input);
typedef FlashcardDialogsConfirmSubmit = Future<void> Function();

abstract final class FlashcardDialogsConst {
  FlashcardDialogsConst._();

  static const int backTextMaxLines = 4;
  static const String emptyValue = '';
}

Future<void> showFlashcardEditorDialog({
  required BuildContext context,
  required String Function(AppLocalizations l10n) titleBuilder,
  required String Function(AppLocalizations l10n) actionLabelBuilder,
  required FlashcardNode? initialFlashcard,
  required FlashcardDialogsUpsertSubmit onSubmitted,
}) async {
  final String initialFrontText =
      initialFlashcard?.frontText ?? FlashcardDialogsConst.emptyValue;
  final String initialBackText =
      initialFlashcard?.backText ?? FlashcardDialogsConst.emptyValue;

  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      final AppLocalizations l10n = AppLocalizations.of(dialogContext)!;
      return Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final FlashcardDialogFormState formState = ref.watch(
            flashcardDialogFormControllerProvider(
              initialFrontText,
              initialBackText,
            ),
          );
          final FlashcardDialogFormController formController = ref.read(
            flashcardDialogFormControllerProvider(
              initialFrontText,
              initialBackText,
            ).notifier,
          );

          return LumosPromptDialog(
            title: titleBuilder(l10n),
            label: l10n.flashcardFrontLabel,
            hint: l10n.flashcardFrontHint,
            cancelText: l10n.commonCancel,
            confirmText: actionLabelBuilder(l10n),
            controller: formController.frontTextController,
            additionalContent: LumosTextField(
              controller: formController.backTextController,
              label: l10n.flashcardBackLabel,
              hint: l10n.flashcardBackHint,
              maxLines: FlashcardDialogsConst.backTextMaxLines,
              textInputAction: TextInputAction.newline,
            ),
            isCancelEnabled: !formState.isSubmitting,
            isConfirmEnabled: !formState.isSubmitting,
            onCancel: () {
              if (formState.isSubmitting) {
                return;
              }
              dialogContext.pop();
            },
            onConfirm: (_) {
              if (formState.isSubmitting) {
                return;
              }
              formController.startSubmitting();
              unawaited(
                _handleSubmit(
                  dialogContext: dialogContext,
                  l10n: l10n,
                  rawFrontText: formState.frontText,
                  rawBackText: formState.backText,
                  onSubmitted: onSubmitted,
                  onSubmitDone: () {
                    if (!dialogContext.mounted) {
                      return;
                    }
                    formController.stopSubmitting();
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
  required FlashcardDialogsConfirmSubmit onConfirmed,
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
  required FlashcardDialogsUpsertSubmit onSubmitted,
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
    frontText: StringUtils.normalizeText(rawFrontText),
    backText: StringUtils.normalizeText(rawBackText),
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
  final String frontText = StringUtils.normalizeText(rawFrontText);
  if (frontText.isEmpty) {
    return l10n.flashcardFrontRequiredValidation;
  }
  if (frontText.length > FlashcardDomainConst.frontTextMaxLength) {
    return l10n.flashcardFrontMaxLengthValidation(
      FlashcardDomainConst.frontTextMaxLength,
    );
  }
  final String backText = StringUtils.normalizeText(rawBackText);
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
    SnackBar(
      content: LumosSnackbar(
        message: message,
        type: LumosSnackbarType.error,
      ),
    ),
  );
}

