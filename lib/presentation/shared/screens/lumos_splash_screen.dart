import 'package:flutter/material.dart';
import 'package:lumos/l10n/l10n.dart';
import 'package:lumos/presentation/shared/layouts/lumos_scaffold.dart';
import 'package:lumos/presentation/shared/composites/states/lumos_loading_state.dart';

class LumosSplashScreen extends StatelessWidget {
  const LumosSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LumosScaffold(
      title: context.l10n.appName,
      body: LumosLoadingState(
        message: context.l10n.splashTitle,
        subtitle: context.l10n.loading,
      ),
      constrainBody: true,
    );
  }
}
