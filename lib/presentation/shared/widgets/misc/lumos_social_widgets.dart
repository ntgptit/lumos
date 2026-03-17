import 'package:flutter/material.dart';

import '../../../../core/themes/foundation/app_foundation.dart';
import '../../../../core/themes/extensions/theme_extensions.dart';
import '../buttons/lumos_buttons.dart';
import '../cards/lumos_card.dart';
import '../typography/lumos_text.dart';
import 'lumos_misc_widgets.dart';

class LumosShopItem extends StatelessWidget {
  const LumosShopItem({
    required this.name,
    required this.price,
    required this.isPurchased,
    required this.onBuy,
    super.key,
    this.imageUrl,
  });

  final String name;
  final int price;
  final String? imageUrl;
  final bool isPurchased;
  final VoidCallback onBuy;

  @override
  Widget build(BuildContext context) {
    final double sectionSpacing = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: AppSpacing.sm,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double imageHeight = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: WidgetSizes.buttonHeightLarge * AppSpacing.xs,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    return LumosCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (imageUrl != null)
            LumosNetworkImage(
              imageUrl: imageUrl!,
              width: double.infinity,
              height: imageHeight,
            ),
          LumosText(name, style: LumosTextStyle.titleSmall),
          SizedBox(height: sectionSpacing),
          LumosText('$price gems', style: LumosTextStyle.bodySmall),
          SizedBox(height: sectionSpacing),
          LumosPrimaryButton(
            label: isPurchased ? 'Purchased' : 'Buy',
            onPressed: isPurchased ? null : onBuy,
            expanded: true,
            size: LumosButtonSize.small,
          ),
        ],
      ),
    );
  }
}

class LumosSubscriptionPlan extends StatelessWidget {
  const LumosSubscriptionPlan({
    required this.name,
    required this.price,
    required this.features,
    required this.isPopular,
    required this.isSelected,
    required this.onSelect,
    super.key,
  });

  final String name;
  final String price;
  final List<String> features;
  final bool isPopular;
  final bool isSelected;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    final double sectionSpacing = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: AppSpacing.sm,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double featureSpacing = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: AppSpacing.xs,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    return LumosCard(
      isSelected: isSelected,
      onTap: onSelect,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: LumosText(name, style: LumosTextStyle.titleSmall),
              ),
              if (isPopular) const Chip(label: Text('Popular')),
            ],
          ),
          SizedBox(height: sectionSpacing),
          LumosText(price, style: LumosTextStyle.bodyMedium),
          SizedBox(height: sectionSpacing),
          ...features.map(
            (String feature) => Padding(
              padding: EdgeInsets.only(bottom: featureSpacing),
              child: LumosText(feature, style: LumosTextStyle.bodySmall),
            ),
          ),
        ],
      ),
    );
  }
}

class LumosFriendActivity extends StatelessWidget {
  const LumosFriendActivity({
    required this.friendName,
    required this.activity,
    super.key,
    this.streak,
    this.avatarUrl,
  });

  final String friendName;
  final String activity;
  final int? streak;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    final double rowSpacing = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: AppSpacing.sm,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    return Row(
      children: <Widget>[
        LumosAvatar(imageUrl: avatarUrl, initials: _initial(friendName)),
        SizedBox(width: rowSpacing),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              LumosText(friendName, style: LumosTextStyle.labelLarge),
              LumosText(activity, style: LumosTextStyle.bodySmall),
            ],
          ),
        ),
        if (streak != null)
          LumosText('$streak 🔥', style: LumosTextStyle.labelSmall),
      ],
    );
  }
}

class LumosLeaderboardRow extends StatelessWidget {
  const LumosLeaderboardRow({
    required this.rank,
    required this.username,
    required this.xp,
    required this.isCurrentUser,
    super.key,
    this.avatarUrl,
  });

  final int rank;
  final String username;
  final int xp;
  final bool isCurrentUser;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    final EdgeInsets rowPadding = ResponsiveDimensions.compactInsets(
      context: context,
      baseInsets: const EdgeInsets.all(AppSpacing.md),
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double rowSpacing = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: AppSpacing.sm,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    return Container(
      padding: rowPadding,
      decoration: BoxDecoration(
        color: isCurrentUser
            ? context.colorScheme.primaryContainer
            : context.colorScheme.surface.withValues(
                alpha: AppOpacity.transparent,
              ),
        borderRadius: BorderRadii.medium,
      ),
      child: Row(
        children: <Widget>[
          LumosText('#$rank', style: LumosTextStyle.labelLarge),
          SizedBox(width: rowSpacing),
          LumosAvatar(imageUrl: avatarUrl, initials: _initial(username)),
          SizedBox(width: rowSpacing),
          Expanded(
            child: LumosText(username, style: LumosTextStyle.bodyMedium),
          ),
          LumosText('$xp XP', style: LumosTextStyle.labelLarge),
        ],
      ),
    );
  }
}

String _initial(String value) {
  if (value.isEmpty) {
    return '?';
  }
  return value[0];
}
