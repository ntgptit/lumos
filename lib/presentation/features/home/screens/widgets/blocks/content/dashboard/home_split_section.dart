import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../../../../l10n/app_localizations.dart';
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
      baseValue: LumosSpacing.sm,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double itemSpacing = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.md,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double activityAccentSize = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: HomeStatGridConst.activityAccentSize,
      minScale: ResponsiveDimensions.compactLargeInsetScale,
    );
    final double activityItemPadding = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.md,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final EdgeInsets sectionHeaderPadding = ResponsiveDimensions.compactInsets(
      context: context,
      baseInsets: const EdgeInsets.fromLTRB(
        LumosSpacing.lg,
        LumosSpacing.lg,
        LumosSpacing.lg,
        LumosSpacing.md,
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
          baseValue: compactDesktop ? LumosSpacing.xl : LumosSpacing.xxl,
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

