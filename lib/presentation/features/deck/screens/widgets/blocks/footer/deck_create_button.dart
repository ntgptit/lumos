import 'package:flutter/material.dart';

import '../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../shared/widgets/lumos_widgets.dart';

class DeckCreateButton extends StatelessWidget {
  const DeckCreateButton({
    required this.horizontalInset,
    required this.label,
    required this.onPressed,
    required this.isMutating,
    super.key,
  });

  final double horizontalInset;
  final String label;
  final VoidCallback onPressed;
  final bool isMutating;

  @override
  Widget build(BuildContext context) {
    if (isMutating) {
      return const SizedBox.shrink();
    }
    final double bottomInset = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.xxl,
      minScale: ResponsiveDimensions.compactVerticalInsetScale,
    );
    return Positioned(
      right: horizontalInset,
      bottom: bottomInset,
      child: LumosFloatingActionButton(
        onPressed: onPressed,
        icon: Icons.style_outlined,
        label: label,
      ),
    );
  }
}
