import 'package:flutter/material.dart';

import '../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../core/themes/semantic/app_elevation_tokens.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/lumos_widgets.dart';
import '../../../constants/home_contract.dart';

abstract final class HomeSectionsConst {
  HomeSectionsConst._();

  static const double statIconContainerSize = AppSpacing.xxxl + AppSpacing.sm;
  static const double activityAccentSize = AppSpacing.xxxl;
  static const double cardElevation = AppElevationTokens.level1;
  static const EdgeInsetsGeometry sectionHeaderPadding = EdgeInsets.fromLTRB(
    AppSpacing.lg,
    AppSpacing.lg,
    AppSpacing.lg,
    AppSpacing.md,
  );
}

class HomeStatItem {
  const HomeStatItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;
}

class HomeStatGrid extends StatelessWidget {
  const HomeStatGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final List<HomeStatItem> stats = <HomeStatItem>[
      HomeStatItem(
        label: l10n.homeStreakLabel,
        value: l10n.homeStatStreakValue,
        icon: Icons.local_fire_department_rounded,
      ),
      HomeStatItem(
        label: l10n.homeAccuracyLabel,
        value: l10n.homeStatAccuracyValue,
        icon: Icons.track_changes_rounded,
      ),
      HomeStatItem(
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
                  (HomeStatItem stat) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: HomeStatTile(stat: stat),
                  ),
                )
                .toList(),
          );
        }
        return Row(
          children: stats
              .map(
                (HomeStatItem stat) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs,
                    ),
                    child: HomeStatTile(stat: stat),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class HomeStatTile extends StatelessWidget {
  const HomeStatTile({required this.stat, super.key});

  final HomeStatItem stat;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return LumosSectionCard(
      variant: LumosCardVariant.outlined,
      padding: const EdgeInsets.all(AppSpacing.lg),
      margin: EdgeInsets.zero,
      elevation: HomeSectionsConst.cardElevation,
      child: Row(
        children: <Widget>[
          Container(
            width: HomeSectionsConst.statIconContainerSize,
            height: HomeSectionsConst.statIconContainerSize,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadii.medium,
              color: colorScheme.secondaryContainer,
            ),
            child: IconTheme(
              data: IconThemeData(color: colorScheme.onSecondaryContainer),
              child: LumosIcon(stat.icon),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
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
    );
  }
}

class HomeSplitSection extends StatelessWidget {
  const HomeSplitSection({required this.deviceType, super.key});

  final DeviceType deviceType;

  @override
  Widget build(BuildContext context) {
    if (deviceType == DeviceType.mobile) {
      return Column(
        key: HomeScreenKeys.mobileLayout,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const <Widget>[
          HomeFocusCard(),
          SizedBox(height: AppSpacing.md),
          HomeRecentActivityCard(),
        ],
      );
    }
    if (deviceType == DeviceType.tablet) {
      return Row(
        key: HomeScreenKeys.tabletLayout,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Expanded(child: HomeFocusCard()),
          SizedBox(width: AppSpacing.xxl),
          Expanded(child: HomeRecentActivityCard()),
        ],
      );
    }
    return Row(
      key: HomeScreenKeys.desktopLayout,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const <Widget>[
        Expanded(flex: 5, child: HomeFocusCard()),
        SizedBox(width: AppSpacing.xxl),
        Expanded(flex: 4, child: HomeRecentActivityCard()),
      ],
    );
  }
}

class HomeFocusCard extends StatelessWidget {
  const HomeFocusCard({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Semantics(
      label: HomeScreenSemantics.sectionCard,
      container: true,
      excludeSemantics: true,
      child: LumosSectionCard(
        variant: LumosCardVariant.outlined,
        margin: EdgeInsets.zero,
        headerPadding: HomeSectionsConst.sectionHeaderPadding,
        elevation: HomeSectionsConst.cardElevation,
        title: l10n.homeFocusTitle,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            HomeTaskLine(
              title: l10n.homeTaskShadowListeningTitle,
              progress: 0.66,
              icon: Icons.headphones_rounded,
              color: colorScheme.primary,
            ),
            const SizedBox(height: AppSpacing.md),
            HomeTaskLine(
              title: l10n.homeTaskVocabularyTitle,
              progress: 0.45,
              icon: Icons.grid_view_rounded,
              color: colorScheme.tertiary,
            ),
            const SizedBox(height: AppSpacing.md),
            HomeTaskLine(
              title: l10n.homeTaskPronunciationTitle,
              progress: 0.8,
              icon: Icons.graphic_eq_rounded,
              color: colorScheme.secondary,
            ),
          ],
        ),
      ),
    );
  }
}

class HomeTaskLine extends StatelessWidget {
  const HomeTaskLine({
    required this.title,
    required this.progress,
    required this.icon,
    required this.color,
    super.key,
  });

  final String title;
  final double progress;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        IconTheme(
          data: IconThemeData(color: color),
          child: LumosIcon(icon, size: IconSizes.iconSmall),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              LumosText(title, style: LumosTextStyle.bodySmall),
              const SizedBox(height: AppSpacing.xs),
              LumosProgressBar(value: progress),
            ],
          ),
        ),
      ],
    );
  }
}

class HomeRecentActivityCard extends StatelessWidget {
  const HomeRecentActivityCard({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return LumosSectionCard(
      variant: LumosCardVariant.outlined,
      margin: EdgeInsets.zero,
      headerPadding: HomeSectionsConst.sectionHeaderPadding,
      elevation: HomeSectionsConst.cardElevation,
      title: l10n.homeActivityTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          HomeActivityItem(
            title: l10n.homeActivitySpanishTitle,
            subtitle: l10n.homeActivitySpanishSubtitle,
            trailing: l10n.homeActivitySpanishTrailing,
            color: colorScheme.primary,
          ),
          const SizedBox(height: AppSpacing.sm),
          HomeActivityItem(
            title: l10n.homeActivityGrammarTitle,
            subtitle: l10n.homeActivityGrammarSubtitle,
            trailing: l10n.homeActivityGrammarTrailing,
            color: colorScheme.tertiary,
          ),
          const SizedBox(height: AppSpacing.sm),
          HomeActivityItem(
            title: l10n.homeActivitySpeakingTitle,
            subtitle: l10n.homeActivitySpeakingSubtitle,
            trailing: l10n.homeActivitySpeakingTrailing,
            color: colorScheme.secondary,
          ),
        ],
      ),
    );
  }
}

class HomeActivityItem extends StatelessWidget {
  const HomeActivityItem({
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.color,
    super.key,
  });

  final String title;
  final String subtitle;
  final String trailing;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadii.medium,
        color: colorScheme.surfaceContainerLow,
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: HomeSectionsConst.activityAccentSize,
            height: HomeSectionsConst.activityAccentSize,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.pill),
              color: color.withValues(alpha: AppOpacity.stateHover),
            ),
            child: IconTheme(
              data: IconThemeData(color: color),
              child: const LumosIcon(Icons.arrow_outward_rounded),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                LumosText(
                  title,
                  style: LumosTextStyle.labelLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                LumosText(
                  subtitle,
                  style: LumosTextStyle.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          LumosText(
            trailing,
            style: LumosTextStyle.labelSmall,
            tone: LumosTextTone.secondary,
          ),
        ],
      ),
    );
  }
}
