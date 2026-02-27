import 'package:flutter/material.dart';

import '../../../../core/themes/constants/dimensions.dart';
import '../lumos_models.dart';

class LumosScreenTransitionConst {
  const LumosScreenTransitionConst._();

  static const int durationMs = 360;
  static const double slideOffsetY = 0.06;
}

class LumosAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LumosAppBar({
    super.key,
    this.title,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
    this.elevation,
  });

  final String? title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final Color? backgroundColor;
  final double? elevation;

  @override
  Size get preferredSize => const Size.fromHeight(WidgetSizes.appBarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: _buildTitle(),
      actions: actions,
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: backgroundColor,
      elevation: elevation,
    );
  }

  Widget? _buildTitle() {
    if (title == null) {
      return null;
    }
    return Text(title!, overflow: TextOverflow.ellipsis);
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
        ? const Offset(Insets.spacing0, LumosScreenTransitionConst.slideOffsetY)
        : const Offset(
            Insets.spacing0,
            -LumosScreenTransitionConst.slideOffsetY,
          );
    return AnimatedSwitcher(
      duration: const Duration(
        milliseconds: LumosScreenTransitionConst.durationMs,
      ),
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
    return Container(
      padding: const EdgeInsets.all(Insets.spacing4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadii.large,
      ),
      child: Row(
        children: options
            .asMap()
            .entries
            .map((MapEntry<int, String> entry) => _buildOption(context, entry))
            .toList(),
      ),
    );
  }

  Widget _buildOption(BuildContext context, MapEntry<int, String> entry) {
    final bool isSelected = entry.key == selectedIndex;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          onChanged(entry.key);
        },
        child: AnimatedContainer(
          duration: MotionDurations.animationFast,
          padding: const EdgeInsets.symmetric(
            horizontal: Insets.spacing8,
            vertical: Insets.spacing8,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.surface.withValues(
                    alpha: WidgetOpacities.transparent,
                  ),
            borderRadius: BorderRadii.medium,
          ),
          child: Text(
            entry.value,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: isSelected
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
