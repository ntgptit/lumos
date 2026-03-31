import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';

enum LumosTextStyle {
  labelSmall,
  labelMedium,
  labelLarge,
  bodySmall,
  bodyMedium,
  titleMedium,
  titleLarge,
  headlineSmall,
  headlineMedium,
}

enum LumosTextTone { primary, secondary }

enum LumosTextContainerRole { primaryContainer, errorContainer }

class LumosText<TStyle extends Object?> extends StatelessWidget {
  const LumosText(
    this.text, {
    super.key,
    this.style,
    this.tone,
    this.containerRole,
    this.textAlign,
    this.align,
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.textDirection,
    this.locale,
    this.strutStyle,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    this.color,
    this.fontWeight,
    this.height,
    this.inherit = true,
  });

  final String text;
  final TStyle? style;
  final LumosTextTone? tone;
  final LumosTextContainerRole? containerRole;
  final TextAlign? textAlign;
  final TextAlign? align;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;
  final TextDirection? textDirection;
  final Locale? locale;
  final StrutStyle? strutStyle;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final Color? selectionColor;
  final Color? color;
  final FontWeight? fontWeight;
  final double? height;
  final bool inherit;

  @override
  Widget build(BuildContext context) {
    final baseStyle = _resolveBaseStyle(context);
    final resolvedColor = color ?? _resolveColor(context);
    final resolvedStyle = baseStyle
        .copyWith(
          color: resolvedColor,
          fontWeight: fontWeight,
          height: height,
          inherit: inherit,
        )
        .merge(_resolveMergedStyle());

    return Text(
      text,
      style: resolvedStyle,
      textAlign: textAlign ?? align,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      textDirection: textDirection,
      locale: locale,
      strutStyle: strutStyle,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
    );
  }

  TextStyle _resolveBaseStyle(BuildContext context) {
    if (style is TextStyle) {
      return context.textTheme.bodyMedium ?? const TextStyle();
    }
    return switch (style as LumosTextStyle? ?? LumosTextStyle.bodyMedium) {
          LumosTextStyle.labelSmall => context.textTheme.labelSmall,
          LumosTextStyle.labelMedium => context.textTheme.labelMedium,
          LumosTextStyle.labelLarge => context.textTheme.labelLarge,
          LumosTextStyle.bodySmall => context.textTheme.bodySmall,
          LumosTextStyle.bodyMedium => context.textTheme.bodyMedium,
          LumosTextStyle.titleMedium => context.textTheme.titleMedium,
          LumosTextStyle.titleLarge => context.textTheme.titleLarge,
          LumosTextStyle.headlineSmall => context.textTheme.headlineSmall,
          LumosTextStyle.headlineMedium => context.textTheme.headlineMedium,
        } ??
        const TextStyle();
  }

  TextStyle? _resolveMergedStyle() {
    if (style is TextStyle) {
      return style as TextStyle;
    }
    return null;
  }

  Color? _resolveColor(BuildContext context) {
    if (containerRole == LumosTextContainerRole.primaryContainer) {
      return context.colorScheme.onPrimaryContainer;
    }
    if (containerRole == LumosTextContainerRole.errorContainer) {
      return context.colorScheme.onErrorContainer;
    }
    return switch (tone) {
      LumosTextTone.primary => context.colorScheme.onSurface,
      LumosTextTone.secondary => context.colorScheme.onSurfaceVariant,
      null => null,
    };
  }
}
