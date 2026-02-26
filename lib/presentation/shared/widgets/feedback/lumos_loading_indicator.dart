import 'package:flutter/material.dart';

import '../../../../core/constants/dimensions.dart';

class LumosLoadingIndicatorConst {
  const LumosLoadingIndicatorConst._();

  static const double defaultCircularSize = IconSizes.iconLarge;
  static const double defaultLinearHeight = Insets.spacing8;
}

class LumosLoadingIndicator extends StatelessWidget {
  const LumosLoadingIndicator({
    super.key,
    this.size,
    this.color,
    this.isLinear = false,
  });

  final double? size;
  final Color? color;
  final bool isLinear;

  @override
  Widget build(BuildContext context) {
    if (isLinear) {
      return _buildLinearIndicator();
    }
    return _buildCircularIndicator();
  }

  Widget _buildLinearIndicator() {
    final double indicatorHeight =
        size ?? LumosLoadingIndicatorConst.defaultLinearHeight;
    if (color == null) {
      return LinearProgressIndicator(minHeight: indicatorHeight);
    }
    return LinearProgressIndicator(
      minHeight: indicatorHeight,
      valueColor: AlwaysStoppedAnimation<Color>(color!),
    );
  }

  Widget _buildCircularIndicator() {
    final double indicatorSize =
        size ?? LumosLoadingIndicatorConst.defaultCircularSize;
    final Widget indicator = _buildCircularProgressIndicator();
    return SizedBox(
      width: indicatorSize,
      height: indicatorSize,
      child: indicator,
    );
  }

  Widget _buildCircularProgressIndicator() {
    if (color == null) {
      return CircularProgressIndicator(
        strokeWidth: WidgetSizes.borderWidthRegular,
      );
    }
    return CircularProgressIndicator(
      strokeWidth: WidgetSizes.borderWidthRegular,
      valueColor: AlwaysStoppedAnimation<Color>(color!),
    );
  }
}
