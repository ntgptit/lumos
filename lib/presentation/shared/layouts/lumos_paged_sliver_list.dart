import 'package:flutter/material.dart';

class LumosPagedSliverList extends StatelessWidget {
  const LumosPagedSliverList({
    super.key,
    required this.controller,
    required this.leadingSlivers,
    required this.trailingSlivers,
    required this.itemCount,
    required this.itemBuilder,
    this.emptySliver,
  });

  final ScrollController controller;
  final List<Widget> leadingSlivers;
  final List<Widget> trailingSlivers;
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final Widget? emptySliver;

  @override
  Widget build(BuildContext context) {
    Widget contentSliver = SliverList.builder(
      itemCount: itemCount,
      itemBuilder: itemBuilder,
    );
    if (itemCount == 0 && emptySliver != null) {
      contentSliver = SliverToBoxAdapter(child: emptySliver);
    }
    final slivers = <Widget>[
      ...leadingSlivers,
      contentSliver,
      ...trailingSlivers,
    ];
    return CustomScrollView(controller: controller, slivers: slivers);
  }
}
