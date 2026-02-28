import 'package:flutter/material.dart';

abstract final class LumosTextConst {
  LumosTextConst._();

  static const LumosTextStyle defaultStyle = LumosTextStyle.bodyMedium;
  static const LumosTextTone defaultTone = LumosTextTone.auto;
  static const LumosTextContainerRole defaultContainerRole =
      LumosTextContainerRole.surface;
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

enum LumosTextTone { auto, primary, secondary }

enum LumosTextContainerRole {
  surface,
  primaryContainer,
  secondaryContainer,
  errorContainer,
  inverseSurface,
}

class LumosText extends StatelessWidget {
  const LumosText(
    this.text, {
    super.key,
    this.style = LumosTextConst.defaultStyle,
    this.tone = LumosTextConst.defaultTone,
    this.containerRole = LumosTextConst.defaultContainerRole,
    this.align,
    this.maxLines,
    this.overflow,
  });

  final String text;
  final LumosTextStyle style;
  final LumosTextTone tone;
  final LumosTextContainerRole containerRole;
  final TextAlign? align;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final TextStyle baseStyle = _resolveTextStyle(textTheme);
    final Color resolvedColor = _resolveColor(theme: theme);
    final TextStyle resolvedStyle = baseStyle.copyWith(color: resolvedColor);
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

  Color _resolveColor({required ThemeData theme}) {
    final ColorScheme colorScheme = theme.colorScheme;
    final LumosTextTone resolvedTone = _resolveTone();
    if (containerRole == LumosTextContainerRole.primaryContainer) {
      return colorScheme.onPrimaryContainer;
    }
    if (containerRole == LumosTextContainerRole.secondaryContainer) {
      return colorScheme.onSecondaryContainer;
    }
    if (containerRole == LumosTextContainerRole.errorContainer) {
      return colorScheme.onErrorContainer;
    }
    if (containerRole == LumosTextContainerRole.inverseSurface) {
      return colorScheme.onInverseSurface;
    }
    if (resolvedTone == LumosTextTone.primary) {
      return colorScheme.onSurface;
    }
    return colorScheme.onSurfaceVariant;
  }

  LumosTextTone _resolveTone() {
    if (tone != LumosTextTone.auto) {
      return tone;
    }
    if (_isPrimaryStyle()) {
      return LumosTextTone.primary;
    }
    return LumosTextTone.secondary;
  }

  bool _isPrimaryStyle() {
    if (style == LumosTextStyle.displayLarge) {
      return true;
    }
    if (style == LumosTextStyle.displayMedium) {
      return true;
    }
    if (style == LumosTextStyle.displaySmall) {
      return true;
    }
    if (style == LumosTextStyle.headlineLarge) {
      return true;
    }
    if (style == LumosTextStyle.headlineMedium) {
      return true;
    }
    if (style == LumosTextStyle.headlineSmall) {
      return true;
    }
    if (style == LumosTextStyle.titleLarge) {
      return true;
    }
    if (style == LumosTextStyle.titleMedium) {
      return true;
    }
    if (style == LumosTextStyle.titleSmall) {
      return true;
    }
    return false;
  }
}
