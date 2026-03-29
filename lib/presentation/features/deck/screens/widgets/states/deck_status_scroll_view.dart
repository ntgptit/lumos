import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';

class DeckStatusScrollView extends StatelessWidget {
  const DeckStatusScrollView({
    required this.scrollController,
    required this.leadingSlivers,
    required this.onRefresh,
    required this.child,
    super.key,
  });

  final ScrollController scrollController;
  final List<Widget> leadingSlivers;
  final RefreshCallback onRefresh;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: LumosScreenFrame(
        child: CustomScrollView(
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: <Widget>[
            ...leadingSlivers,
            SliverToBoxAdapter(child: child),
          ],
        ),
      ),
    );
  }
}
