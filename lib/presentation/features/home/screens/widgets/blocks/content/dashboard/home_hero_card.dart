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

