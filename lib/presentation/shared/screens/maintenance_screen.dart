import 'package:flutter/material.dart';
import 'package:lumos/l10n/l10n.dart';
import 'package:lumos/presentation/shared/composites/states/app_error_state.dart';
import 'package:lumos/presentation/shared/layouts/app_scaffold.dart';
import 'package:lumos/presentation/shared/primitives/displays/app_icon.dart';

class MaintenanceScreen extends StatelessWidget {
  const MaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: context.l10n.maintenanceTitle,
      body: AppErrorState(
        title: context.l10n.maintenanceTitle,
        message: context.l10n.maintenanceMessage,
        icon: AppIcon(Icons.build_circle_outlined),
      ),
      constrainBody: true,
    );
  }
}
