import 'package:flutter/material.dart';

import '../../../../core/themes/constants/dimensions.dart';

class LumosLoadingIndicatorConst {
  const LumosLoadingIndicatorConst._();

  static const double defaultCircularSize = IconSizes.iconLarge;
  static const double defaultLinearHeight = Insets.spacing8;
}

class LumosLoadingIndicator extends StatelessWidget {
  const LumosLoadingIndicator({super.key, this.size, this.isLinear = false});

  final double? size;
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
    return LinearProgressIndicator(minHeight: indicatorHeight);
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
    return CircularProgressIndicator(
      strokeWidth: WidgetSizes.borderWidthRegular,
    );
  }
}
