import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lumos/core/enums/dialog_type.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/core/theme/tokens/tokens.dart';
import 'package:lumos/presentation/shared/primitives/text/lumos_text.dart';

class LumosAlertDialog extends StatelessWidget {
  const LumosAlertDialog({
    super.key,
    required this.title,
    this.content,
    this.type = DialogType.info,
    this.icon,
    this.actions,
    this.constraints,
  });

  final String title;
  final Widget? content;
  final DialogType type;
  final Widget? icon;
  final List<Widget>? actions;
  final BoxConstraints? constraints;

  static const String surfaceKey = 'lumos-alert-dialog-surface';

  @override
  Widget build(BuildContext context) {
    final List<Widget> resolvedActions = actions ?? const <Widget>[];
    return Dialog(
      insetPadding: _resolveInsetPadding(context),
      backgroundColor: _resolveBackgroundColor(context),
      surfaceTintColor: Colors.transparent,
      elevation: AppElevationTokens.level0,
      shape: RoundedRectangleBorder(
        borderRadius: context.shapes.dialog,
        side: BorderSide(color: context.colorScheme.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: constraints ?? _resolveConstraints(context),
        child: Material(
          key: const ValueKey<String>(surfaceKey),
          color: _resolveBackgroundColor(context),
          surfaceTintColor: Colors.transparent,
          child: Padding(
            padding: _resolveContentPadding(context),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (icon != null) ...[
                    Align(alignment: Alignment.center, child: icon!),
                    SizedBox(height: context.spacing.md),
                  ],
                  LumosText(
                    title,
                    style: LumosTextStyle.headlineSmall,
                    tone: LumosTextTone.primary,
                    align: TextAlign.center,
                    fontWeight: FontWeight.w700,
                  ),
                  if (content != null) ...[
                    SizedBox(height: context.spacing.lg),
                    content!,
                  ],
                  if (resolvedActions.isNotEmpty) ...[
                    SizedBox(height: context.spacing.xl),
                    _LumosDialogActions(actions: resolvedActions),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  EdgeInsets _resolveInsetPadding(BuildContext context) {
    final double inset = context.component.dialogPadding;
    return EdgeInsets.all(inset);
  }

  BoxConstraints _resolveConstraints(BuildContext context) {
    final EdgeInsets insetPadding = _resolveInsetPadding(context);
    final double availableWidth =
        MediaQuery.sizeOf(context).width - insetPadding.horizontal;
    final double safeAvailableWidth = math.max(0.0, availableWidth);
    final double dialogWidth = math.min(
      context.layout.dialogMaxWidth,
      safeAvailableWidth,
    );
    return BoxConstraints(minWidth: dialogWidth, maxWidth: dialogWidth);
  }

  EdgeInsets _resolveContentPadding(BuildContext context) {
    return EdgeInsets.fromLTRB(
      context.spacing.xl,
      context.spacing.lg,
      context.spacing.xl,
      context.spacing.xl,
    );
  }

  Color _resolveBackgroundColor(BuildContext context) {
    return switch (type) {
      DialogType.info => context.colorScheme.surfaceContainerHigh,
      DialogType.warning => context.colorScheme.surfaceContainerHigh,
      DialogType.error => context.colorScheme.surfaceContainerHigh,
      DialogType.confirm => context.colorScheme.surfaceContainerHigh,
    };
  }
}

class _LumosDialogActions extends StatelessWidget {
  const _LumosDialogActions({required this.actions});

  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final bool useStackedLayout = actions.length > 2;
    if (useStackedLayout) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildVerticalChildren(context),
      );
    }
    return Row(children: _buildHorizontalChildren(context));
  }

  List<Widget> _buildHorizontalChildren(BuildContext context) {
    final List<Widget> children = <Widget>[];
    for (int index = 0; index < actions.length; index++) {
      if (index > 0) {
        children.add(SizedBox(width: context.spacing.sm));
      }
      children.add(Expanded(child: actions[index]));
    }
    return children;
  }

  List<Widget> _buildVerticalChildren(BuildContext context) {
    final List<Widget> children = <Widget>[];
    for (int index = 0; index < actions.length; index++) {
      if (index > 0) {
        children.add(SizedBox(height: context.spacing.sm));
      }
      children.add(SizedBox(width: double.infinity, child: actions[index]));
    }
    return children;
  }
}
