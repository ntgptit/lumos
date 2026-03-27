import 'package:flutter/material.dart';
import 'package:lumos/l10n/l10n.dart';
import 'package:lumos/presentation/shared/composites/states/app_empty_state.dart';
import 'package:lumos/presentation/shared/layouts/app_scaffold.dart';
import 'package:lumos/presentation/shared/primitives/displays/app_icon.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: context.l10n.notFoundTitle,
      body: AppEmptyState(
        title: context.l10n.notFoundTitle,
        message: context.l10n.notFoundMessage,
        icon: AppIcon(Icons.search_off_rounded),
      ),
      constrainBody: true,
    );
  }
}
