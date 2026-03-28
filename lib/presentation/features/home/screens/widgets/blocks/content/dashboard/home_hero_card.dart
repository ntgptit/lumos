import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../../../../l10n/app_localizations.dart';
import '../../../../../constants/home_contract.dart';

abstract final class HomeHeroCardConst {
  HomeHeroCardConst._();

  static const double heroMinHeightMobile = 280;
  static const double heroMinHeightLarge = 250;
  static const double emphasizedBorderWidth = AppStroke.thin;
  static const double heroShadowBlurRadius = LumosSpacing.xxl;
  static const double heroShadowOffsetY = LumosSpacing.sm;
}

class HomeHeroCard extends StatelessWidget {
  const HomeHeroCard({required this.deviceType, required this.l10n, super.key});

  final DeviceType deviceType;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final bool isMobile = deviceType == DeviceType.mobile;
    final double heroPadding = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.xxl,
      minScale: ResponsiveDimensions.compactLargeInsetScale,
    );
    final double titleGap = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.lg,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
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
                LumosSpacing.none,
                HomeHeroCardConst.heroShadowOffsetY,
              ),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadii.large,
          child: Padding(
            padding: EdgeInsets.all(heroPadding),
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
                    const SizedBox(width: LumosSpacing.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: LumosSpacing.sm,
                        vertical: LumosSpacing.xs,
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
                SizedBox(height: titleGap),
                LumosText(
                  l10n.homeHeroTitle,
                  style: LumosTextStyle.headlineMedium,
                  containerRole: LumosTextContainerRole.primaryContainer,
                ),
                const SizedBox(height: LumosSpacing.sm),
                LumosText(
                  l10n.homeHeroBody,
                  style: LumosTextStyle.bodyMedium,
                  containerRole: LumosTextContainerRole.primaryContainer,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: titleGap),
                Wrap(
                  spacing: LumosSpacing.sm,
                  runSpacing: LumosSpacing.sm,
                  children: <Widget>[
                    LumosPrimaryButton(
                      text: l10n.homePrimaryAction,
                      onPressed: () {},
                      icon: Icons.play_arrow_rounded,
                    ),
                    LumosSecondaryButton(
                      text: l10n.homeSecondaryAction,
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

