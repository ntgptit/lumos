import 'package:flutter/material.dart';

import '../../../../../../../core/themes/foundation/app_foundation.dart';
import 'study_session_layout_metrics.dart';

const double _studySessionActionRowSingleWidthFactor = 0.42;
const double _studySessionActionRowGap = LumosSpacing.lg;
const double _studySessionActionRowHeight = 64;

class StudySessionActionRowLayout extends StatelessWidget {
  const StudySessionActionRowLayout({
    required this.children,
    super.key,
    this.singleWidthFactor = _studySessionActionRowSingleWidthFactor,
    this.gap = _studySessionActionRowGap,
    this.rowHeight = _studySessionActionRowHeight,
    this.verticalSpacing = LumosSpacing.sm,
  });

  final List<Widget> children;
  final double singleWidthFactor;
  final double gap;
  final double rowHeight;
  final double verticalSpacing;

  @override
  Widget build(BuildContext context) {
    final double resolvedGap = StudySessionLayoutMetrics.sectionSpacing(
      context,
      baseValue: gap,
    );
    final double resolvedRowHeight = StudySessionLayoutMetrics.compactHeight(
      context,
      baseValue: rowHeight,
      minScale: ResponsiveDimensions.compactLargeInsetScale,
    );
    final double resolvedVerticalSpacing =
        StudySessionLayoutMetrics.sectionSpacing(
          context,
          baseValue: verticalSpacing,
        );
    if (children.isEmpty) {
      return const SizedBox.shrink();
    }
    if (children.length == 1) {
      return SizedBox(
        height: resolvedRowHeight,
        child: Center(
          child: FractionallySizedBox(
            widthFactor: singleWidthFactor,
            child: children.first,
          ),
        ),
      );
    }
    if (children.length == 2) {
      return SizedBox(
        height: resolvedRowHeight,
        child: Row(
          children: <Widget>[
            Expanded(child: children.first),
            SizedBox(width: resolvedGap),
            Expanded(child: children.last),
          ],
        ),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.generate(children.length, (int index) {
        final bool isLastChild = index == children.length - 1;
        return Padding(
          padding: EdgeInsets.only(
            bottom: isLastChild ? LumosSpacing.none : resolvedVerticalSpacing,
          ),
          child: children[index],
        );
      }, growable: false),
    );
  }
}
