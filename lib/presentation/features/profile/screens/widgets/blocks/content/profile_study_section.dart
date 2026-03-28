import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../../../domain/entities/study/study_models.dart';
import '../../../../../../../l10n/app_localizations.dart';
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

abstract final class ProfileStudySectionConst {
  ProfileStudySectionConst._();

  static final List<int> firstLearningCardLimits = List<int>.generate(
    StudyPreference.maxFirstLearningCardLimit,
    (int index) => StudyPreference.minFirstLearningCardLimit + index,
    growable: false,
  );
}

class ProfileStudySection extends StatelessWidget {
  const ProfileStudySection({
    required this.preference,
    required this.onLimitChanged,
    super.key,
  });

  final StudyPreference preference;
  final ValueChanged<int> onLimitChanged;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final double cardPadding = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.lg,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double sectionGap = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.lg,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    return LumosCard(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            LumosText(
              l10n.profileStudySectionTitle,
              style: LumosTextStyle.titleLarge,
            ),
            const SizedBox(height: LumosSpacing.sm),
            LumosText(
              l10n.profileStudySectionSubtitle,
              style: LumosTextStyle.bodyMedium,
            ),
            SizedBox(height: sectionGap),
            LumosDropdown<int>(
              value: preference.firstLearningCardLimit,
              label: l10n.profileStudyFirstLearningLimitLabel,
              items: ProfileStudySectionConst.firstLearningCardLimits
                  .map(
                    (int limit) => DropdownMenuItem<int>(
                      value: limit,
                      child: LumosText(
                        l10n.profileStudyFirstLearningLimitValue(limit),
                        style: LumosTextStyle.bodyMedium,
                      ),
                    ),
                  )
                  .toList(growable: false),
              onChanged: (int? limit) {
                if (limit == null) {
                  return;
                }
                onLimitChanged(limit);
              },
            ),
            const SizedBox(height: LumosSpacing.sm),
            LumosText(
              l10n.profileStudyReviewHint,
              style: LumosTextStyle.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

