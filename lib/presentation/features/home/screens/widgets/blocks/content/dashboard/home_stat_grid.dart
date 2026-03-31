import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import 'package:lumos/core/theme/tokens/visual/elevation_tokens.dart';
import '../../../../../../../../l10n/app_localizations.dart';

abstract final class HomeStatGridConst {
  HomeStatGridConst._();

  static const double statIconContainerSize =
      64 +
      12;
  static const double activityAccentSize =
      64;
  static const double cardElevation = AppElevationTokens.level1;
  static const EdgeInsetsGeometry sectionHeaderPadding = EdgeInsets.fromLTRB(
    24,
    24,
    24,
    16,
  );
}

class HomeStatGrid extends StatelessWidget {
  const HomeStatGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final double cardPadding = context.compactValue(
      baseValue: context.spacing.lg,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double itemGap = context.compactValue(
      baseValue: context.spacing.md,
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
                              borderRadius: context.shapes.card,
                              color: context.theme.colorScheme.secondaryContainer,
                            ),
                            child: IconTheme(
                              data: IconThemeData(
                                color: context.theme.colorScheme.onSecondaryContainer,
                              ),
                              child: LumosIcon(stat.icon),
                            ),
                          ),
                          SizedBox(
                            width: context.spacing.md,
                          ),
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
                    padding: EdgeInsets.symmetric(
                      horizontal: context.spacing.xs,
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
                              borderRadius: context.shapes.card,
                              color: context.theme.colorScheme.secondaryContainer,
                            ),
                            child: IconTheme(
                              data: IconThemeData(
                                color: context.theme.colorScheme.onSecondaryContainer,
                              ),
                              child: LumosIcon(stat.icon),
                            ),
                          ),
                          SizedBox(
                            width: context.spacing.md,
                          ),
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
