import 'package:flutter/material.dart';

import '../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../core/themes/extensions/theme_extensions.dart';
import '../../../../../../shared/widgets/lumos_widgets.dart';

abstract final class FlashcardStudyActionSectionConst {
  FlashcardStudyActionSectionConst._();

  static const double itemSpacing = AppSpacing.md;
  static const double iconContainerSize = WidgetSizes.avatarMedium;
  static const double iconSize = IconSizes.iconSmall;
  static const double labelLeftSpacing = AppSpacing.md;
}

enum FlashcardStudyActionSectionTone {
  primary,
  info,
  warning,
  success,
  neutral,
}

class FlashcardStudyActionSectionItem {
  const FlashcardStudyActionSectionItem({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.tone = FlashcardStudyActionSectionTone.neutral,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final FlashcardStudyActionSectionTone tone;
}

class FlashcardStudyActionSection extends StatelessWidget {
  const FlashcardStudyActionSection({required this.actions, super.key});

  final List<FlashcardStudyActionSectionItem> actions;

  @override
  Widget build(BuildContext context) {
    if (actions.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      children: actions
          .map((FlashcardStudyActionSectionItem action) {
            final Color containerColor = _resolveFlashcardActionContainerColor(
              context: context,
              tone: action.tone,
            );
            final Color iconColor = _resolveFlashcardActionIconColor(
              context: context,
              tone: action.tone,
            );
            return Padding(
              padding: const EdgeInsets.only(
                bottom: FlashcardStudyActionSectionConst.itemSpacing,
              ),
              child: LumosCard(
                variant: LumosCardVariant.elevated,
                onTap: action.onPressed,
                child: Row(
                  children: <Widget>[
                    Container(
                      width: FlashcardStudyActionSectionConst.iconContainerSize,
                      height:
                          FlashcardStudyActionSectionConst.iconContainerSize,
                      decoration: BoxDecoration(
                        color: containerColor,
                        borderRadius: BorderRadii.medium,
                      ),
                      child: IconTheme(
                        data: IconThemeData(
                          color: iconColor,
                          size: FlashcardStudyActionSectionConst.iconSize,
                        ),
                        child: LumosIcon(action.icon),
                      ),
                    ),
                    const SizedBox(
                      width: FlashcardStudyActionSectionConst.labelLeftSpacing,
                    ),
                    Expanded(
                      child: LumosInlineText(
                        action.label,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
              ),
            );
          })
          .toList(growable: false),
    );
  }
}

Color _resolveFlashcardActionContainerColor({
  required BuildContext context,
  required FlashcardStudyActionSectionTone tone,
}) {
  final ColorScheme colorScheme = Theme.of(context).colorScheme;
  if (tone == FlashcardStudyActionSectionTone.primary) {
    return colorScheme.primaryContainer;
  }
  if (tone == FlashcardStudyActionSectionTone.info) {
    return context.appColors.infoContainer;
  }
  if (tone == FlashcardStudyActionSectionTone.warning) {
    return context.appColors.warningContainer;
  }
  if (tone == FlashcardStudyActionSectionTone.success) {
    return context.appColors.successContainer;
  }
  return colorScheme.secondaryContainer;
}

Color _resolveFlashcardActionIconColor({
  required BuildContext context,
  required FlashcardStudyActionSectionTone tone,
}) {
  final ColorScheme colorScheme = Theme.of(context).colorScheme;
  if (tone == FlashcardStudyActionSectionTone.primary) {
    return colorScheme.onPrimaryContainer;
  }
  if (tone == FlashcardStudyActionSectionTone.info) {
    return context.appColors.onInfoContainer;
  }
  if (tone == FlashcardStudyActionSectionTone.warning) {
    return context.appColors.onWarningContainer;
  }
  if (tone == FlashcardStudyActionSectionTone.success) {
    return context.appColors.onSuccessContainer;
  }
  return colorScheme.onSecondaryContainer;
}
