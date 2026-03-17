import 'package:flutter/material.dart';

import '../../../../core/themes/foundation/app_foundation.dart';
import '../../../../core/themes/extensions/theme_extensions.dart';
import '../../../../core/themes/semantic/app_color_tokens.dart';
import '../cards/lumos_card.dart';
import '../feedback/lumos_progress_bar.dart';
import '../lumos_models.dart';
import '../typography/lumos_text.dart';

class LumosSkillTree extends StatelessWidget {
  const LumosSkillTree({
    required this.nodes,
    required this.onNodeSelected,
    super.key,
    this.selectedNodeId,
  });

  final List<SkillNodeData> nodes;
  final ValueChanged<String> onNodeSelected;
  final String? selectedNodeId;

  @override
  Widget build(BuildContext context) {
    final double sectionSpacing = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: AppSpacing.sm,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: nodes.length,
      separatorBuilder: (BuildContext context, int index) =>
          SizedBox(height: sectionSpacing),
      itemBuilder: (BuildContext context, int index) {
        final SkillNodeData node = nodes[index];
        return LumosSkillNode(
          title: node.title,
          status: node.status,
          progress: node.progress,
          xpReward: node.xpReward,
          onTap: () {
            onNodeSelected(node.id);
          },
          isSelected: selectedNodeId == node.id,
        );
      },
    );
  }
}

class LumosSkillNode extends StatelessWidget {
  const LumosSkillNode({
    required this.title,
    required this.status,
    required this.onTap,
    super.key,
    this.progress,
    this.xpReward,
    this.isSelected = false,
  });

  final String title;
  final SkillNodeStatus status;
  final double? progress;
  final int? xpReward;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final double rowSpacing = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: AppSpacing.sm,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double iconSize = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: IconSizes.iconMedium,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    return LumosCard(
      onTap: onTap,
      isSelected: isSelected,
      child: Row(
        children: <Widget>[
          Icon(_resolveIcon(), size: iconSize, color: _resolveColor(context)),
          SizedBox(width: rowSpacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                LumosText(title, style: LumosTextStyle.titleSmall),
                ..._buildProgress(context),
              ],
            ),
          ),
          ..._buildXpReward(),
        ],
      ),
    );
  }

  IconData _resolveIcon() {
    if (status == SkillNodeStatus.locked) {
      return Icons.lock_outline;
    }
    if (status == SkillNodeStatus.completed) {
      return Icons.check_circle_outline;
    }
    if (status == SkillNodeStatus.mastered) {
      return Icons.workspace_premium_outlined;
    }
    return Icons.school_outlined;
  }

  Color _resolveColor(BuildContext context) {
    final AppColorTokens appColors = context.appColors;
    final ColorScheme colorScheme = context.colorScheme;
    if (status == SkillNodeStatus.locked) {
      return colorScheme.onSurfaceVariant;
    }
    if (status == SkillNodeStatus.completed) {
      return appColors.success;
    }
    if (status == SkillNodeStatus.mastered) {
      return colorScheme.primary;
    }
    return appColors.info;
  }

  List<Widget> _buildProgress(BuildContext context) {
    if (progress == null) {
      return const <Widget>[];
    }
    final double progressSpacing = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: AppSpacing.xs,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    return <Widget>[
      SizedBox(height: progressSpacing),
      LumosProgressBar(value: progress!),
    ];
  }

  List<Widget> _buildXpReward() {
    if (xpReward == null) {
      return const <Widget>[];
    }
    return <Widget>[
      LumosText('+${xpReward!} XP', style: LumosTextStyle.labelSmall),
    ];
  }
}

class LumosLessonCard extends StatelessWidget {
  const LumosLessonCard({
    required this.title,
    required this.xpValue,
    required this.isLocked,
    required this.onTap,
    super.key,
    this.subtitle,
    this.progress,
  });

  final String title;
  final String? subtitle;
  final int xpValue;
  final double? progress;
  final bool isLocked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final double sectionSpacing = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: AppSpacing.sm,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    return LumosCard(
      onTap: isLocked ? null : onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          LumosText(title, style: LumosTextStyle.titleMedium),
          ..._buildSubtitle(context),
          SizedBox(height: sectionSpacing),
          LumosText('$xpValue XP', style: LumosTextStyle.labelLarge),
          ..._buildProgress(context),
        ],
      ),
    );
  }

  List<Widget> _buildSubtitle(BuildContext context) {
    if (subtitle == null) {
      return const <Widget>[];
    }
    final double subtitleSpacing = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: AppSpacing.xs,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    return <Widget>[
      SizedBox(height: subtitleSpacing),
      LumosText(
        subtitle!,
        style: LumosTextStyle.bodySmall,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    ];
  }

  List<Widget> _buildProgress(BuildContext context) {
    if (progress == null) {
      return const <Widget>[];
    }
    final double progressSpacing = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: AppSpacing.sm,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    return <Widget>[
      SizedBox(height: progressSpacing),
      LumosProgressBar(value: progress!),
    ];
  }
}
