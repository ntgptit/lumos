import 'package:flutter/material.dart';

import '../../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../../l10n/app_localizations.dart';
import '../../../../../../../shared/widgets/lumos_widgets.dart';
import '../../../../../constants/home_contract.dart';
import 'home_stat_grid.dart';
import 'home_split_focus_item.dart';

class HomeSplitSection extends StatelessWidget {
  const HomeSplitSection({required this.deviceType, super.key});

  final DeviceType deviceType;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final double inlineGap = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: AppSpacing.sm,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double itemSpacing = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: AppSpacing.md,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double activityAccentSize = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: HomeStatGridConst.activityAccentSize,
      minScale: ResponsiveDimensions.compactLargeInsetScale,
    );
    final double activityItemPadding = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: AppSpacing.md,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final EdgeInsets sectionHeaderPadding = ResponsiveDimensions.compactInsets(
      context: context,
      baseInsets: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.md,
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
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compactDesktop =
            deviceType == DeviceType.desktop && constraints.maxWidth < 1080;
        final double columnGap = ResponsiveDimensions.compactValue(
          context: context,
          baseValue: compactDesktop ? AppSpacing.xl : AppSpacing.xxl,
          minScale: ResponsiveDimensions.compactInsetScale,
        );
        final Widget focusCard = Semantics(
          label: HomeScreenSemantics.sectionCard,
          container: true,
          excludeSemantics: true,
          child: LumosSectionCard(
            variant: LumosCardVariant.outlined,
            margin: EdgeInsets.zero,
            headerPadding: sectionHeaderPadding,
            elevation: HomeStatGridConst.cardElevation,
            title: l10n.homeFocusTitle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                HomeSplitFocusItem(
                  icon: Icons.headphones_rounded,
                  iconColor: colorScheme.primary,
                  label: l10n.homeTaskShadowListeningTitle,
                  progressValue: 0.66,
                  itemSpacing: itemSpacing,
                  inlineGap: inlineGap,
                ),
                SizedBox(height: itemSpacing),
                HomeSplitFocusItem(
                  icon: Icons.grid_view_rounded,
                  iconColor: colorScheme.tertiary,
                  label: l10n.homeTaskVocabularyTitle,
                  progressValue: 0.45,
                  itemSpacing: itemSpacing,
                  inlineGap: inlineGap,
                ),
                SizedBox(height: itemSpacing),
                HomeSplitFocusItem(
                  icon: Icons.graphic_eq_rounded,
                  iconColor: colorScheme.secondary,
                  label: l10n.homeTaskPronunciationTitle,
                  progressValue: 0.8,
                  itemSpacing: itemSpacing,
                  inlineGap: inlineGap,
                ),
              ],
            ),
          ),
        );
        final Widget recentActivityCard = LumosSectionCard(
          variant: LumosCardVariant.outlined,
          margin: EdgeInsets.zero,
          headerPadding: sectionHeaderPadding,
          elevation: HomeStatGridConst.cardElevation,
          title: l10n.homeActivityTitle,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: activityItems
                .asMap()
                .entries
                .expand((
                  MapEntry<
                    int,
                    ({
                      String title,
                      String subtitle,
                      String trailing,
                      Color color,
                    })
                  >
                  entry,
                ) sync* {
                  final ({
                    String title,
                    String subtitle,
                    String trailing,
                    Color color,
                  })
                  item = entry.value;
                  yield Container(
                    padding: EdgeInsets.all(activityItemPadding),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadii.medium,
                      color: colorScheme.surfaceContainerLow,
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: activityAccentSize,
                          height: activityAccentSize,
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
                        SizedBox(width: inlineGap),
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
                        SizedBox(width: inlineGap),
                        LumosText(
                          item.trailing,
                          style: LumosTextStyle.labelSmall,
                          tone: LumosTextTone.secondary,
                        ),
                      ],
                    ),
                  );
                  if (entry.key < activityItems.length - 1) {
                    yield SizedBox(height: inlineGap);
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
              SizedBox(height: itemSpacing),
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
              SizedBox(width: columnGap),
              Expanded(child: recentActivityCard),
            ],
          );
        }
        return Row(
          key: HomeScreenKeys.desktopLayout,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(flex: 5, child: focusCard),
            SizedBox(width: columnGap),
            Expanded(flex: 4, child: recentActivityCard),
          ],
        );
      },
    );
  }
}
