import 'package:flutter/material.dart';

import '../../../../core/themes/constants/dimensions.dart';
import '../buttons/lumos_button.dart';
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
    return LumosCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (imageUrl != null)
            LumosNetworkImage(
              imageUrl: imageUrl!,
              width: double.infinity,
              height: WidgetSizes.buttonHeightLarge * Insets.spacing4,
            ),
          LumosText(name, style: LumosTextStyle.titleSmall),
          const SizedBox(height: Insets.spacing8),
          LumosText('$price gems', style: LumosTextStyle.bodySmall),
          const SizedBox(height: Insets.spacing8),
          LumosButton(
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
          const SizedBox(height: Insets.spacing8),
          LumosText(price, style: LumosTextStyle.bodyMedium),
          const SizedBox(height: Insets.spacing8),
          ...features.map(
            (String feature) => Padding(
              padding: const EdgeInsets.only(bottom: Insets.spacing4),
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
    return Row(
      children: <Widget>[
        LumosAvatar(imageUrl: avatarUrl, initials: _initial(friendName)),
        const SizedBox(width: Insets.spacing8),
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
    return Container(
      padding: const EdgeInsets.all(Insets.spacing12),
      decoration: BoxDecoration(
        color: isCurrentUser
            ? Theme.of(context).colorScheme.primaryContainer
            : Theme.of(
                context,
              ).colorScheme.surface.withValues(alpha: WidgetOpacities.none),
        borderRadius: BorderRadii.medium,
      ),
      child: Row(
        children: <Widget>[
          LumosText('#$rank', style: LumosTextStyle.labelLarge),
          const SizedBox(width: Insets.spacing8),
          LumosAvatar(imageUrl: avatarUrl, initials: _initial(username)),
          const SizedBox(width: Insets.spacing8),
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
