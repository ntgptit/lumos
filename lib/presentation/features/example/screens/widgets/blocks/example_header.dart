import 'package:flutter/material.dart';

import '../../../../../shared/widgets/lumos_widgets.dart';

class ExampleHeader extends StatelessWidget {
  const ExampleHeader({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return LumosCard(
      child: LumosText(title, style: LumosTextStyle.headlineSmall),
    );
  }
}
