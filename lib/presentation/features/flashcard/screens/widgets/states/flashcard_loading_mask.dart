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
    final double topInset = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardContentSupportConst.progressMaskTopInset,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double progressHeight = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardContentSupportConst.progressMaskHeight,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    return IgnorePointer(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.only(top: topInset),
          child: ClipRRect(
            borderRadius: BorderRadii.medium,
            child: LumosLoadingIndicator(isLinear: true, size: progressHeight),
          ),
        ),
      ),
    );
  }
}
