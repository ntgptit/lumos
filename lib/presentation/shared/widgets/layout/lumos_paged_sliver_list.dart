import 'package:flutter/material.dart';

abstract final class LumosPagedSliverListConst {
  LumosPagedSliverListConst._();

  static const List<Widget> emptySlivers = <Widget>[];
}

class LumosPagedSliverList extends StatelessWidget {
  const LumosPagedSliverList({
    required this.itemCount,
    required this.itemBuilder,
    super.key,
    this.controller,
    this.leadingSlivers = LumosPagedSliverListConst.emptySlivers,
    this.trailingSlivers = LumosPagedSliverListConst.emptySlivers,
    this.emptySliver,
    this.physics = const AlwaysScrollableScrollPhysics(),
  });

  final ScrollController? controller;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final List<Widget> leadingSlivers;
  final List<Widget> trailingSlivers;
  final Widget? emptySliver;
  final ScrollPhysics physics;

  @override
  Widget build(BuildContext context) {
    final List<Widget> slivers = <Widget>[
      ...leadingSlivers,
      _buildBodySliver(),
      ...trailingSlivers,
    ];
    return CustomScrollView(
      controller: controller,
      physics: physics,
      slivers: slivers,
    );
  }

  Widget _buildBodySliver() {
    if (itemCount > 0) {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          itemBuilder,
          childCount: itemCount,
        ),
      );
    }
    if (emptySliver case final Widget widget) {
      return SliverToBoxAdapter(child: widget);
    }
    return const SliverToBoxAdapter(child: SizedBox.shrink());
  }
}
