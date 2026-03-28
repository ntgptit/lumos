import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';

class LumosLabel extends StatelessWidget {
  const LumosLabel({
    super.key,
    required this.text,
    this.style,
    this.color,
    this.maxLines = 1,
    this.overflow,
    this.textAlign,
    this.softWrap,
  });

  final String text;
  final TextStyle? style;
  final Color? color;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final bool? softWrap;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      softWrap: softWrap,
      style: (style ?? context.textTheme.labelMedium)?.copyWith(
        color: color ?? context.colorScheme.onSurfaceVariant,
      ),
    );
  }
}
