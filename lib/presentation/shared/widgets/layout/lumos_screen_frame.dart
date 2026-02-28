import 'package:flutter/material.dart';

import '../../../../core/themes/constants/dimensions.dart';

abstract final class LumosScreenFrameConst {
  LumosScreenFrameConst._();

  static const double defaultMaxWidth = WidgetSizes.maxContentWidth;
  static const double defaultHorizontalPadding = Insets.paddingScreen;
  static const double defaultVerticalPadding = Insets.gapBetweenSections;
}

class LumosScreenFrame extends StatelessWidget {
  const LumosScreenFrame({
    required this.child,
    super.key,
    this.maxWidth = LumosScreenFrameConst.defaultMaxWidth,
    this.baseHorizontalPadding = LumosScreenFrameConst.defaultHorizontalPadding,
    this.verticalPadding = LumosScreenFrameConst.defaultVerticalPadding,
  });

  final Widget child;
  final double maxWidth;
  final double baseHorizontalPadding;
  final double verticalPadding;

  @override
  Widget build(BuildContext context) {
    final double horizontalPadding = ResponsiveDimensions.adaptive(
      context: context,
      baseValue: baseHorizontalPadding,
    );
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            verticalPadding,
            horizontalPadding,
            verticalPadding,
          ),
          child: child,
        ),
      ),
    );
  }

  static double resolveHorizontalInset(
    BuildContext context, {
    double maxWidth = LumosScreenFrameConst.defaultMaxWidth,
    double baseHorizontalPadding = LumosScreenFrameConst.defaultHorizontalPadding,
  }) {
    final double horizontalPadding = ResponsiveDimensions.adaptive(
      context: context,
      baseValue: baseHorizontalPadding,
    );
    final double screenWidth = MediaQuery.sizeOf(context).width;
    if (screenWidth <= maxWidth) {
      return horizontalPadding;
    }
    return ((screenWidth - maxWidth) / 2) + horizontalPadding;
  }
}
