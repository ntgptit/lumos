import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';

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
      return SizedBox.shrink();
    }
    final double bottomInset = context.compactValue(
      baseValue:
          context.spacing.xxl,
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
