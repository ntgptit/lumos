import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/lumos_widgets.dart';

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
      return LumosPromptDialog(
        title: titleBuilder(l10n),
        label: l10n.folderNameLabel,
        cancelText: l10n.commonCancel,
        confirmText: actionLabelBuilder(l10n),
        initialValue: initialValue,
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
