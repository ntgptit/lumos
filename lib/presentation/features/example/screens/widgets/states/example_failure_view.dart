import 'package:flutter/material.dart';

import '../../../../../shared/widgets/lumos_widgets.dart';

class ExampleFailureView extends StatelessWidget {
  const ExampleFailureView({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return LumosErrorState(errorMessage: message);
  }
}
