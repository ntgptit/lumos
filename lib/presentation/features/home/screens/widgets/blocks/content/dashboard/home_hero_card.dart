import 'package:flutter/material.dart';

import '../../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../../l10n/app_localizations.dart';
import '../../../../../../../shared/widgets/lumos_widgets.dart';
import '../../../../../constants/home_contract.dart';

abstract final class HomeHeroCardConst {
  HomeHeroCardConst._();

  static const double heroMinHeightMobile = 280;
  static const double heroMinHeightLarge = 250;
  static const double emphasizedBorderWidth = AppStroke.thin;
  static const double heroShadowBlurRadius = AppSpacing.xxl;
  static const double heroShadowOffsetY = AppSpacing.sm;
}

class HomeHeroCard extends StatelessWidget {
  const HomeHeroCard({required this.deviceType, required this.l10n, super.key});

  final DeviceType deviceType;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final bool isMobile = deviceType == DeviceType.mobile;
    final Color secondaryBlend = Color.alphaBlend(
      colorScheme.secondaryContainer.withValues(alpha: AppOpacity.strong),
      colorScheme.surfaceContainerLowest,
    );
    return Semantics(
      label: HomeScreenSemantics.heroCard,
      container: true,
      excludeSemantics: true,
      child: Container(
        constraints: BoxConstraints(
          minHeight: isMobile
              ? HomeHeroCardConst.heroMinHeightMobile
              : HomeHeroCardConst.heroMinHeightLarge,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadii.large,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[colorScheme.primaryContainer, secondaryBlend],
          ),
          border: Border.all(
            color: colorScheme.outlineVariant,
            width: HomeHeroCardConst.emphasizedBorderWidth,
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: AppOpacity.subtle),
              blurRadius: HomeHeroCardConst.heroShadowBlurRadius,
              offset: const Offset(
                AppSpacing.none,
                HomeHeroCardConst.heroShadowOffsetY,
              ),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadii.large,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    IconTheme(
                      data: IconThemeData(color: colorScheme.primary),
                      child: const LumosIcon(
                        Icons.auto_awesome_rounded,
                        size: IconSizes.iconMedium,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerLowest,
                        borderRadius: BorderRadii.large,
                        border: Border.all(
                          color: colorScheme.outlineVariant,
                          width: HomeHeroCardConst.emphasizedBorderWidth,
                        ),
                      ),
                      child: LumosText(
                        l10n.homeAiLearningPath,
                        style: LumosTextStyle.labelSmall,
                        tone: LumosTextTone.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                LumosText(
                  l10n.homeHeroTitle,
                  style: LumosTextStyle.headlineMedium,
                  containerRole: LumosTextContainerRole.primaryContainer,
                ),
                const SizedBox(height: AppSpacing.sm),
                LumosText(
                  l10n.homeHeroBody,
                  style: LumosTextStyle.bodyMedium,
                  containerRole: LumosTextContainerRole.primaryContainer,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.lg),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: <Widget>[
                    LumosPrimaryButton(
                      label: l10n.homePrimaryAction,
                      onPressed: () {},
                      icon: Icons.play_arrow_rounded,
                    ),
                    LumosSecondaryButton(
                      label: l10n.homeSecondaryAction,
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
