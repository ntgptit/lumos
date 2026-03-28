import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../../../domain/entities/study/study_models.dart';
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

class StudySessionChoiceList extends StatelessWidget {
  const StudySessionChoiceList({
    required this.choices,
    required this.useGrid,
    required this.onChoicePressed,
    super.key,
  });

  final List<StudyChoice> choices;
  final bool useGrid;
  final ValueChanged<String> onChoicePressed;

  @override
  Widget build(BuildContext context) {
    final double itemSpacing = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.sm,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    if (useGrid) {
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final bool singleColumn = constraints.maxWidth < 360;
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: singleColumn ? 1 : 2,
              crossAxisSpacing: itemSpacing,
              mainAxisSpacing: itemSpacing,
              childAspectRatio: singleColumn ? 3.2 : 1.2,
            ),
            itemCount: choices.length,
            itemBuilder: (BuildContext context, int index) {
              final StudyChoice choice = choices[index];
              return LumosOutlineButton(
                onPressed: () => onChoicePressed(choice.label),
                label: choice.label,
              );
            },
          );
        },
      );
    }
    return Column(
      children: choices
          .map(
            (StudyChoice choice) => Padding(
              padding: EdgeInsets.only(bottom: itemSpacing),
              child: LumosOutlineButton(
                onPressed: () => onChoicePressed(choice.label),
                label: choice.label,
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}

