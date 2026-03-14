import 'package:flutter/material.dart';

import '../../../../core/themes/foundation/app_foundation.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../shared/widgets/lumos_widgets.dart';
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
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
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
              const SizedBox(height: AppSpacing.xxl),
              const HomeAnimatedReveal(order: 1, child: HomeStatGrid()),
              const SizedBox(height: AppSpacing.xxl),
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
