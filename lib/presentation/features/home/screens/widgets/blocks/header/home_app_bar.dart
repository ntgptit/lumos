import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../../providers/home_provider.dart';
import '../../../../providers/states/home_state.dart';
import '../../../../extensions/home_tab_id_l10n_extension.dart';

abstract final class HomeAppBarConst {
  HomeAppBarConst._();

  static const double notificationDotSize =
      12;
  static const double compactNotificationDotSize =
      8 +
      4;
  static const double brandMarkSizeCompact =
      64 +
      8;
  static const double brandMarkSizeExpanded =
      52;
  static const EdgeInsetsGeometry
  profilePillPaddingCompact = EdgeInsets.symmetric(
    horizontal: 8,
    vertical: 4,
  );
  static const EdgeInsetsGeometry
  profilePillPaddingExpanded = EdgeInsets.symmetric(
    horizontal: 8,
    vertical: 8,
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
    final ThemeData theme = context.theme;
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
            size: isCompact
                ? context.iconSize.sm
                : context.iconSize.lg,
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
              padding: EdgeInsets.symmetric(
                horizontal: context.spacing.md,
                vertical: context.spacing.sm,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconTheme(
                    data: IconThemeData(
                      color: colorScheme.onSecondaryContainer,
                    ),
                    child: LumosIcon(
                      Icons.local_fire_department_rounded,
                      size: context.iconSize.sm,
                    ),
                  ),
                  SizedBox(
                    width: context.spacing.xs,
                  ),
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
              size: context.iconSize.lg,
            ),
            Positioned(
              top: isCompact
                  ? context.spacing.xs
                  : context.spacing.sm,
              right: isCompact
                  ? context.spacing.xs
                  : context.spacing.sm,
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
                child: LumosIcon(
                  Icons.person_outline_rounded,
                  size: context.iconSize.lg,
                ),
              ),
              if (!isCompact) ...<Widget>[
                SizedBox(
                  width: context.spacing.sm,
                ),
                LumosInlineText(
                  l10n.homeProfileQuickName,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  width: context.spacing.xs,
                ),
              ],
              IconTheme(
                data: IconThemeData(color: colorScheme.onSurfaceVariant),
                child: LumosIcon(
                  Icons.keyboard_arrow_down_rounded,
                  size: context.iconSize.sm,
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
