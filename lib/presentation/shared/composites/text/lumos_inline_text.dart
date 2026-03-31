import 'package:flutter/material.dart';
import 'package:lumos/presentation/shared/primitives/text/lumos_text.dart';

class LumosInlineText extends StatelessWidget {
  const LumosInlineText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.align,
    this.maxLines,
    this.overflow,
  });

  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextAlign? align;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return LumosText(
      text,
      style: style,
      textAlign: textAlign ?? align,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
