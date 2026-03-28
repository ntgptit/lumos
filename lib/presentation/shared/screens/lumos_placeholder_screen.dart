import 'package:flutter/material.dart';

import 'package:lumos/core/theme/extensions/theme_context_ext.dart';

class LumosPlaceholderScreen extends StatelessWidget {
  const LumosPlaceholderScreen({
    required this.title,
    this.message,
    this.actions = const <Widget>[],
    super.key,
  });

  final String title;
  final String? message;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(context.spacing.lg),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: context.layout.panelMaxWidth),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  title,
                  style: context.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                if (message != null) ...[
                  SizedBox(height: context.spacing.sm),
                  Text(
                    message!,
                    style: context.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
                if (actions.isNotEmpty) ...[
                  SizedBox(height: context.spacing.lg),
                  Wrap(
                    spacing: context.spacing.sm,
                    runSpacing: context.spacing.sm,
                    alignment: WrapAlignment.center,
                    children: actions,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
