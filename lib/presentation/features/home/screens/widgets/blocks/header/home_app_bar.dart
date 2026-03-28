import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../../providers/home_provider.dart';
import '../../../../providers/states/home_state.dart';
import '../../../../extensions/home_tab_id_l10n_extension.dart';

abstract final class HomeAppBarConst {
  HomeAppBarConst._();

  static const double notificationDotSize = LumosSpacing.sm;
  static const double compactNotificationDotSize =
      LumosSpacing.xs + LumosSpacing.xxs;
  static const double brandMarkSizeCompact =
      LumosSpacing.xxxl + LumosSpacing.xs;
  static const double brandMarkSizeExpanded = WidgetSizes.avatarLarge;
  static const EdgeInsetsGeometry profilePillPaddingCompact =
      EdgeInsets.symmetric(
        horizontal: LumosSpacing.xs,
        vertical: LumosSpacing.xxs,
      );
  static const EdgeInsetsGeometry profilePillPaddingExpanded =
      EdgeInsets.symmetric(
        horizontal: LumosSpacing.xs,
        vertical: LumosSpacing.xs,
      );
}

class HomeAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final HomeTabId tabId = ref.watch(homeSelectedTabProvider);
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final bool isCompact =
        MediaQuery.sizeOf(context).width < Breakpoints.kMobileMaxWidth;
    final bool showStatusChip = !isCompact;
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final String? subtitle = isCompact
        ? null
        : switch (tabId) {
            HomeTabId.home => l10n.homeGoalProgress,
            HomeTabId.library => l10n.homeLibrarySubtitle,
            HomeTabId.folders => l10n.folderManagerSubtitle,
            HomeTabId.progress => l10n.homeProgressSubtitle,
            HomeTabId.profile => l10n.homeProfileSubtitle,
          };
    final Widget titleLeading = DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[colorScheme.primary, colorScheme.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: context.shapes.card,
      ),
      child: SizedBox.square(
        dimension: isCompact
            ? HomeAppBarConst.brandMarkSizeCompact
            : HomeAppBarConst.brandMarkSizeExpanded,
        child: IconTheme(
          data: IconThemeData(color: colorScheme.onPrimary),
          child: LumosIcon(
            Icons.auto_awesome_rounded,
            size: isCompact ? IconSizes.iconSmall : IconSizes.iconMedium,
          ),
        ),
      ),
    );
    final Widget? titleTrailing = showStatusChip && tabId == HomeTabId.home
        ? DecoratedBox(
            decoration: BoxDecoration(
              color: colorScheme.secondaryContainer,
              borderRadius: context.shapes.pill,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: LumosSpacing.md,
                vertical: LumosSpacing.sm,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconTheme(
                    data: IconThemeData(
                      color: colorScheme.onSecondaryContainer,
                    ),
                    child: const LumosIcon(
                      Icons.local_fire_department_rounded,
                      size: IconSizes.iconSmall,
                    ),
                  ),
                  const SizedBox(width: LumosSpacing.xs),
                  LumosInlineText(
                    l10n.homeStatStreakValue,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          )
        : null;
    return LumosAppBar(
      eyebrow: isCompact ? null : l10n.appTitle,
      title: tabId.toLocalizedLabel(l10n),
      subtitle: subtitle,
      wrapActions: false,
      titleLeading: titleLeading,
      titleLeadingSize: isCompact
          ? HomeAppBarConst.brandMarkSizeCompact
          : HomeAppBarConst.brandMarkSizeExpanded,
      titleTrailing: titleTrailing,
      actions: <Widget>[
        Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            LumosIconButton(
              onPressed: () {},
              icon: Icons.notifications_none_rounded,
              size: IconSizes.iconMedium,
            ),
            Positioned(
              top: isCompact ? LumosSpacing.xs : LumosSpacing.sm,
              right: isCompact ? LumosSpacing.xs : LumosSpacing.sm,
              child: Container(
                width: isCompact
                    ? HomeAppBarConst.compactNotificationDotSize
                    : HomeAppBarConst.notificationDotSize,
                height: isCompact
                    ? HomeAppBarConst.compactNotificationDotSize
                    : HomeAppBarConst.notificationDotSize,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.surfaceContainerLow,
                    width: AppStroke.thin,
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: isCompact
              ? HomeAppBarConst.profilePillPaddingCompact
              : HomeAppBarConst.profilePillPaddingExpanded,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconTheme(
                data: IconThemeData(color: colorScheme.onSurfaceVariant),
                child: const LumosIcon(
                  Icons.person_outline_rounded,
                  size: IconSizes.iconMedium,
                ),
              ),
              if (!isCompact) ...<Widget>[
                const SizedBox(width: LumosSpacing.sm),
                LumosInlineText(
                  l10n.homeProfileQuickName,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: LumosSpacing.xs),
              ],
              IconTheme(
                data: IconThemeData(color: colorScheme.onSurfaceVariant),
                child: const LumosIcon(
                  Icons.keyboard_arrow_down_rounded,
                  size: IconSizes.iconSmall,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(
    LumosAppBarConst.expandedToolbarHeight + AppStroke.thin,
  );
}
