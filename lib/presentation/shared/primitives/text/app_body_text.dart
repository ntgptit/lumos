import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/presentation/shared/primitives/text/app_text.dart';

class AppBodyText extends StatelessWidget {
  const AppBodyText({
    super.key,
    required this.text,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.textDirection,
    this.locale,
    this.strutStyle,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.color,
    this.isSecondary = false,
  });

  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;
  final TextDirection? textDirection;
  final Locale? locale;
  final StrutStyle? strutStyle;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final Color? color;
  final bool isSecondary;

  @override
  Widget build(BuildContext context) {
    return AppText(
      text: text,
      style: context.textTheme.bodyLarge
          ?.copyWith(
            color:
                color ??
                (isSecondary
                    ? context.colorScheme.onSurfaceVariant
                    : context.colorScheme.onSurface),
          )
          .merge(style),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      textDirection: textDirection,
      locale: locale,
      strutStyle: strutStyle,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      color: color,
    );
  }
}
