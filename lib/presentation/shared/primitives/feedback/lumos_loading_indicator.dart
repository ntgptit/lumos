import 'package:flutter/material.dart';

class LumosLoadingIndicator extends StatelessWidget {
  const LumosLoadingIndicator({
    super.key,
    this.size,
    this.isLinear = false,
  });

  final double? size;
  final bool isLinear;

  @override
  Widget build(BuildContext context) {
    if (isLinear) {
      return LinearProgressIndicator(minHeight: size);
    }
    return SizedBox.square(
      dimension: size,
      child: const CircularProgressIndicator(),
    );
  }
}
