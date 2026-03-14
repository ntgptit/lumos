import 'package:flutter/material.dart';

import '../../../../../../core/themes/foundation/app_foundation.dart';
import '../../flashcard_content_support.dart';
import '../../../../../shared/widgets/lumos_widgets.dart';

class FlashcardLoadingMask extends StatelessWidget {
  const FlashcardLoadingMask({required this.isVisible, super.key});

  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    if (!isVisible) {
      return const SizedBox.shrink();
    }
    return IgnorePointer(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(
            top: FlashcardContentSupportConst.progressMaskTopInset,
          ),
          child: ClipRRect(
            borderRadius: BorderRadii.medium,
            child: const LumosLoadingIndicator(
              isLinear: true,
              size: FlashcardContentSupportConst.progressMaskHeight,
            ),
          ),
        ),
      ),
    );
  }
}
