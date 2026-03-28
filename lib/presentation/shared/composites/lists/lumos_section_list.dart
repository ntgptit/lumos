import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';

class LumosSectionList extends StatelessWidget {
  const LumosSectionList({
    super.key,
    required this.sections,
    this.padding,
    this.spacing,
    this.scrollable = false,
    this.physics,
    this.primary,
  });

  final List<Widget> sections;
  final EdgeInsetsGeometry? padding;
  final double? spacing;
  final bool scrollable;
  final ScrollPhysics? physics;
  final bool? primary;

  @override
  Widget build(BuildContext context) {
    final gap = spacing ?? context.spacing.lg;

    if (scrollable) {
      return ListView.separated(
        padding: padding,
        primary: primary,
        physics: physics,
        itemCount: sections.length,
        itemBuilder: (context, index) => sections[index],
        separatorBuilder: (context, index) => SizedBox(height: gap),
      );
    }

    if (sections.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        children: [
          for (var index = 0; index < sections.length; index++) ...[
            if (index > 0) SizedBox(height: gap),
            sections[index],
          ],
        ],
      ),
    );
  }
}
