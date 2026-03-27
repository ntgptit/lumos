import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'adaptive_component_size.dart';
import 'adaptive_spacing.dart';
import 'breakpoints.dart';
import 'screen_info.dart';

@immutable
final class AdaptiveLayout {
  const AdaptiveLayout({
    required this.maxContentWidth,
    required this.gutter,
    required this.columns,
    required this.dialogMaxWidth,
    required this.overlayMaxWidth,
    required this.horizontalPadding,
    required this.isSplitView,
  });

  factory AdaptiveLayout.fromScreenInfo({
    required ScreenInfo screenInfo,
    required AdaptiveSpacing spacing,
    required AdaptiveComponentSize componentSize,
  }) {
    final bool isSplitView = screenInfo.width >= Breakpoints.kTabletMaxWidth;
    final int columns = switch (screenInfo.screenClass) {
      _ when screenInfo.isCompact => 4,
      _ when screenInfo.isMedium => 8,
      _ => 12,
    };
    final double overlayMaxWidth = switch (screenInfo.screenClass) {
      _ when screenInfo.isCompact => screenInfo.width,
      _ when screenInfo.isMedium => componentSize.overlayMaxWidthTablet,
      _ => componentSize.overlayMaxWidthDesktop,
    };
    return AdaptiveLayout(
      maxContentWidth: math.min(
        screenInfo.width,
        componentSize.maxContentWidth,
      ),
      gutter: switch (screenInfo.screenClass) {
        _ when screenInfo.isCompact => spacing.lg,
        _ when screenInfo.isMedium => spacing.xxl,
        _ => spacing.xxxl,
      },
      columns: columns,
      dialogMaxWidth: math.min(
        screenInfo.width,
        componentSize.dialogMinWidth * 1.6,
      ),
      overlayMaxWidth: overlayMaxWidth,
      horizontalPadding: switch (screenInfo.screenClass) {
        _ when screenInfo.isCompact => spacing.lg,
        _ when screenInfo.isMedium => spacing.xxl,
        _ => spacing.page,
      },
      isSplitView: isSplitView,
    );
  }

  final double maxContentWidth;
  final double gutter;
  final int columns;
  final double dialogMaxWidth;
  final double overlayMaxWidth;
  final double horizontalPadding;
  final bool isSplitView;

  AdaptiveLayout copyWith({
    double? maxContentWidth,
    double? gutter,
    int? columns,
    double? dialogMaxWidth,
    double? overlayMaxWidth,
    double? horizontalPadding,
    bool? isSplitView,
  }) {
    return AdaptiveLayout(
      maxContentWidth: maxContentWidth ?? this.maxContentWidth,
      gutter: gutter ?? this.gutter,
      columns: columns ?? this.columns,
      dialogMaxWidth: dialogMaxWidth ?? this.dialogMaxWidth,
      overlayMaxWidth: overlayMaxWidth ?? this.overlayMaxWidth,
      horizontalPadding: horizontalPadding ?? this.horizontalPadding,
      isSplitView: isSplitView ?? this.isSplitView,
    );
  }
}
