import 'package:flutter/material.dart';

import '../../../../../../core/themes/constants/dimensions.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/lumos_widgets.dart';
import '../../../constants/home_contract.dart';

abstract final class HomeSectionsConst {
  HomeSectionsConst._();

  static const double statIconContainerSize =
      Insets.spacing32 + Insets.spacing8;
  static const double activityAccentBarHeight = Insets.spacing32;
  static const double activityAccentBarWidth = Insets.spacing8;
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
                    padding: const EdgeInsets.only(bottom: Insets.spacing12),
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
                      horizontal: Insets.spacing4,
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
    return LumosCard(
      padding: const EdgeInsets.all(Insets.spacing16),
      margin: EdgeInsets.zero,
      child: Row(
        children: <Widget>[
          Container(
            width: HomeSectionsConst.statIconContainerSize,
            height: HomeSectionsConst.statIconContainerSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadii.medium,
              border: Border.all(color: colorScheme.outlineVariant),
              color: colorScheme.surfaceContainerHighest,
            ),
            child: IconTheme(
              data: IconThemeData(color: colorScheme.primary),
              child: LumosIcon(stat.icon),
            ),
          ),
          const SizedBox(width: Insets.spacing12),
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
          SizedBox(height: Insets.gapBetweenItems),
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
          SizedBox(width: Insets.gapBetweenSections),
          Expanded(child: HomeRecentActivityCard()),
        ],
      );
    }
    return Row(
      key: HomeScreenKeys.desktopLayout,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const <Widget>[
        Expanded(flex: 5, child: HomeFocusCard()),
        SizedBox(width: Insets.gapBetweenSections),
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
      child: LumosCard(
        margin: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            LumosText(l10n.homeFocusTitle, style: LumosTextStyle.titleMedium),
            const SizedBox(height: Insets.spacing12),
            HomeTaskLine(
              title: l10n.homeTaskShadowListeningTitle,
              progress: 0.66,
              icon: Icons.headphones_rounded,
              color: colorScheme.primary,
            ),
            const SizedBox(height: Insets.spacing12),
            HomeTaskLine(
              title: l10n.homeTaskVocabularyTitle,
              progress: 0.45,
              icon: Icons.grid_view_rounded,
              color: colorScheme.tertiary,
            ),
            const SizedBox(height: Insets.spacing12),
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
        const SizedBox(width: Insets.spacing8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              LumosText(title, style: LumosTextStyle.bodySmall),
              const SizedBox(height: Insets.spacing4),
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
    return LumosCard(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          LumosText(l10n.homeActivityTitle, style: LumosTextStyle.titleMedium),
          const SizedBox(height: Insets.spacing12),
          HomeActivityItem(
            title: l10n.homeActivitySpanishTitle,
            subtitle: l10n.homeActivitySpanishSubtitle,
            trailing: l10n.homeActivitySpanishTrailing,
            color: colorScheme.primary,
          ),
          const SizedBox(height: Insets.spacing8),
          HomeActivityItem(
            title: l10n.homeActivityGrammarTitle,
            subtitle: l10n.homeActivityGrammarSubtitle,
            trailing: l10n.homeActivityGrammarTrailing,
            color: colorScheme.tertiary,
          ),
          const SizedBox(height: Insets.spacing8),
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
      padding: const EdgeInsets.all(Insets.spacing12),
      decoration: BoxDecoration(
        borderRadius: BorderRadii.medium,
        border: Border.all(color: colorScheme.outlineVariant),
        color: colorScheme.surfaceContainerHigh,
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: HomeSectionsConst.activityAccentBarWidth,
            height: HomeSectionsConst.activityAccentBarHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadii.medium,
              color: color,
            ),
          ),
          const SizedBox(width: Insets.spacing8),
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
          const SizedBox(width: Insets.spacing8),
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
