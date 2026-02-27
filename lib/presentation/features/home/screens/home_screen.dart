import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/themes/constants/dimensions.dart';
import '../providers/home_provider.dart';
import 'widgets/blocks/home_navigation_scaffold.dart';

export '../constants/home_contract.dart'
    show HomeScreenKeys, HomeScreenSemantics;

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(homeControllerProvider);
    return HomeNavigationScaffold(
      deviceType: context.deviceType,
      useNavigationRail: context.deviceType != DeviceType.mobile,
    );
  }
}
