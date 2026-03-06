import 'package:flutter/material.dart';

import '../../../../core/themes/foundation/app_foundation.dart';
import 'lumos_card.dart';

abstract final class LumosSectionCardConst {
  LumosSectionCardConst._();

  static const EdgeInsetsGeometry defaultPadding = EdgeInsets.all(
    AppSpacing.lg,
  );
}

class LumosSectionCard extends StatelessWidget {
  const LumosSectionCard({
    required this.child,
    super.key,
    this.padding = LumosSectionCardConst.defaultPadding,
    this.margin,
    this.borderRadius,
    this.elevation,
    this.backgroundColor,
    this.variant = LumosCardVariant.filled,
    this.isLoading = false,
    this.deviceType = DeviceType.mobile,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final double? elevation;
  final Color? backgroundColor;
  final LumosCardVariant variant;
  final bool isLoading;
  final DeviceType deviceType;

  @override
  Widget build(BuildContext context) {
    return LumosCard(
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      elevation: elevation,
      backgroundColor: backgroundColor,
      variant: variant,
      isLoading: isLoading,
      deviceType: deviceType,
      child: child,
    );
  }
}
