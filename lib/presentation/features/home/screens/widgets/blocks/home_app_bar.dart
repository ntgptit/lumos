import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/lumos_widgets.dart';
import '../../../providers/home_provider.dart';
import '../../../providers/states/home_state.dart';
import '../../../extensions/home_tab_id_l10n_extension.dart';

class HomeAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final HomeTabId tabId = ref.watch(homeSelectedTabProvider);
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return LumosAppBar(
      title: tabId.toLocalizedLabel(l10n),
      actions: <Widget>[
        LumosIconButton(
          onPressed: () {},
          icon: Icons.notifications_none_rounded,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
