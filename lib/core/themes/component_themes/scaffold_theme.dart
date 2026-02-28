import 'package:flutter/material.dart';

abstract final class ScaffoldThemes {
  static Color backgroundColor({required ColorScheme colorScheme}) {
    return colorScheme.surface;
  }
}
