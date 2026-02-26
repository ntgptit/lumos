import 'package:flutter/material.dart';

import '../../../core/constants/dimensions.dart';

typedef ResponsiveWidgetBuilder =
    Widget Function(BuildContext context, DeviceType deviceType);

class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    required this.mobileBuilder,
    super.key,
    this.tabletBuilder,
    this.desktopBuilder,
  });

  final ResponsiveWidgetBuilder mobileBuilder;
  final ResponsiveWidgetBuilder? tabletBuilder;
  final ResponsiveWidgetBuilder? desktopBuilder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final DeviceType deviceType = constraints.deviceType;
        if (deviceType == DeviceType.desktop && desktopBuilder != null) {
          return desktopBuilder!.call(context, deviceType);
        }
        if (deviceType == DeviceType.tablet && tabletBuilder != null) {
          return tabletBuilder!.call(context, deviceType);
        }
        return mobileBuilder.call(context, deviceType);
      },
    );
  }
}
