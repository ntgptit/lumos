import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../l10n/app_localizations.dart';
import 'widgets/blocks/content/dashboard/home_animated_reveal.dart';
import 'widgets/blocks/content/dashboard/home_hero_card.dart';
import 'widgets/blocks/content/dashboard/home_split_section.dart';
import 'widgets/blocks/content/dashboard/home_stat_grid.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final DeviceType deviceType = context.deviceType;
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ColorScheme colorScheme = context.theme.colorScheme;
    final double sectionGap = context.compactValue(
      baseValue:
          context.spacing.xxl,
      minScale: ResponsiveDimensions.compactLargeInsetScale,
    );
    return ColoredBox(
      color: colorScheme.surface,
      child: SingleChildScrollView(
        child: LumosScreenFrame(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              HomeAnimatedReveal(
                order: 0,
                child: HomeHeroCard(deviceType: deviceType, l10n: l10n),
              ),
              SizedBox(height: sectionGap),
              const HomeAnimatedReveal(order: 1, child: HomeStatGrid()),
              SizedBox(height: sectionGap),
              HomeAnimatedReveal(
                order: 2,
                child: HomeSplitSection(deviceType: deviceType),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
