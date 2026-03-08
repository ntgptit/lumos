import 'package:flutter/material.dart';

import '../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../core/themes/extensions/theme_extensions.dart';
import '../../../../../shared/widgets/lumos_widgets.dart';

abstract final class FlashcardStudyActionSectionConst {
  FlashcardStudyActionSectionConst._();

  static const double itemSpacing = AppSpacing.md;
  static const double iconContainerSize = WidgetSizes.avatarMedium;
  static const double iconSize = IconSizes.iconSmall;
  static const double labelLeftSpacing = AppSpacing.md;
}

enum FlashcardStudyActionTone { primary, info, warning, success, neutral }

class FlashcardStudyAction {
  const FlashcardStudyAction({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.tone = FlashcardStudyActionTone.neutral,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final FlashcardStudyActionTone tone;
}

class FlashcardStudyActionSection extends StatelessWidget {
  const FlashcardStudyActionSection({required this.actions, super.key});

  final List<FlashcardStudyAction> actions;

  @override
  Widget build(BuildContext context) {
    if (actions.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      children: actions.map(_buildActionCard).toList(growable: false),
    );
  }

  Widget _buildActionCard(FlashcardStudyAction action) {
    return Builder(
      builder: (BuildContext context) {
        final Color containerColor = _resolveIconContainerColor(
          context: context,
          tone: action.tone,
        );
        final Color iconColor = _resolveIconColor(
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
                  height: FlashcardStudyActionSectionConst.iconContainerSize,
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
      },
    );
  }

  Color _resolveIconContainerColor({
    required BuildContext context,
    required FlashcardStudyActionTone tone,
  }) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    if (tone == FlashcardStudyActionTone.primary) {
      return colorScheme.primaryContainer;
    }
    if (tone == FlashcardStudyActionTone.info) {
      return context.appColors.infoContainer;
    }
    if (tone == FlashcardStudyActionTone.warning) {
      return context.appColors.warningContainer;
    }
    if (tone == FlashcardStudyActionTone.success) {
      return context.appColors.successContainer;
    }
    return colorScheme.secondaryContainer;
  }

  Color _resolveIconColor({
    required BuildContext context,
    required FlashcardStudyActionTone tone,
  }) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    if (tone == FlashcardStudyActionTone.primary) {
      return colorScheme.onPrimaryContainer;
    }
    if (tone == FlashcardStudyActionTone.info) {
      return context.appColors.onInfoContainer;
    }
    if (tone == FlashcardStudyActionTone.warning) {
      return context.appColors.onWarningContainer;
    }
    if (tone == FlashcardStudyActionTone.success) {
      return context.appColors.onSuccessContainer;
    }
    return colorScheme.onSecondaryContainer;
  }
}
