import 'package:flutter/material.dart';

import '../../../../core/themes/foundation/app_foundation.dart';
import '../../../../core/themes/extensions/theme_extensions.dart';
import '../lumos_models.dart';

abstract final class LumosScreenTransitionConst {
  LumosScreenTransitionConst._();

  static const Duration duration = MotionDurations.animationSlow;
  static const double slideOffsetY = WidgetRatios.transitionSlideOffsetY;
}

abstract final class LumosAppBarConst {
  LumosAppBarConst._();

  static const double compactToolbarHeight = WidgetSizes.appBarHeight;
  static const double expandedToolbarHeight =
      WidgetSizes.appBarHeight + AppSpacing.lg;
  static const double actionGroupMinHeight = WidgetSizes.minTouchTarget;
  static const double titleLeadingSize = WidgetSizes.avatarLarge;
  static const double compactTitleSpacing = AppSpacing.md;
  static const double regularTitleSpacing = AppSpacing.lg;
  static const double compactTitleGap = AppSpacing.sm;
  static const double regularTitleGap = AppSpacing.md;
  static const EdgeInsetsGeometry compactActionGroupPadding =
      EdgeInsets.symmetric(
        horizontal: AppSpacing.xxs,
        vertical: AppSpacing.xxs,
      );
  static const EdgeInsetsGeometry actionGroupPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.xs,
    vertical: AppSpacing.xs,
  );
}

class LumosAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LumosAppBar({
    super.key,
    this.title,
    this.subtitle,
    this.eyebrow,
    this.titleLeading,
    this.titleTrailing,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.elevation,
    this.toolbarHeight,
    this.showBottomDivider = true,
    this.titleLeadingSize,
    this.wrapActions = true,
  });

  final String? title;
  final String? subtitle;
  final String? eyebrow;
  final Widget? titleLeading;
  final Widget? titleTrailing;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final double? elevation;
  final double? toolbarHeight;
  final bool showBottomDivider;
  final double? titleLeadingSize;
  final bool wrapActions;

  @override
  Size get preferredSize => Size.fromHeight(
    _resolvedToolbarHeight +
        (showBottomDivider ? AppStroke.thin : WidgetSizes.none),
  );

  @override
  Widget build(BuildContext context) {
    final bool isCompact =
        MediaQuery.sizeOf(context).width < Breakpoints.kMobileMaxWidth;
    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      toolbarHeight: _resolvedToolbarHeight,
      titleSpacing: isCompact
          ? LumosAppBarConst.compactTitleSpacing
          : LumosAppBarConst.regularTitleSpacing,
      elevation: elevation ?? WidgetSizes.none,
      title: _buildTitle(context, isCompact: isCompact),
      actions: _buildActions(context, isCompact: isCompact),
      leading: leading,
      bottom: _buildBottomDivider(),
    );
  }

  double get _resolvedToolbarHeight {
    if (toolbarHeight case final double resolvedHeight) {
      return resolvedHeight;
    }
    if (subtitle != null || eyebrow != null || titleLeading != null) {
      return LumosAppBarConst.expandedToolbarHeight;
    }
    return LumosAppBarConst.compactToolbarHeight;
  }

  PreferredSizeWidget? _buildBottomDivider() {
    if (!showBottomDivider) {
      return null;
    }
    return const PreferredSize(
      preferredSize: Size.fromHeight(AppStroke.thin),
      child: Divider(height: AppStroke.thin, thickness: AppStroke.thin),
    );
  }

  Widget? _buildTitle(BuildContext context, {required bool isCompact}) {
    if (title == null) {
      return null;
    }
    return _LumosAppBarTitle(
      title: title!,
      subtitle: subtitle,
      eyebrow: eyebrow,
      leading: titleLeading,
      trailing: titleTrailing,
      titleLeadingSize: titleLeadingSize,
      isCompact: isCompact,
    );
  }

  List<Widget>? _buildActions(BuildContext context, {required bool isCompact}) {
    final List<Widget>? resolvedActions = actions;
    if (resolvedActions == null || resolvedActions.isEmpty) {
      return null;
    }
    return <Widget>[
      Padding(
        padding: EdgeInsetsDirectional.only(
          end: isCompact ? AppSpacing.sm : AppSpacing.md,
        ),
        child: wrapActions
            ? _LumosAppBarActionGroup(
                actions: resolvedActions,
                isCompact: isCompact,
              )
            : _LumosAppBarActionRow(
                actions: resolvedActions,
                isCompact: isCompact,
              ),
      ),
    ];
  }
}

class _LumosAppBarTitle extends StatelessWidget {
  const _LumosAppBarTitle({
    required this.title,
    required this.isCompact,
    this.subtitle,
    this.eyebrow,
    this.leading,
    this.trailing,
    this.titleLeadingSize,
  });

  final String title;
  final bool isCompact;
  final String? subtitle;
  final String? eyebrow;
  final Widget? leading;
  final Widget? trailing;
  final double? titleLeadingSize;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = context.textTheme;
    final ColorScheme colorScheme = context.colorScheme;
    return Row(
      children: <Widget>[
        if (leading case final Widget leadingWidget) ...<Widget>[
          SizedBox.square(
            dimension: titleLeadingSize ?? LumosAppBarConst.titleLeadingSize,
            child: Center(child: leadingWidget),
          ),
          SizedBox(
            width: isCompact
                ? LumosAppBarConst.compactTitleGap
                : LumosAppBarConst.regularTitleGap,
          ),
        ],
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (eyebrow case final String eyebrowText)
                Text(
                  eyebrowText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.labelMedium?.withResolvedColor(
                    colorScheme.onSurfaceVariant,
                  ),
                ),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.titleLarge,
              ),
              if (subtitle case final String subtitleText)
                Text(
                  subtitleText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.withResolvedColor(
                    colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
        if (trailing case final Widget trailingWidget) ...<Widget>[
          const SizedBox(width: AppSpacing.md),
          trailingWidget,
        ],
      ],
    );
  }
}

class _LumosAppBarActionGroup extends StatelessWidget {
  const _LumosAppBarActionGroup({
    required this.actions,
    required this.isCompact,
  });

  final List<Widget> actions;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = context.colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadii.large,
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: AppStroke.thin,
        ),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: LumosAppBarConst.actionGroupMinHeight,
        ),
        child: Padding(
          padding: isCompact
              ? LumosAppBarConst.compactActionGroupPadding
              : LumosAppBarConst.actionGroupPadding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: _buildSpacedActions(),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSpacedActions() {
    return actions
        .asMap()
        .entries
        .expand((MapEntry<int, Widget> entry) sync* {
          if (entry.key > 0) {
            yield const SizedBox(width: AppSpacing.xs);
          }
          yield entry.value;
        })
        .toList(growable: false);
  }
}

class _LumosAppBarActionRow extends StatelessWidget {
  const _LumosAppBarActionRow({required this.actions, required this.isCompact});

  final List<Widget> actions;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: actions
          .asMap()
          .entries
          .expand((MapEntry<int, Widget> entry) sync* {
            if (entry.key > 0) {
              yield SizedBox(width: isCompact ? AppSpacing.xs : AppSpacing.sm);
            }
            yield entry.value;
          })
          .toList(growable: false),
    );
  }
}

class LumosScreenTransition extends StatelessWidget {
  const LumosScreenTransition({
    required this.child,
    required this.switchKey,
    super.key,
    this.moveForward = true,
  });

  final Widget child;
  final Key switchKey;
  final bool moveForward;

  @override
  Widget build(BuildContext context) {
    final Offset beginOffset = moveForward
        ? const Offset(AppSpacing.none, LumosScreenTransitionConst.slideOffsetY)
        : const Offset(
            AppSpacing.none,
            -LumosScreenTransitionConst.slideOffsetY,
          );
    return AnimatedSwitcher(
      duration: LumosScreenTransitionConst.duration,
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
        return Stack(
          children: <Widget>[
            ...previousChildren,
            if (currentChild case final Widget value) value,
          ],
        );
      },
      transitionBuilder: (Widget transitionChild, Animation<double> animation) {
        final Animation<Offset> slideAnimation = Tween<Offset>(
          begin: beginOffset,
          end: Offset.zero,
        ).animate(animation);
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: slideAnimation,
            child: transitionChild,
          ),
        );
      },
      child: KeyedSubtree(key: switchKey, child: child),
    );
  }
}

class LumosTabBar extends StatelessWidget implements PreferredSizeWidget {
  const LumosTabBar({
    required this.tabs,
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  final List<LumosTab> tabs;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Size get preferredSize =>
      const Size.fromHeight(WidgetSizes.buttonHeightLarge);

  @override
  Widget build(BuildContext context) {
    return TabBar(tabs: tabs.map(_buildTab).toList(), onTap: onTap);
  }

  Widget _buildTab(LumosTab tab) {
    if (tab.icon == null) {
      return Tab(text: tab.label);
    }
    return Tab(
      text: tab.label,
      icon: Icon(tab.icon, size: IconSizes.iconSmall),
    );
  }
}

class LumosSegmentedControl extends StatelessWidget {
  const LumosSegmentedControl({
    required this.options,
    required this.selectedIndex,
    required this.onChanged,
    super.key,
  });

  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final List<ButtonSegment<int>> segments = options
        .asMap()
        .entries
        .map((MapEntry<int, String> entry) {
          return ButtonSegment<int>(
            value: entry.key,
            label: Text(entry.value, overflow: TextOverflow.ellipsis),
          );
        })
        .toList(growable: false);
    final Set<int> selectedValues = _resolveSelectedValues();
    return SegmentedButton<int>(
      segments: segments,
      selected: selectedValues,
      showSelectedIcon: false,
      onSelectionChanged: (Set<int> nextSelection) {
        if (nextSelection.isEmpty) {
          return;
        }
        onChanged(nextSelection.first);
      },
    );
  }

  Set<int> _resolveSelectedValues() {
    if (options.isEmpty) {
      return <int>{};
    }
    final int resolvedSelectedIndex = _resolveSelectedIndex();
    return <int>{resolvedSelectedIndex};
  }

  int _resolveSelectedIndex() {
    if (selectedIndex < 0) {
      return 0;
    }
    if (selectedIndex >= options.length) {
      return options.length - 1;
    }
    return selectedIndex;
  }
}
