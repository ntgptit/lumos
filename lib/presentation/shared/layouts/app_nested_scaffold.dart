import 'package:flutter/material.dart';
import 'package:lumos/presentation/shared/primitives/layout/app_responsive_container.dart';

class AppNestedScaffold extends StatelessWidget {
  const AppNestedScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.backgroundColor,
    this.padding,
    this.maxBodyWidth,
    this.useSafeArea = true,
  });

  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final double? maxBodyWidth;
  final bool useSafeArea;

  @override
  Widget build(BuildContext context) {
    final content = AppResponsiveContainer(
      maxWidth: maxBodyWidth,
      constrainWidth: maxBodyWidth != null,
      padding: padding,
      child: body,
    );

    return Scaffold(
      appBar: appBar,
      backgroundColor: backgroundColor,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      body: useSafeArea ? SafeArea(child: content) : content,
    );
  }
}
