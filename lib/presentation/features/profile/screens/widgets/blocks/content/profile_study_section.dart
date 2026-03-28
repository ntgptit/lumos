import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../../../domain/entities/study/study_models.dart';
import '../../../../../../../l10n/app_localizations.dart';

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

