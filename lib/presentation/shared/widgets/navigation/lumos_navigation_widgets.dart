import 'package:flutter/material.dart';

import '../../../../core/themes/constants/dimensions.dart';
import '../lumos_models.dart';

abstract final class LumosScreenTransitionConst {
  LumosScreenTransitionConst._();

  static const Duration duration = MotionDurations.animationSlow;
  static const double slideOffsetY = WidgetRatios.transitionSlideOffsetY;
}

class LumosAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LumosAppBar({
    super.key,
    this.title,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.elevation,
  });

  final String? title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
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
