import 'package:flutter/material.dart';
import 'package:lumos/l10n/l10n.dart';
import 'package:lumos/presentation/shared/composites/states/lumos_error_state.dart';
import 'package:lumos/presentation/shared/layouts/lumos_scaffold.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_icon.dart';

class LumosMaintenanceScreen extends StatelessWidget {
  const LumosMaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LumosScaffold(
      title: context.l10n.maintenanceTitle,
      body: LumosErrorState(
        title: context.l10n.maintenanceTitle,
        message: context.l10n.maintenanceMessage,
        icon: LumosIcon(Icons.build_circle_outlined),
      ),
      constrainBody: true,
    );
  }
}
