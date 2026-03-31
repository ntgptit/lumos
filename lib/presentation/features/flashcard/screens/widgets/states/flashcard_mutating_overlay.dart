import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';

class FlashcardMutatingOverlay extends StatelessWidget {
  const FlashcardMutatingOverlay({required this.isVisible, super.key});

  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    if (!isVisible) {
      return SizedBox.shrink();
    }
    return Positioned.fill(
      child: IgnorePointer(
        child: ColoredBox(
          color: context.theme.colorScheme.scrim.withValues(alpha: AppOpacity.strong),
          child: const Center(child: LumosLoadingIndicator()),
        ),
      ),
    );
  }
}
