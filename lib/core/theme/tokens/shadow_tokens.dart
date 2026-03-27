import 'package:flutter/material.dart';

abstract final class ShadowTokens {
  static final List<BoxShadow> subtle = <BoxShadow>[
    const BoxShadow(
      color: Color(0x0D000000),
      blurRadius: 6,
      offset: Offset(0, 2),
    ),
  ];

  static final List<BoxShadow> medium = <BoxShadow>[
    const BoxShadow(
      color: Color(0x14000000),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];

  static final List<BoxShadow> high = <BoxShadow>[
    const BoxShadow(
      color: Color(0x1C000000),
      blurRadius: 18,
      offset: Offset(0, 8),
    ),
  ];
}
