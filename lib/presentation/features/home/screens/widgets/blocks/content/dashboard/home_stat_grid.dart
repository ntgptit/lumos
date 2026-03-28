import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import 'package:lumos/core/theme/tokens/visual/elevation_tokens.dart';
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

abstract final class HomeStatGridConst {
  HomeStatGridConst._();

  static const double statIconContainerSize = LumosSpacing.xxxl + LumosSpacing.sm;
  static const double activityAccentSize = LumosSpacing.xxxl;
  static const double cardElevation = AppElevationTokens.level1;
  static const EdgeInsetsGeometry sectionHeaderPadding = EdgeInsets.fromLTRB(
    LumosSpacing.lg,
    LumosSpacing.lg,
    LumosSpacing.lg,
    LumosSpacing.md,
  );
}

class HomeStatGrid extends StatelessWidget {
  const HomeStatGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final double cardPadding = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.lg,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double itemGap = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.md,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final List<_HomeStatItem> stats = <_HomeStatItem>[
      _HomeStatItem(
        label: l10n.homeStreakLabel,
        value: l10n.homeStatStreakValue,
        icon: Icons.local_fire_department_rounded,
      ),
      _HomeStatItem(
        label: l10n.homeAccuracyLabel,
        value: l10n.homeStatAccuracyValue,
        icon: Icons.track_changes_rounded,
      ),
      _HomeStatItem(
        label: l10n.homeXpLabel,
        value: l10n.homeStatXpValue,
        icon: Icons.bolt_rounded,
      ),
    ];
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool singleColumn =
            constraints.maxWidth < Breakpoints.kMobileMaxWidth;
        if (singleColumn) {
          return Column(
            children: stats
                .map(
                  (_HomeStatItem stat) => Padding(
                    padding: EdgeInsets.only(bottom: itemGap),
                    child: LumosSectionCard(
                      variant: LumosCardVariant.outlined,
                      padding: EdgeInsets.all(cardPadding),
                      margin: EdgeInsets.zero,
                      elevation: HomeStatGridConst.cardElevation,
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: HomeStatGridConst.statIconContainerSize,
                            height: HomeStatGridConst.statIconContainerSize,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadii.medium,
                              color: Theme.of(
                                context,
                              ).colorScheme.secondaryContainer,
                            ),
                            child: IconTheme(
                              data: IconThemeData(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSecondaryContainer,
                              ),
                              child: LumosIcon(stat.icon),
                            ),
                          ),
                          const SizedBox(width: LumosSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                LumosText(
                                  stat.value,
                                  style: LumosTextStyle.titleLarge,
                                  tone: LumosTextTone.primary,
                                ),
                                LumosText(
                                  stat.label,
                                  style: LumosTextStyle.labelMedium,
                                  tone: LumosTextTone.secondary,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          );
        }
        return Row(
          children: stats
              .map(
                (_HomeStatItem stat) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: LumosSpacing.xs,
                    ),
                    child: LumosSectionCard(
                      variant: LumosCardVariant.outlined,
                      padding: EdgeInsets.all(cardPadding),
                      margin: EdgeInsets.zero,
                      elevation: HomeStatGridConst.cardElevation,
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: HomeStatGridConst.statIconContainerSize,
                            height: HomeStatGridConst.statIconContainerSize,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadii.medium,
                              color: Theme.of(
                                context,
                              ).colorScheme.secondaryContainer,
                            ),
                            child: IconTheme(
                              data: IconThemeData(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSecondaryContainer,
                              ),
                              child: LumosIcon(stat.icon),
                            ),
                          ),
                          const SizedBox(width: LumosSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                LumosText(
                                  stat.value,
                                  style: LumosTextStyle.titleLarge,
                                  tone: LumosTextTone.primary,
                                ),
                                LumosText(
                                  stat.label,
                                  style: LumosTextStyle.labelMedium,
                                  tone: LumosTextTone.secondary,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _HomeStatItem {
  const _HomeStatItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;
}

