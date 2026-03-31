import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import 'package:lumos/core/utils/string_utils.dart';
import '../../../../../../../domain/entities/auth/auth_models.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../../../../shared/composites/cards/lumos_hero_banner.dart';
import '../../../../../../shared/primitives/displays/lumos_pill.dart';

class ProfileAccountCard extends StatelessWidget {
  const ProfileAccountCard({required this.user, super.key});

  final AuthUser user;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final double bannerGap = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.lg,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double titleGap = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.sm,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double rowGap = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.md,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double iconBoxSize = context.component.listItemLeadingSize;

    return LumosHeroBanner(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: iconBoxSize,
            height: iconBoxSize,
            decoration: BoxDecoration(
              color: context.colorScheme.surfaceContainerHigh,
              borderRadius: context.shapes.control,
              border: Border.all(
                color: context.colorScheme.outlineVariant,
                width: WidgetSizes.borderWidthRegular,
              ),
            ),
            child: Center(
              child: LumosText(
                _initials(),
                style: LumosTextStyle.labelLarge,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(width: rowGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: LumosText(
                        l10n.profileAccountSectionTitle,
                        style: LumosTextStyle.titleLarge,
                      ),
                    ),
                    SizedBox(width: titleGap),
                    LumosPill(
                      backgroundColor: context.colorScheme.surfaceContainerHigh,
                      child: LumosText(
                        user.accountStatus,
                        style: LumosTextStyle.labelLarge,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: titleGap),
                LumosText(
                  l10n.profileAccountSectionSubtitle,
                  style: LumosTextStyle.bodySmall,
                  tone: LumosTextTone.secondary,
                ),
                SizedBox(height: bannerGap),
                LumosText(
                  user.username,
                  style: LumosTextStyle.titleMedium,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: context.spacing.xxs),
                LumosText(
                  user.email,
                  style: LumosTextStyle.bodySmall,
                  tone: LumosTextTone.secondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _initials() {
    return StringUtils.initials(user.username);
  }
}
