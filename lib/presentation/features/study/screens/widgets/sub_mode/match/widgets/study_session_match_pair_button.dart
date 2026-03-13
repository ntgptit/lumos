import 'package:flutter/material.dart';

import '../../../../../../../../l10n/app_localizations.dart';
import '../../../../../../../shared/widgets/lumos_widgets.dart';

class StudySessionMatchPairButton extends StatelessWidget {
  const StudySessionMatchPairButton({
    required this.label,
    required this.isMatched,
    required this.isSelected,
    required this.onPressed,
    super.key,
  });

  final String label;
  final bool isMatched;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    if (isMatched) {
      return LumosSecondaryButton(
        onPressed: null,
        label: l10n.studyMatchCompletedItemLabel(label),
        expanded: true,
      );
    }
    if (isSelected) {
      return LumosPrimaryButton(
        onPressed: onPressed,
        label: label,
        expanded: true,
      );
    }
    return LumosOutlineButton(
      onPressed: onPressed,
      label: label,
      expanded: true,
    );
  }
}
