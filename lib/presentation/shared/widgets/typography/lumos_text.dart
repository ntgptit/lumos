import 'package:flutter/material.dart';

class LumosTextConst {
  const LumosTextConst._();

  static const LumosTextStyle defaultStyle = LumosTextStyle.bodyMedium;
}

enum LumosTextStyle {
  displayLarge,
  displayMedium,
  displaySmall,
  headlineLarge,
  headlineMedium,
  headlineSmall,
  titleLarge,
  titleMedium,
  titleSmall,
  bodyLarge,
  bodyMedium,
  bodySmall,
  labelLarge,
  labelMedium,
  labelSmall,
}

class LumosText extends StatelessWidget {
  const LumosText(
    this.text, {
    super.key,
    this.style = LumosTextConst.defaultStyle,
    this.align,
    this.color,
    this.maxLines,
    this.overflow,
  });

  final String text;
  final LumosTextStyle style;
  final TextAlign? align;
  final Color? color;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final TextStyle baseStyle = _resolveTextStyle(textTheme);
    final TextStyle resolvedStyle = _resolveColorOverride(baseStyle);
    return Text(
      text,
      style: resolvedStyle,
      textAlign: align,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  TextStyle _resolveTextStyle(TextTheme textTheme) {
    if (style == LumosTextStyle.displayLarge) {
      return textTheme.displayLarge ?? const TextStyle();
    }
    if (style == LumosTextStyle.displayMedium) {
      return textTheme.displayMedium ?? const TextStyle();
    }
    if (style == LumosTextStyle.displaySmall) {
      return textTheme.displaySmall ?? const TextStyle();
    }
    if (style == LumosTextStyle.headlineLarge) {
      return textTheme.headlineLarge ?? const TextStyle();
    }
    if (style == LumosTextStyle.headlineMedium) {
      return textTheme.headlineMedium ?? const TextStyle();
    }
    if (style == LumosTextStyle.headlineSmall) {
      return textTheme.headlineSmall ?? const TextStyle();
    }
    if (style == LumosTextStyle.titleLarge) {
      return textTheme.titleLarge ?? const TextStyle();
    }
    if (style == LumosTextStyle.titleMedium) {
      return textTheme.titleMedium ?? const TextStyle();
    }
    if (style == LumosTextStyle.titleSmall) {
      return textTheme.titleSmall ?? const TextStyle();
    }
    if (style == LumosTextStyle.bodyLarge) {
      return textTheme.bodyLarge ?? const TextStyle();
    }
    if (style == LumosTextStyle.bodySmall) {
      return textTheme.bodySmall ?? const TextStyle();
    }
    if (style == LumosTextStyle.labelLarge) {
      return textTheme.labelLarge ?? const TextStyle();
    }
    if (style == LumosTextStyle.labelMedium) {
      return textTheme.labelMedium ?? const TextStyle();
    }
    if (style == LumosTextStyle.labelSmall) {
      return textTheme.labelSmall ?? const TextStyle();
    }
    return textTheme.bodyMedium ?? const TextStyle();
  }

  TextStyle _resolveColorOverride(TextStyle baseStyle) {
    if (color == null) {
      return baseStyle;
    }
    return baseStyle.copyWith(color: color);
  }
}
