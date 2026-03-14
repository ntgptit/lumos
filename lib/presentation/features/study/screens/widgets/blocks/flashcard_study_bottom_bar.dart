import 'package:flutter/material.dart';

import '../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/lumos_widgets.dart';

class FlashcardStudyBottomBar extends StatelessWidget {
  const FlashcardStudyBottomBar({
    required this.onPreviousPressed,
    required this.onNextPressed,
    super.key,
  });

  final VoidCallback? onPreviousPressed;
  final VoidCallback onNextPressed;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return Row(
      children: <Widget>[
        Expanded(
          child: LumosOutlineButton(
            onPressed: onPreviousPressed,
            icon: Icons.navigate_before_rounded,
            label: l10n.flashcardPreviousButton,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: LumosPrimaryButton(
            onPressed: onNextPressed,
            icon: Icons.navigate_next_rounded,
            label: l10n.flashcardNextButton,
          ),
        ),
      ],
    );
  }
}
