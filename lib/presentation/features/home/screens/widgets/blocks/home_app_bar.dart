import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/lumos_widgets.dart';
import '../../../providers/home_provider.dart';
import '../../../providers/states/home_state.dart';
import '../../../extensions/home_tab_id_l10n_extension.dart';

abstract final class HomeAppBarConst {
  HomeAppBarConst._();

  static const double notificationDotSize = AppSpacing.sm;
  static const double compactNotificationDotSize =
      AppSpacing.xs + AppSpacing.xxs;
  static const double brandMarkSizeCompact = AppSpacing.xxxl + AppSpacing.xs;
  static const double brandMarkSizeExpanded = WidgetSizes.avatarLarge;
  static const EdgeInsetsGeometry profilePillPaddingCompact =
      EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: AppSpacing.xxs);
  static const EdgeInsetsGeometry profilePillPaddingExpanded =
      EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: AppSpacing.xs);
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
    final String? subtitle = isCompact
        ? null
        : switch (tabId) {
            HomeTabId.home => l10n.homeGoalProgress,
            HomeTabId.library => l10n.homeLibrarySubtitle,
            HomeTabId.folders => l10n.folderManagerSubtitle,
            HomeTabId.progress => l10n.homeProgressSubtitle,
            HomeTabId.profile => l10n.homeProfileSubtitle,
          };
    return LumosAppBar(
      eyebrow: isCompact ? null : l10n.appTitle,
      title: tabId.toLocalizedLabel(l10n),
      subtitle: subtitle,
      wrapActions: false,
      titleLeading: _HomeBrandMark(isCompact: isCompact),
      titleLeadingSize: isCompact
          ? HomeAppBarConst.brandMarkSizeCompact
          : HomeAppBarConst.brandMarkSizeExpanded,
      titleTrailing: showStatusChip && tabId == HomeTabId.home
          ? _HomeStatusChip(label: l10n.homeStatStreakValue)
          : null,
      actions: <Widget>[
        _HomeNotificationButton(isCompact: isCompact),
        _HomeProfilePill(
          label: l10n.homeProfileQuickName,
          isCompact: isCompact,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(
    LumosAppBarConst.expandedToolbarHeight + AppStroke.thin,
  );
}

class _HomeBrandMark extends StatelessWidget {
  const _HomeBrandMark({required this.isCompact});

  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[colorScheme.primary, colorScheme.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadii.large,
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
  }
}

class _HomeStatusChip extends StatelessWidget {
  const _HomeStatusChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: BorderRadii.pill,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconTheme(
              data: IconThemeData(color: colorScheme.onSecondaryContainer),
              child: const LumosIcon(
                Icons.local_fire_department_rounded,
                size: IconSizes.iconSmall,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            LumosInlineText(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.onSecondaryContainer,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeNotificationButton extends StatelessWidget {
  const _HomeNotificationButton({required this.isCompact});

  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        LumosIconButton(
          onPressed: () {},
          icon: Icons.notifications_none_rounded,
          size: IconSizes.iconMedium,
        ),
        Positioned(
          top: isCompact ? AppSpacing.xs : AppSpacing.sm,
          right: isCompact ? AppSpacing.xs : AppSpacing.sm,
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
    );
  }
}

class _HomeProfilePill extends StatelessWidget {
  const _HomeProfilePill({required this.label, required this.isCompact});

  final String label;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    return Padding(
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
              size: IconSizes.iconMedium,
            ),
          ),
          if (!isCompact) ...<Widget>[
            const SizedBox(width: AppSpacing.sm),
            LumosInlineText(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
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
    );
  }
}
