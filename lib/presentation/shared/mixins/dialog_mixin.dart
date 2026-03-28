import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lumos/core/enums/dialog_type.dart';
import 'package:lumos/presentation/shared/composites/dialogs/lumos_bottom_sheet.dart';
import 'package:lumos/presentation/shared/composites/dialogs/lumos_confirm_dialog.dart';

mixin DialogMixin<T extends StatefulWidget> on State<T> {
  Future<R?> showAppDialog<R>({
    required WidgetBuilder builder,
    bool barrierDismissible = true,
    bool useRootNavigator = true,
  }) {
    return showDialog<R>(
      context: context,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      builder: builder,
    );
  }

  Future<bool?> showConfirmDialog({
    required String title,
    Widget? content,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    DialogType type = DialogType.confirm,
    bool isDestructive = false,
  }) {
    return showAppDialog<bool>(
      builder: (dialogContext) {
        return LumosConfirmDialog(
          title: title,
          content: content,
          confirmLabel: confirmLabel,
          cancelLabel: cancelLabel,
          type: type,
          isDestructive: isDestructive,
          onConfirm: () => dialogContext.pop(true),
          onCancel: () => dialogContext.pop(false),
        );
      },
    );
  }

  Future<R?> showAppBottomSheet<R>({
    required Widget child,
    String? title,
    String? subtitle,
    List<Widget>? actions,
    bool isScrollControlled = true,
    bool useRootNavigator = false,
    double maxHeightFactor = 0.9,
  }) {
    return showModalBottomSheet<R>(
      context: context,
      isScrollControlled: isScrollControlled,
      useRootNavigator: useRootNavigator,
      backgroundColor: Colors.transparent,
      builder: (_) => LumosBottomSheet(
        title: title,
        subtitle: subtitle,
        actions: actions,
        maxHeightFactor: maxHeightFactor,
        child: child,
      ),
    );
  }
}
