import 'package:flutter/material.dart';

import '../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../shared/widgets/lumos_widgets.dart';

class StudySessionContentCard extends StatelessWidget {
  const StudySessionContentCard({
    required this.child,
    super.key,
    this.variant = LumosCardVariant.elevated,
    this.height,
    this.expandToFill = true,
    this.topTrailing,
    this.topTrailingPadding = EdgeInsets.zero,
    this.bottomTrailing,
    this.bottomTrailingPadding = EdgeInsets.zero,
  });

  final Widget child;
  final LumosCardVariant variant;
  final double? height;
  final bool expandToFill;
  final Widget? topTrailing;
  final EdgeInsetsGeometry topTrailingPadding;
  final Widget? bottomTrailing;
  final EdgeInsetsGeometry bottomTrailingPadding;

  @override
  Widget build(BuildContext context) {
    final Widget stackedChild = Stack(
      children: <Widget>[
        child,
        if (topTrailing != null)
          Align(
            alignment: Alignment.topRight,
            child: Padding(padding: topTrailingPadding, child: topTrailing),
          ),
        if (bottomTrailing != null)
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: bottomTrailingPadding,
              child: bottomTrailing,
            ),
          ),
      ],
    );
    final Widget sizedChild;
    if (height != null) {
      sizedChild = SizedBox(height: height, child: stackedChild);
    } else if (expandToFill) {
      sizedChild = SizedBox.expand(child: stackedChild);
    } else {
      sizedChild = stackedChild;
    }
    return LumosCard(
      margin: EdgeInsets.zero,
      variant: variant,
      borderRadius: BorderRadii.xLarge,
      padding: EdgeInsets.zero,
      child: sizedChild,
    );
  }
}
