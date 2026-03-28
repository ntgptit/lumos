import 'package:flutter/material.dart';
import 'package:lumos/core/enums/snackbar_type.dart';
import 'package:lumos/presentation/shared/primitives/feedback/lumos_banner.dart';

class LumosMessageBanner extends StatelessWidget {
  const LumosMessageBanner({
    super.key,
    required this.message,
    this.title,
    this.type = SnackbarType.info,
    this.actionLabel,
    this.onActionPressed,
    this.dense = false,
  });

  final String message;
  final String? title;
  final SnackbarType type;
  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return LumosBanner(
      message: message,
      title: title,
      type: type,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      dense: dense,
    );
  }
}
