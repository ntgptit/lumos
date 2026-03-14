import 'package:flutter/material.dart';

import '../../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../../l10n/app_localizations.dart';
import '../../../../../../../shared/widgets/lumos_widgets.dart';
import '../../../../../constants/home_contract.dart';
import 'home_stat_grid.dart';

class HomeSplitSection extends StatelessWidget {
  const HomeSplitSection({required this.deviceType, super.key});

  final DeviceType deviceType;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Widget focusCard = Semantics(
      label: HomeScreenSemantics.sectionCard,
      container: true,
      excludeSemantics: true,
      child: LumosSectionCard(
        variant: LumosCardVariant.outlined,
        margin: EdgeInsets.zero,
        headerPadding: HomeStatGridConst.sectionHeaderPadding,
        elevation: HomeStatGridConst.cardElevation,
        title: l10n.homeFocusTitle,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                IconTheme(
                  data: IconThemeData(color: colorScheme.primary),
                  child: const LumosIcon(
                    Icons.headphones_rounded,
                    size: IconSizes.iconSmall,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      LumosText(
                        l10n.homeTaskShadowListeningTitle,
                        style: LumosTextStyle.bodySmall,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      const LumosProgressBar(value: 0.66),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                IconTheme(
                  data: IconThemeData(color: colorScheme.tertiary),
                  child: const LumosIcon(
                    Icons.grid_view_rounded,
                    size: IconSizes.iconSmall,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      LumosText(
                        l10n.homeTaskVocabularyTitle,
                        style: LumosTextStyle.bodySmall,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      const LumosProgressBar(value: 0.45),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                IconTheme(
                  data: IconThemeData(color: colorScheme.secondary),
                  child: const LumosIcon(
                    Icons.graphic_eq_rounded,
                    size: IconSizes.iconSmall,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      LumosText(
                        l10n.homeTaskPronunciationTitle,
                        style: LumosTextStyle.bodySmall,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      const LumosProgressBar(value: 0.8),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    final List<({String title, String subtitle, String trailing, Color color})>
    activityItems =
        <({String title, String subtitle, String trailing, Color color})>[
          (
            title: l10n.homeActivitySpanishTitle,
            subtitle: l10n.homeActivitySpanishSubtitle,
            trailing: l10n.homeActivitySpanishTrailing,
            color: colorScheme.primary,
          ),
          (
            title: l10n.homeActivityGrammarTitle,
            subtitle: l10n.homeActivityGrammarSubtitle,
            trailing: l10n.homeActivityGrammarTrailing,
            color: colorScheme.tertiary,
          ),
          (
            title: l10n.homeActivitySpeakingTitle,
            subtitle: l10n.homeActivitySpeakingSubtitle,
            trailing: l10n.homeActivitySpeakingTrailing,
            color: colorScheme.secondary,
          ),
        ];
    final Widget recentActivityCard = LumosSectionCard(
      variant: LumosCardVariant.outlined,
      margin: EdgeInsets.zero,
      headerPadding: HomeStatGridConst.sectionHeaderPadding,
      elevation: HomeStatGridConst.cardElevation,
      title: l10n.homeActivityTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: activityItems
            .expand((
              ({String title, String subtitle, String trailing, Color color})
              item,
            ) sync* {
              final int itemIndex = activityItems.indexOf(item);
              yield Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  borderRadius: BorderRadii.medium,
                  color: colorScheme.surfaceContainerLow,
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: HomeStatGridConst.activityAccentSize,
                      height: HomeStatGridConst.activityAccentSize,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadii.pill,
                        color: item.color.withValues(
                          alpha: AppOpacity.stateHover,
                        ),
                      ),
                      child: IconTheme(
                        data: IconThemeData(color: item.color),
                        child: const LumosIcon(Icons.arrow_outward_rounded),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          LumosText(
                            item.title,
                            style: LumosTextStyle.labelLarge,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          LumosText(
                            item.subtitle,
                            style: LumosTextStyle.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    LumosText(
                      item.trailing,
                      style: LumosTextStyle.labelSmall,
                      tone: LumosTextTone.secondary,
                    ),
                  ],
                ),
              );
              if (itemIndex < activityItems.length - 1) {
                yield const SizedBox(height: AppSpacing.sm);
              }
            })
            .toList(growable: false),
      ),
    );
    if (deviceType == DeviceType.mobile) {
      return Column(
        key: HomeScreenKeys.mobileLayout,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          focusCard,
          SizedBox(height: AppSpacing.md),
          recentActivityCard,
        ],
      );
    }
    if (deviceType == DeviceType.tablet) {
      return Row(
        key: HomeScreenKeys.tabletLayout,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(child: focusCard),
          SizedBox(width: AppSpacing.xxl),
          Expanded(child: recentActivityCard),
        ],
      );
    }
    return Row(
      key: HomeScreenKeys.desktopLayout,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(flex: 5, child: focusCard),
        SizedBox(width: AppSpacing.xxl),
        Expanded(flex: 4, child: recentActivityCard),
      ],
    );
  }
}
