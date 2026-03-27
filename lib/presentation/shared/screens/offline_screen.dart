import 'package:flutter/material.dart';
import 'package:lumos/l10n/l10n.dart';
import 'package:lumos/presentation/shared/composites/states/app_offline_state.dart';
import 'package:lumos/presentation/shared/layouts/app_scaffold.dart';

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: context.l10n.offlineTitle,
      body: AppOfflineState(message: context.l10n.offlineMessage),
      constrainBody: true,
    );
  }
}
