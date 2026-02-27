import 'package:flutter/material.dart';

import '../../../../core/themes/constants/dimensions.dart';
import '../lumos_models.dart';
import '../typography/lumos_text.dart';

class LumosMarkdownText extends StatelessWidget {
  const LumosMarkdownText({required this.data, super.key});

  final String data;

  @override
  Widget build(BuildContext context) {
    return SelectableText(data, style: Theme.of(context).textTheme.bodyMedium);
  }
}

class LumosAvatar extends StatelessWidget {
  const LumosAvatar({
    super.key,
    this.imageUrl,
    this.initials,
    this.radius = WidgetSizes.avatarMedium,
  });

  final String? imageUrl;
  final String? initials;
  final double radius;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null) {
      return CircleAvatar(
        radius: radius,
        child: Text(initials ?? '?', overflow: TextOverflow.ellipsis),
      );
    }
    return CircleAvatar(
      radius: radius,
      backgroundImage: NetworkImage(imageUrl!),
    );
  }
}

class LumosBadge extends StatelessWidget {
  const LumosBadge({required this.count, super.key});

  final int count;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Insets.spacing8,
        vertical: Insets.spacing4,
      ),
      decoration: BoxDecoration(
        color: colorScheme.error,
        borderRadius: BorderRadii.large,
      ),
      child: Text(
        '$count',
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.onError),
      ),
    );
  }
}

class LumosDivider extends StatelessWidget {
  const LumosDivider({
    super.key,
    this.label,
    this.thickness = WidgetSizes.borderWidthRegular,
    this.indent = Insets.spacing0,
  });

  final String? label;
  final double thickness;
  final double indent;

  @override
  Widget build(BuildContext context) {
    if (label == null) {
      return Divider(thickness: thickness, indent: indent);
    }
    return Row(
      children: <Widget>[
        Expanded(
          child: Divider(thickness: thickness, indent: indent),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Insets.spacing8),
          child: LumosText(label!, style: LumosTextStyle.labelSmall),
        ),
        Expanded(
          child: Divider(thickness: thickness, indent: indent),
        ),
      ],
    );
  }
}

class LumosNetworkImage extends StatelessWidget {
  const LumosNetworkImage({
    required this.imageUrl,
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder:
          (BuildContext context, Widget child, ImageChunkEvent? event) {
            if (event == null) {
              return child;
            }
            if (placeholder == null) {
              return const Center(child: CircularProgressIndicator());
            }
            return placeholder!;
          },
      errorBuilder:
          (BuildContext context, Object error, StackTrace? stackTrace) {
            if (errorWidget == null) {
              return const Icon(Icons.broken_image_outlined);
            }
            return errorWidget!;
          },
    );
  }
}

class LumosProgressRing extends StatelessWidget {
  const LumosProgressRing({
    required this.progress,
    required this.size,
    super.key,
    this.centerChild,
  });

  final double progress;
  final double size;
  final Widget? centerChild;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          CircularProgressIndicator(
            value: progress,
            strokeWidth: WidgetSizes.borderWidthRegular * Insets.spacing4,
          ),
          if (centerChild case final Widget child) child,
        ],
      ),
    );
  }
}

class LumosConfetti extends StatelessWidget {
  const LumosConfetti({
    required this.isActive,
    super.key,
    this.type = LumosConfettiType.simple,
  });

  final bool isActive;
  final LumosConfettiType type;

  @override
  Widget build(BuildContext context) {
    if (!isActive) {
      return const SizedBox.shrink();
    }
    return Icon(
      type == LumosConfettiType.full ? Icons.celebration : Icons.auto_awesome,
      size: IconSizes.iconXLarge,
      color: Theme.of(context).colorScheme.tertiary,
    );
  }
}

class LumosCountdownTimer extends StatelessWidget {
  const LumosCountdownTimer({
    required this.duration,
    required this.onComplete,
    super.key,
    this.autoStart = true,
  });

  final Duration duration;
  final ValueChanged<bool> onComplete;
  final bool autoStart;

  @override
  Widget build(BuildContext context) {
    if (!autoStart) {
      return _buildLabel(duration);
    }
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(
        begin: duration.inSeconds.toDouble(),
        end: Insets.spacing0,
      ),
      duration: duration,
      builder: (BuildContext context, double value, _) {
        if (value <= Insets.spacing0) {
          onComplete(true);
        }
        return _buildLabel(Duration(seconds: value.round()));
      },
    );
  }

  Widget _buildLabel(Duration value) {
    final int minutes = value.inMinutes;
    final int seconds = value.inSeconds % Duration.secondsPerMinute;
    return LumosText(
      '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
      style: LumosTextStyle.labelLarge,
    );
  }
}
