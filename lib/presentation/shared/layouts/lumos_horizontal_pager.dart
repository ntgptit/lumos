import 'package:flutter/material.dart';

class LumosHorizontalPager extends StatelessWidget {
  const LumosHorizontalPager({
    super.key,
    required this.controller,
    required this.itemCount,
    required this.itemBuilder,
    this.onPageChanged,
    this.onLeadingEdgeAttempt,
  });

  final PageController controller;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final ValueChanged<int>? onPageChanged;
  final VoidCallback? onLeadingEdgeAttempt;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.pixels <=
            notification.metrics.minScrollExtent) {
          onLeadingEdgeAttempt?.call();
        }
        return false;
      },
      child: PageView.builder(
        controller: controller,
        itemCount: itemCount,
        onPageChanged: onPageChanged,
        itemBuilder: itemBuilder,
      ),
    );
  }
}
