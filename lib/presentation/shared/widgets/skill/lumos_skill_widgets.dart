import 'package:flutter/material.dart';

import '../../../../core/themes/constants/dimensions.dart';
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
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: nodes.length,
      separatorBuilder: (BuildContext context, int index) =>
          const SizedBox(height: Insets.spacing8),
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
    return LumosCard(
      onTap: onTap,
      isSelected: isSelected,
      child: Row(
        children: <Widget>[
          Icon(
            _resolveIcon(),
            size: IconSizes.iconMedium,
            color: _resolveColor(context),
          ),
          const SizedBox(width: Insets.spacing8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                LumosText(title, style: LumosTextStyle.titleSmall),
                ..._buildProgress(),
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
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    if (status == SkillNodeStatus.locked) {
      return colorScheme.onSurfaceVariant;
    }
    if (status == SkillNodeStatus.completed) {
      return colorScheme.tertiary;
    }
    if (status == SkillNodeStatus.mastered) {
      return colorScheme.primary;
    }
    return colorScheme.secondary;
  }

  List<Widget> _buildProgress() {
    if (progress == null) {
      return const <Widget>[];
    }
    return <Widget>[
      const SizedBox(height: Insets.spacing4),
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
    return LumosCard(
      onTap: isLocked ? null : onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          LumosText(title, style: LumosTextStyle.titleMedium),
          ..._buildSubtitle(),
          const SizedBox(height: Insets.spacing8),
          LumosText('$xpValue XP', style: LumosTextStyle.labelLarge),
          ..._buildProgress(),
        ],
      ),
    );
  }

  List<Widget> _buildSubtitle() {
    if (subtitle == null) {
      return const <Widget>[];
    }
    return <Widget>[
      const SizedBox(height: Insets.spacing4),
      LumosText(
        subtitle!,
        style: LumosTextStyle.bodySmall,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    ];
  }

  List<Widget> _buildProgress() {
    if (progress == null) {
      return const <Widget>[];
    }
    return <Widget>[
      const SizedBox(height: Insets.spacing8),
      LumosProgressBar(value: progress!),
    ];
  }
}
