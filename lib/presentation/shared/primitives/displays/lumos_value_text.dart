import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';

class LumosValueText extends StatelessWidget {
  const LumosValueText({
    super.key,
    required this.text,
    this.style,
    this.color,
    this.maxLines,
    this.overflow,
    this.textAlign,
  });

  final String text;
  final TextStyle? style;
  final Color? color;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      style: (style ?? context.textTheme.titleMedium)?.copyWith(
        color: color ?? context.colorScheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
