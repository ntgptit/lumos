import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/presentation/shared/primitives/text/lumos_text.dart';

class LumosLinkText extends StatelessWidget {
  const LumosLinkText({
    super.key,
    required this.text,
    this.onTap,
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
  });

  final String text;
  final VoidCallback? onTap;
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

  @override
  Widget build(BuildContext context) {
    final linkStyle = context.textTheme.bodyMedium?.copyWith(
      color: color ?? context.colorScheme.primary,
      decoration: TextDecoration.underline,
      decorationColor: color ?? context.colorScheme.primary,
    );

    return MouseRegion(
      cursor: onTap == null ? MouseCursor.defer : SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: LumosText(
          text,
          style: linkStyle?.merge(style),
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
          softWrap: softWrap,
          textDirection: textDirection,
          locale: locale,
          strutStyle: strutStyle,
          textWidthBasis: textWidthBasis,
          textHeightBehavior: textHeightBehavior,
          color: color ?? context.colorScheme.primary,
        ),
      ),
    );
  }
}
