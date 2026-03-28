import 'package:flutter/material.dart';
import 'package:lumos/l10n/l10n.dart';
import 'package:lumos/presentation/shared/composites/states/lumos_offline_state.dart';
import 'package:lumos/presentation/shared/layouts/lumos_scaffold.dart';

class LumosOfflineScreen extends StatelessWidget {
  const LumosOfflineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LumosScaffold(
      title: context.l10n.offlineTitle,
      body: LumosOfflineState(message: context.l10n.offlineMessage),
      constrainBody: true,
    );
  }
}
