import 'package:flutter/material.dart';

import '../../../../core/themes/constants/dimensions.dart';
import '../../../../core/themes/extensions/theme_extensions.dart';
import '../lumos_models.dart';
import '../typography/lumos_text.dart';

class LumosInlineText extends StatelessWidget {
  const LumosInlineText(
    this.text, {
    super.key,
    this.style,
    this.align,
    this.maxLines,
    this.overflow,
  });

  final String text;
  final TextStyle? style;
  final TextAlign? align;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
      textAlign: align,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

class LumosIcon extends StatelessWidget {
  const LumosIcon(
    this.icon, {
    super.key,
    this.size,
    this.color,
    this.semanticLabel,
  });

  final IconData icon;
  final double? size;
  final Color? color;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Icon(icon, size: size, color: color, semanticLabel: semanticLabel);
  }
}

class LumosListTile extends StatelessWidget {
  const LumosListTile({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.contentPadding,
    this.enabled = true,
    this.selected = false,
    this.onTap,
  });

  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final EdgeInsetsGeometry? contentPadding;
  final bool enabled;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      contentPadding: contentPadding,
      enabled: enabled,
      selected: selected,
      onTap: onTap,
    );
  }
}

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
        style: theme.textTheme.labelSmall.withResolvedColor(
          colorScheme.onError,
        ),
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
