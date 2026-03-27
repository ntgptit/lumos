import 'package:flutter/material.dart';

abstract final class ThemeHelpers {
  static ThemeData applyExtensions({
    required ThemeData theme,
    required Iterable<ThemeExtension<dynamic>> extensions,
  }) {
    final Map<Object, ThemeExtension<dynamic>> mergedExtensions =
        <Object, ThemeExtension<dynamic>>{};
    for (final ThemeExtension<dynamic> extension in theme.extensions.values) {
      mergedExtensions[extension.runtimeType] = extension;
    }
    for (final ThemeExtension<dynamic> extension in extensions) {
      mergedExtensions[extension.runtimeType] = extension;
    }
    return theme.copyWith(extensions: mergedExtensions.values);
  }
}
