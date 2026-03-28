import 'package:flutter/material.dart';
import 'package:lumos/l10n/l10n.dart';
import 'package:lumos/presentation/shared/composites/states/lumos_empty_state.dart';
import 'package:lumos/presentation/shared/layouts/lumos_scaffold.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_icon.dart';

class LumosNotFoundScreen extends StatelessWidget {
  const LumosNotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LumosScaffold(
      title: context.l10n.notFoundTitle,
      body: LumosEmptyState(
        title: context.l10n.notFoundTitle,
        message: context.l10n.notFoundMessage,
        icon: LumosIcon(Icons.search_off_rounded),
      ),
      constrainBody: true,
    );
  }
}
