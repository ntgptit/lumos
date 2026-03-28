import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/presentation/shared/composites/dialogs/lumos_bottom_sheet.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_danger_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_outline_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_text_button.dart';

class LumosActionSheet extends StatelessWidget {
  const LumosActionSheet({
    super.key,
    this.title,
    required this.actions,
    this.subtitle,
    this.cancelLabel = 'Cancel',
    this.cancelText,
    this.onCancel,
  });

  final String? title;
  final String? subtitle;
  final List<AppActionSheetAction> actions;
  final String cancelLabel;
  final String? cancelText;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    return LumosBottomSheet(
      title: title,
      subtitle: subtitle,
      actions: [
        LumosTextButton(text: cancelLabel, onPressed: () => context.pop()),
        if (cancelText != null)
          LumosTextButton(text: cancelText!, onPressed: onCancel),
      ],
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: actions.length,
        separatorBuilder: (context, index) =>
            SizedBox(height: context.spacing.sm),
        itemBuilder: (context, index) {
          final action = actions[index];
          final button = action.destructive
              ? LumosDangerButton(
                  text: action.label,
                  expand: true,
                  onPressed: action.onPressed,
                )
              : action.variant == AppActionSheetActionVariant.outline
              ? LumosOutlineButton(
                  text: action.label,
                  expand: true,
                  onPressed: action.onPressed,
                )
              : LumosTextButton(
                  text: action.label,
                  expand: true,
                  onPressed: action.onPressed,
                );
          return button;
        },
      ),
    );
  }
}

class LumosActionItem extends AppActionSheetAction {
  const LumosActionItem({
    required super.label,
    super.onPressed,
    super.destructive,
    super.variant,
    this.icon,
  });

  final IconData? icon;
}

class AppActionSheetAction {
  const AppActionSheetAction({
    required this.label,
    required this.onPressed,
    this.destructive = false,
    this.variant = AppActionSheetActionVariant.text,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool destructive;
  final AppActionSheetActionVariant variant;
}

enum AppActionSheetActionVariant { text, outline }
