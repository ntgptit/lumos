import 'package:flutter/material.dart';

import '../providers/states/example_state.dart';
import 'widgets/blocks/example_header.dart';

class ExampleContent extends StatelessWidget {
  const ExampleContent({required this.state, super.key});

  final ExampleState state;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        ExampleHeader(title: state.title),
      ],
    );
  }
}
