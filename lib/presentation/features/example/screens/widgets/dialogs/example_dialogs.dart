import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../shared/widgets/lumos_widgets.dart';

Future<void> showExampleDialog({
  required BuildContext context,
  required String title,
  required String message,
}) async {
  await showDialog<void>(
    context: context,
    builder: (BuildContext dialogContext) {
      return LumosDialog(
        title: title,
        content: message,
        cancelText: 'OK',
        onCancel: () {
          dialogContext.pop();
        },
      );
    },
  );
}
