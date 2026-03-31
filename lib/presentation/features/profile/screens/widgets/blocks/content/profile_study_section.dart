import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../../../domain/entities/study/study_models.dart';
import '../../../../../../../l10n/app_localizations.dart';
import 'profile_section_card.dart';

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
    final double sectionGap = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.md,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    return ProfileSectionCard(
      title: l10n.profileStudySectionTitle,
      subtitle: l10n.profileStudySectionSubtitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
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
          SizedBox(height: sectionGap),
          LumosText(
            l10n.profileStudyReviewHint,
            style: LumosTextStyle.bodySmall,
          ),
        ],
      ),
    );
  }
}
