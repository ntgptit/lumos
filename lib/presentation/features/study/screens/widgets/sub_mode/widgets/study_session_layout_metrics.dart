import 'package:flutter/material.dart';

import '../../../../../../../core/themes/foundation/app_foundation.dart';

abstract final class StudySessionLayoutMetrics {
  StudySessionLayoutMetrics._();

  static const double denseHeightScale = 0.78;

  static EdgeInsets contentPadding(
    BuildContext context, {
    double horizontal = LumosSpacing.lg,
    double top = LumosSpacing.md,
    double bottom = LumosSpacing.xl,
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
    double horizontal = LumosSpacing.md,
  }) {
    return EdgeInsets.symmetric(horizontal: _sectionInset(context, horizontal));
  }

  static EdgeInsets cardPadding(
    BuildContext context, {
    double horizontal = LumosSpacing.xl,
    double vertical = LumosSpacing.xl,
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
    double top = LumosSpacing.lg,
    double right = LumosSpacing.lg,
  }) {
    return EdgeInsets.only(
      top: _sectionInset(context, top),
      right: _sectionInset(context, right),
    );
  }

  static EdgeInsets bottomTrailingPadding(
    BuildContext context, {
    double right = LumosSpacing.md,
    double bottom = LumosSpacing.md,
  }) {
    return EdgeInsets.only(
      right: _sectionInset(context, right),
      bottom: _sectionInset(context, bottom),
    );
  }

  static double sectionSpacing(
    BuildContext context, {
    double baseValue = LumosSpacing.lg,
  }) {
    return _sectionInset(context, baseValue);
  }

  static double actionSpacing(
    BuildContext context, {
    double baseValue = LumosSpacing.xl,
  }) {
    return _sectionInset(context, baseValue);
  }

  static double compactHeight(
    BuildContext context, {
    required double baseValue,
    double minScale = denseHeightScale,
  }) {
    return ResponsiveDimensions.compactValue(
      context: context,
      baseValue: baseValue,
      minScale: minScale,
    );
  }

  static double compactIcon(BuildContext context, {required double baseValue}) {
    return _sectionInset(context, baseValue);
  }

  static double _outerInset(BuildContext context, double baseValue) {
    return ResponsiveDimensions.compactValue(
      context: context,
      baseValue: baseValue,
      minScale: ResponsiveDimensions.compactOuterInsetScale,
    );
  }

  static double _bottomInset(BuildContext context, double baseValue) {
    return ResponsiveDimensions.compactValue(
      context: context,
      baseValue: baseValue,
      minScale: ResponsiveDimensions.compactVerticalInsetScale,
    );
  }

  static double _sectionInset(BuildContext context, double baseValue) {
    return ResponsiveDimensions.compactValue(
      context: context,
      baseValue: baseValue,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
  }

  static double _cardInset(BuildContext context, double baseValue) {
    return ResponsiveDimensions.compactValue(
      context: context,
      baseValue: baseValue,
      minScale: ResponsiveDimensions.compactLargeInsetScale,
    );
  }
}
