import 'package:flutter/material.dart';

import '../../../../../shared/widgets/lumos_widgets.dart';

class HomeFailureView extends StatelessWidget {
  const HomeFailureView({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return LumosErrorState(errorMessage: message);
  }
}
