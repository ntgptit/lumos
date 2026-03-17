import 'package:flutter/material.dart';

import '../../../../core/themes/foundation/app_foundation.dart';
import 'lumos_card.dart';

class LumosClickableCard extends StatelessWidget {
  const LumosClickableCard({
    required this.child,
    required this.onTap,
    super.key,
    this.onLongPress,
    this.padding = LumosCardConst.defaultPadding,
    this.margin,
    this.borderRadius,
    this.elevation,
    this.backgroundColor,
    this.variant = LumosCardVariant.elevated,
    this.isSelected = false,
    this.isLoading = false,
    this.deviceType = DeviceType.mobile,
  });

  final Widget child;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final double? elevation;
  final Color? backgroundColor;
  final LumosCardVariant variant;
  final bool isSelected;
  final bool isLoading;
  final DeviceType deviceType;

  @override
  Widget build(BuildContext context) {
    final DeviceType resolvedDeviceType = _resolveDeviceType(context);
    return LumosCard(
      onTap: onTap,
      onLongPress: onLongPress,
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      elevation: elevation,
      backgroundColor: backgroundColor,
      variant: variant,
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
