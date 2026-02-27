import 'package:flutter/material.dart';

import '../../../../../../core/themes/constants/dimensions.dart';
import '../../../../../shared/widgets/lumos_widgets.dart';

class FolderErrorBanner extends StatelessWidget {
  const FolderErrorBanner({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(Insets.spacing12),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadii.medium,
      ),
      child: LumosText(
        message,
        style: LumosTextStyle.bodySmall,
        color: colorScheme.onErrorContainer,
      ),
    );
  }
}
