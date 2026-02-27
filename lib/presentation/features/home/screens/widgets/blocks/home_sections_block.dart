import 'package:flutter/material.dart';

import '../../../../../../core/constants/dimensions.dart';
import '../../../../../shared/widgets/lumos_widgets.dart';
import '../../home_contract.dart';

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
    final List<HomeStatItem> stats = <HomeStatItem>[
      const HomeStatItem(
        label: HomeScreenText.streakLabel,
        value: '12 days',
        icon: Icons.local_fire_department_rounded,
      ),
      const HomeStatItem(
        label: HomeScreenText.accuracyLabel,
        value: '94%',
        icon: Icons.track_changes_rounded,
      ),
      const HomeStatItem(
        label: HomeScreenText.xpLabel,
        value: '2,460',
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
      child: Row(
        children: <Widget>[
          Container(
            width: Insets.spacing32 + Insets.spacing8,
            height: Insets.spacing32 + Insets.spacing8,
            decoration: BoxDecoration(
              borderRadius: BorderRadii.medium,
              color: colorScheme.secondaryContainer,
            ),
            child: Icon(stat.icon, color: colorScheme.onSecondaryContainer),
          ),
          const SizedBox(width: Insets.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                LumosText(stat.value, style: LumosTextStyle.titleLarge),
                LumosText(stat.label, style: LumosTextStyle.labelMedium),
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
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Semantics(
      label: HomeScreenSemantics.sectionCard,
      container: true,
      excludeSemantics: true,
      child: LumosCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const LumosText(
              HomeScreenText.focusTitle,
              style: LumosTextStyle.titleMedium,
            ),
            const SizedBox(height: Insets.spacing12),
            HomeTaskLine(
              title: 'Shadow listening - 15 min',
              progress: 0.66,
              icon: Icons.headphones_rounded,
              color: colorScheme.primary,
            ),
            const SizedBox(height: Insets.spacing12),
            HomeTaskLine(
              title: 'Vocabulary sprint - 20 words',
              progress: 0.45,
              icon: Icons.grid_view_rounded,
              color: colorScheme.tertiary,
            ),
            const SizedBox(height: Insets.spacing12),
            HomeTaskLine(
              title: 'Pronunciation drill - 10 min',
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
        Icon(icon, size: IconSizes.iconSmall, color: color),
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
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return LumosCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const LumosText(
            HomeScreenText.activityTitle,
            style: LumosTextStyle.titleMedium,
          ),
          const SizedBox(height: Insets.spacing12),
          HomeActivityItem(
            title: 'Spanish Travel Pack',
            subtitle: 'Completed 18 cards',
            trailing: '+120 XP',
            color: colorScheme.primary,
          ),
          const SizedBox(height: Insets.spacing8),
          HomeActivityItem(
            title: 'Grammar: Present Perfect',
            subtitle: 'Scored 9/10',
            trailing: '+60 XP',
            color: colorScheme.tertiary,
          ),
          const SizedBox(height: Insets.spacing8),
          HomeActivityItem(
            title: 'Speaking Challenge',
            subtitle: 'New best streak: 5',
            trailing: 'Badge',
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
    return Container(
      padding: const EdgeInsets.all(Insets.spacing12),
      decoration: BoxDecoration(
        borderRadius: BorderRadii.medium,
        color: color.withValues(alpha: 0.08),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: Insets.spacing8,
            height: Insets.spacing32,
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
          LumosText(trailing, style: LumosTextStyle.labelSmall),
        ],
      ),
    );
  }
}
