import 'package:flutter/material.dart';

import '../../../core/themes/constants/dimensions.dart';

typedef ResponsiveWidgetBuilder =
    Widget Function(BuildContext context, DeviceType deviceType);

class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    required this.mobileBuilder,
    super.key,
    this.tabletBuilder,
    this.desktopBuilder,
    this.padding = Insets.screenPadding,
    this.applyPadding = true,
  });

  final ResponsiveWidgetBuilder mobileBuilder;
  final ResponsiveWidgetBuilder? tabletBuilder;
  final ResponsiveWidgetBuilder? desktopBuilder;
  final EdgeInsetsGeometry padding;
  final bool applyPadding;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final DeviceType deviceType = constraints.deviceType;
        final Widget body = _buildBody(
          context: context,
          deviceType: deviceType,
        );
        if (!applyPadding) {
          return body;
        }
        return Padding(padding: padding, child: body);
      },
    );
  }

  Widget _buildBody({
    required BuildContext context,
    required DeviceType deviceType,
  }) {
    if (deviceType == DeviceType.desktop && desktopBuilder != null) {
      return desktopBuilder!.call(context, deviceType);
    }
    if (deviceType == DeviceType.tablet && tabletBuilder != null) {
      return tabletBuilder!.call(context, deviceType);
    }
    return mobileBuilder.call(context, deviceType);
  }
}
