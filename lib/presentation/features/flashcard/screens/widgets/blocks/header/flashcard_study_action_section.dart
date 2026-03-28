import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/presentation/shared/composites/appbars/lumos_app_bar.dart';
import 'package:lumos/presentation/shared/composites/dialogs/lumos_action_sheet.dart';
import 'package:lumos/presentation/shared/composites/dialogs/lumos_dialog.dart';
import 'package:lumos/presentation/shared/composites/dialogs/lumos_prompt_dialog.dart';
import 'package:lumos/presentation/shared/composites/forms/lumos_search_bar.dart';
import 'package:lumos/presentation/shared/composites/forms/lumos_sort_bar.dart';
import 'package:lumos/presentation/shared/composites/lists/lumos_action_list_item.dart';
import 'package:lumos/presentation/shared/composites/lists/lumos_action_list_item_card.dart';
import 'package:lumos/presentation/shared/composites/states/lumos_empty_state.dart';
import 'package:lumos/presentation/shared/composites/states/lumos_error_state.dart';
import 'package:lumos/presentation/shared/composites/text/lumos_inline_text.dart';
import 'package:lumos/presentation/shared/layouts/lumos_screen_transition.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_floating_action_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_icon_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_outline_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_primary_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_secondary_button.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_card.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_icon.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_progress_bar.dart';
import 'package:lumos/presentation/shared/primitives/feedback/lumos_loading_indicator.dart';
import 'package:lumos/presentation/shared/primitives/feedback/lumos_snackbar.dart';
import 'package:lumos/presentation/shared/primitives/inputs/lumos_dropdown.dart';
import 'package:lumos/presentation/shared/primitives/inputs/lumos_text_field.dart';
import 'package:lumos/presentation/shared/primitives/layout/lumos_spacing.dart';
import 'package:lumos/presentation/shared/primitives/text/lumos_text.dart';

abstract final class FlashcardStudyActionSectionConst {
  FlashcardStudyActionSectionConst._();

  static const double itemSpacing = LumosSpacing.md;
  static const double iconContainerSize = WidgetSizes.avatarMedium;
  static const double iconSize = IconSizes.iconSmall;
  static const double labelLeftSpacing = LumosSpacing.md;
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
    final double itemSpacing = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardStudyActionSectionConst.itemSpacing,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double iconContainerSize = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardStudyActionSectionConst.iconContainerSize,
      minScale: ResponsiveDimensions.compactLargeInsetScale,
    );
    final double iconSize = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardStudyActionSectionConst.iconSize,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double labelLeftSpacing = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardStudyActionSectionConst.labelLeftSpacing,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compactWidth = constraints.maxWidth < 380;
        return Column(
          children: actions
              .map((FlashcardStudyActionSectionItem action) {
                final Color containerColor =
                    _resolveFlashcardActionContainerColor(
                      context: context,
                      tone: action.tone,
                    );
                final Color iconColor = _resolveFlashcardActionIconColor(
                  context: context,
                  tone: action.tone,
                );
                return Padding(
                  padding: EdgeInsets.only(bottom: itemSpacing),
                  child: LumosCard(
                    variant: LumosCardVariant.elevated,
                    onTap: action.onPressed,
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: iconContainerSize,
                          height: iconContainerSize,
                          decoration: BoxDecoration(
                            color: containerColor,
                            borderRadius: BorderRadii.medium,
                          ),
                          child: IconTheme(
                            data: IconThemeData(
                              color: iconColor,
                              size: iconSize,
                            ),
                            child: LumosIcon(action.icon),
                          ),
                        ),
                        SizedBox(width: labelLeftSpacing),
                        Expanded(
                          child: LumosInlineText(
                            action.label,
                            style: compactWidth
                                ? Theme.of(context).textTheme.titleSmall
                                : Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              })
              .toList(growable: false),
        );
      },
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

