import 'package:flutter/material.dart';

import '../../../../core/themes/foundation/app_foundation.dart';
import '../../../../core/themes/extensions/theme_extensions.dart';
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
    this.headerPadding = LumosSectionCardConst.defaultPadding,
    this.margin,
    this.borderRadius,
    this.elevation,
    this.backgroundColor,
    this.variant = LumosCardVariant.outlined,
    this.isLoading = false,
    this.deviceType = DeviceType.mobile,
    this.title,
    this.headerTrailing,
    this.header,
    this.showHeaderDivider = true,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry headerPadding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final double? elevation;
  final Color? backgroundColor;
  final LumosCardVariant variant;
  final bool isLoading;
  final DeviceType deviceType;
  final String? title;
  final Widget? headerTrailing;
  final Widget? header;
  final bool showHeaderDivider;

  @override
  Widget build(BuildContext context) {
    return LumosCard(
      padding: EdgeInsets.zero,
      margin: margin,
      borderRadius: borderRadius,
      elevation: elevation,
      backgroundColor: backgroundColor,
      variant: variant,
      isLoading: isLoading,
      deviceType: deviceType,
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final Widget? resolvedHeader = _buildHeader(context);
    if (resolvedHeader == null) {
      return Padding(padding: padding, child: child);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(padding: headerPadding, child: resolvedHeader),
        if (showHeaderDivider)
          const Divider(height: AppStroke.thin, thickness: AppStroke.thin),
        Padding(padding: padding, child: child),
      ],
    );
  }

  Widget? _buildHeader(BuildContext context) {
    final Widget? customHeader = header;
    if (customHeader != null) {
      return customHeader;
    }

    final String? resolvedTitle = title;
    if (resolvedTitle == null) {
      return null;
    }

    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            resolvedTitle,
            style: context.theme.textTheme.titleMedium,
          ),
        ),
        if (headerTrailing case final Widget trailing) ...<Widget>[
          const SizedBox(width: AppSpacing.md),
          trailing,
        ],
      ],
    );
  }
}
