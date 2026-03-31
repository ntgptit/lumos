import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';

abstract final class StudySessionLayoutMetrics {
  StudySessionLayoutMetrics._();

  static const double denseHeightScale = 0.78;
  static const double compactBodyHeightBreakpoint = 760;
  static const double compactPanelHeightBreakpoint = 260;
  static const double compactActionWidthBreakpoint = 380;
  static const double narrowContentWidthBreakpoint = 360;
  static const double compactActionButtonWidthBreakpoint = 180;
  static const double compactContentWidthBreakpoint = 390;
  static const double reviewDeckWidthBreakpoint = 520;

  static EdgeInsets contentPadding(
    BuildContext context, {
    double horizontal =
        24,
    double top = 16,
    double bottom =
        32,
  }) {
    return EdgeInsets.fromLTRB(
      _outerInset(context, horizontal),
      _sectionInset(context, top),
      _outerInset(context, horizontal),
      _bottomInset(context, bottom),
    );
  }

  static EdgeInsets progressPadding(
    BuildContext context, {
    double horizontal =
        16,
  }) {
    return EdgeInsets.symmetric(horizontal: _sectionInset(context, horizontal));
  }

  static EdgeInsets cardPadding(
    BuildContext context, {
    double horizontal =
        32,
    double vertical =
        32,
  }) {
    return EdgeInsets.symmetric(
      horizontal: _cardInset(context, horizontal),
      vertical: _cardInset(context, vertical),
    );
  }

  static EdgeInsets cardInsets(
    BuildContext context, {
    required double left,
    required double top,
    required double right,
    required double bottom,
  }) {
    return EdgeInsets.fromLTRB(
      _cardInset(context, left),
      _cardInset(context, top),
      _cardInset(context, right),
      _cardInset(context, bottom),
    );
  }

  static EdgeInsets topTrailingPadding(
    BuildContext context, {
    double top = 24,
    double right =
        24,
  }) {
    return EdgeInsets.only(
      top: _sectionInset(context, top),
      right: _sectionInset(context, right),
    );
  }

  static EdgeInsets bottomTrailingPadding(
    BuildContext context, {
    double right =
        16,
    double bottom =
        16,
  }) {
    return EdgeInsets.only(
      right: _sectionInset(context, right),
      bottom: _sectionInset(context, bottom),
    );
  }

  static double sectionSpacing(
    BuildContext context, {
    double baseValue =
        24,
  }) {
    return _sectionInset(context, baseValue);
  }

  static double actionSpacing(
    BuildContext context, {
    double baseValue =
        32,
  }) {
    return _sectionInset(context, baseValue);
  }

  static double compactHeight(
    BuildContext context, {
    required double baseValue,
    double minScale = denseHeightScale,
  }) {
    return context.compactValue(
      baseValue: baseValue,
      minScale: minScale,
    );
  }

  static double compactIcon(BuildContext context, {required double baseValue}) {
    return _sectionInset(context, baseValue);
  }

  static double _outerInset(BuildContext context, double baseValue) {
    return context.compactValue(
      baseValue: baseValue,
      minScale: ResponsiveDimensions.compactOuterInsetScale,
    );
  }

  static double _bottomInset(BuildContext context, double baseValue) {
    return context.compactValue(
      baseValue: baseValue,
      minScale: ResponsiveDimensions.compactVerticalInsetScale,
    );
  }

  static double _sectionInset(BuildContext context, double baseValue) {
    return context.compactValue(
      baseValue: baseValue,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
  }

  static double _cardInset(BuildContext context, double baseValue) {
    return context.compactValue(
      baseValue: baseValue,
      minScale: ResponsiveDimensions.compactLargeInsetScale,
    );
  }
}
