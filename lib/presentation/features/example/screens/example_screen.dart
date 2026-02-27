import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/async_value_error_extensions.dart';
import '../../../../core/error/failures.dart';
import '../../../shared/widgets/lumos_widgets.dart';
import '../providers/example_provider.dart';
import '../providers/states/example_state.dart';
import 'example_content.dart';
import 'widgets/states/example_failure_view.dart';
import 'widgets/states/example_skeleton_view.dart';

class ExampleScreen extends ConsumerWidget {
  const ExampleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<ExampleState> exampleAsync = ref.watch(
      exampleAsyncControllerProvider,
    );
    return LumosScreenTransition(
      switchKey: ValueKey<String>('example-${exampleAsync.runtimeType}'),
      moveForward: true,
      child: exampleAsync.whenWithLoading(
        loadingBuilder: (BuildContext context) => const ExampleSkeletonView(),
        dataBuilder: (BuildContext context, ExampleState state) {
          return ExampleContent(state: state);
        },
        errorBuilder: (BuildContext context, Failure failure) {
          return ExampleFailureView(message: failure.message);
        },
      ),
    );
  }
}
