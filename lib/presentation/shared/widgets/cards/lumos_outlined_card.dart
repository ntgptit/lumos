import 'package:flutter/material.dart';

import '../../../../core/themes/foundation/app_foundation.dart';
import 'lumos_card.dart';

class LumosOutlinedCard extends StatelessWidget {
  const LumosOutlinedCard({
    required this.child,
    super.key,
    this.padding = LumosCardConst.defaultPadding,
    this.margin,
    this.borderRadius,
    this.elevation,
    this.backgroundColor,
    this.isSelected = false,
    this.isLoading = false,
    this.deviceType = DeviceType.mobile,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final double? elevation;
  final Color? backgroundColor;
  final bool isSelected;
  final bool isLoading;
  final DeviceType deviceType;

  @override
  Widget build(BuildContext context) {
    final DeviceType resolvedDeviceType = _resolveDeviceType(context);
    return LumosCard(
      variant: LumosCardVariant.outlined,
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      elevation: elevation,
      backgroundColor: backgroundColor,
      isSelected: isSelected,
      isLoading: isLoading,
      deviceType: resolvedDeviceType,
      child: child,
    );
  }

  DeviceType _resolveDeviceType(BuildContext context) {
    if (deviceType != DeviceType.mobile) {
      return deviceType;
    }
    return context.deviceType;
  }
}
