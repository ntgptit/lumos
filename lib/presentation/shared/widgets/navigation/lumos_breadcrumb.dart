import 'package:flutter/material.dart';

import '../../../../core/themes/constants/dimensions.dart';
import '../typography/lumos_text.dart';
import 'lumos_breadcrumb_trail_item.dart';

abstract final class LumosBreadcrumbConst {
  LumosBreadcrumbConst._();

  static const double stripHeight = Insets.spacing48;
  static const double stripHorizontalPadding = Insets.spacing4;
  static const double stripVerticalPadding = Insets.spacing4;
  static const double itemHorizontalPadding = Insets.spacing12;
  static const double itemVerticalPadding = Insets.spacing8;
  static const double separatorHorizontalPadding = Insets.spacing8;
  static const double itemBorderWidth = WidgetSizes.borderWidthRegular;
  static const double itemIconBadgeSize = Insets.spacing20;
  static const double itemIconSize = IconSizes.iconSmall;
  static const double itemLabelMaxWidthMobile = (Insets.spacing64 * 2) / 3;
  static const double itemLabelMaxWidthTablet = (Insets.spacing64 * 3) / 3;
  static const double itemLabelMaxWidthDesktop = (Insets.spacing64 * 4) / 3;
  static const int defaultMobileVisibleTrailCount = 3;
  static const String overflowTrailLabel = '...';
  static const Duration autoScrollDuration = AppDurations.medium;
}

class LumosBreadcrumbItem<T> {
  const LumosBreadcrumbItem({
    required this.label,
    required this.value,
    this.icon = Icons.folder_open_rounded,
  });

  final String label;
  final T value;
  final IconData icon;
}

class LumosBreadcrumb<T> extends StatefulWidget {
  const LumosBreadcrumb({
    required this.rootLabel,
    required this.items,
    required this.currentValue,
    required this.onSelected,
    super.key,
    this.rootIcon = Icons.home_rounded,
    this.mobileVisibleTrailCount =
        LumosBreadcrumbConst.defaultMobileVisibleTrailCount,
  });

  final String rootLabel;
  final IconData rootIcon;
  final List<LumosBreadcrumbItem<T>> items;
  final T? currentValue;
  final ValueChanged<T?> onSelected;
  final int mobileVisibleTrailCount;

  @override
  State<LumosBreadcrumb<T>> createState() {
    return _LumosBreadcrumbState<T>();
  }
}

class _LumosBreadcrumbState<T> extends State<LumosBreadcrumb<T>> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scheduleScrollToEnd();
  }

  @override
  void didUpdateWidget(covariant LumosBreadcrumb<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final bool itemLengthUnchanged =
        widget.items.length == oldWidget.items.length;
    final bool currentUnchanged = widget.currentValue == oldWidget.currentValue;
    if (itemLengthUnchanged && currentUnchanged) {
      return;
    }
    _scheduleScrollToEnd();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scheduleScrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) {
        return;
      }
      final double maxExtent = _scrollController.position.maxScrollExtent;
      _scrollController.animateTo(
        maxExtent,
        duration: LumosBreadcrumbConst.autoScrollDuration,
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final List<_BreadcrumbEntry<T>> entries = _buildEntries();
    final _RenderModel<T> model = _resolveRenderModel(
      entries: entries,
      isMobile: context.isMobile,
    );
    final List<Widget> children = _buildTrailChildren(
      context: context,
      model: model,
    );
    return Container(
      width: double.infinity,
      height: LumosBreadcrumbConst.stripHeight,
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.symmetric(
        horizontal: LumosBreadcrumbConst.stripHorizontalPadding,
        vertical: LumosBreadcrumbConst.stripVerticalPadding,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadii.large,
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: Row(mainAxisSize: MainAxisSize.max, children: children),
            ),
          );
        },
      ),
    );
  }

  List<_BreadcrumbEntry<T>> _buildEntries() {
    return <_BreadcrumbEntry<T>>[
      _BreadcrumbEntry<T>(label: widget.rootLabel, icon: widget.rootIcon),
      ...widget.items.map((LumosBreadcrumbItem<T> item) {
        return _BreadcrumbEntry<T>(
          label: item.label,
          icon: item.icon,
          value: item.value,
        );
      }),
    ];
  }

  _RenderModel<T> _resolveRenderModel({
    required List<_BreadcrumbEntry<T>> entries,
    required bool isMobile,
  }) {
    if (!isMobile) {
      return _RenderModel<T>(
        hiddenEntries: <_BreadcrumbEntry<T>>[],
        visibleEntries: entries,
      );
    }
    if (entries.length <= widget.mobileVisibleTrailCount) {
      return _RenderModel<T>(
        hiddenEntries: <_BreadcrumbEntry<T>>[],
        visibleEntries: entries,
      );
    }
    final int hiddenCount = entries.length - widget.mobileVisibleTrailCount;
    return _RenderModel<T>(
      hiddenEntries: entries.take(hiddenCount).toList(growable: false),
      visibleEntries: entries.skip(hiddenCount).toList(growable: false),
    );
  }

  List<Widget> _buildTrailChildren({
    required BuildContext context,
    required _RenderModel<T> model,
  }) {
    final List<_DisplayItem<T>> items = <_DisplayItem<T>>[
      if (model.hiddenEntries.isNotEmpty)
        _DisplayItem<T>.overflow(hiddenEntries: model.hiddenEntries),
      ...model.visibleEntries.map(_DisplayItem<T>.entry),
    ];
    return items
        .asMap()
        .entries
        .expand((MapEntry<int, _DisplayItem<T>> pair) {
          final int index = pair.key;
          final _DisplayItem<T> item = pair.value;
          final bool isLast = index == items.length - 1;
          final List<Widget> widgets = <Widget>[
            _buildTrailItem(item: item, isLast: isLast),
          ];
          if (isLast) {
            return widgets;
          }
          widgets.add(_buildSeparator(context: context));
          return widgets;
        })
        .toList(growable: false);
  }

  Widget _buildTrailItem({
    required _DisplayItem<T> item,
    required bool isLast,
  }) {
    if (item.kind == _DisplayKind.overflow) {
      return _OverflowItem<T>(
        entries: item.hiddenEntries,
        onSelected: _onSelectedEntry,
      );
    }
    final _BreadcrumbEntry<T> entry = item.entry!;
    final bool isCurrent = _isCurrent(entry: entry);
    final bool isInteractive = !isLast;
    return LumosBreadcrumbTrailItem(
      label: entry.label,
      icon: entry.icon,
      isCurrent: isCurrent,
      isInteractive: isInteractive,
      onPressed: () => _onSelectedEntry(entry),
      horizontalPadding: LumosBreadcrumbConst.itemHorizontalPadding,
      verticalPadding: LumosBreadcrumbConst.itemVerticalPadding,
      iconBadgeSize: LumosBreadcrumbConst.itemIconBadgeSize,
      iconSize: LumosBreadcrumbConst.itemIconSize,
      mobileLabelMaxWidth: LumosBreadcrumbConst.itemLabelMaxWidthMobile,
      tabletLabelMaxWidth: LumosBreadcrumbConst.itemLabelMaxWidthTablet,
      desktopLabelMaxWidth: LumosBreadcrumbConst.itemLabelMaxWidthDesktop,
    );
  }

  Widget _buildSeparator({required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: LumosBreadcrumbConst.separatorHorizontalPadding,
      ),
      child: Icon(
        Icons.chevron_right_rounded,
        size: IconSizes.iconSmall,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }

  bool _isCurrent({required _BreadcrumbEntry<T> entry}) {
    return entry.value == widget.currentValue;
  }

  void _onSelectedEntry(_BreadcrumbEntry<T> entry) {
    widget.onSelected(entry.value);
  }
}

enum _DisplayKind { entry, overflow }

class _DisplayItem<T> {
  _DisplayItem.entry(this.entry)
    : kind = _DisplayKind.entry,
      hiddenEntries = <_BreadcrumbEntry<T>>[];

  _DisplayItem.overflow({required this.hiddenEntries})
    : kind = _DisplayKind.overflow,
      entry = null;

  final _DisplayKind kind;
  final _BreadcrumbEntry<T>? entry;
  final List<_BreadcrumbEntry<T>> hiddenEntries;
}

class _RenderModel<T> {
  const _RenderModel({
    required this.hiddenEntries,
    required this.visibleEntries,
  });

  final List<_BreadcrumbEntry<T>> hiddenEntries;
  final List<_BreadcrumbEntry<T>> visibleEntries;
}

class _BreadcrumbEntry<T> {
  const _BreadcrumbEntry({required this.label, required this.icon, this.value});

  final String label;
  final IconData icon;
  final T? value;
}

class _OverflowItem<T> extends StatelessWidget {
  const _OverflowItem({required this.entries, required this.onSelected});

  final List<_BreadcrumbEntry<T>> entries;
  final ValueChanged<_BreadcrumbEntry<T>> onSelected;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return PopupMenuButton<_BreadcrumbEntry<T>>(
      tooltip: '',
      padding: EdgeInsets.zero,
      onSelected: onSelected,
      itemBuilder: (BuildContext context) {
        return entries
            .map((entry) {
              return PopupMenuItem<_BreadcrumbEntry<T>>(
                value: entry,
                child: Text(entry.label),
              );
            })
            .toList(growable: false);
      },
      child: Container(
        constraints: const BoxConstraints(
          minHeight: WidgetSizes.minTouchTarget,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: LumosBreadcrumbConst.itemHorizontalPadding,
          vertical: LumosBreadcrumbConst.itemVerticalPadding,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadii.large,
        ),
        child: LumosText(
          LumosBreadcrumbConst.overflowTrailLabel,
          style: LumosTextStyle.bodyMedium,
          tone: LumosTextTone.secondary,
        ),
      ),
    );
  }
}
