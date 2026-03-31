import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../../../core/utils/string_utils.dart';
import '../../../../../../../domain/entities/study/study_models.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../../providers/profile_speech_preview_provider.dart';
import '../../../../providers/profile_speech_preview_state.dart';

abstract final class ProfileSpeechPreviewPanelConst {
  ProfileSpeechPreviewPanelConst._();

  static const double stackedActionWidthBreakpoint = 380;
}

class ProfileSpeechPreviewPanel extends ConsumerStatefulWidget {
  const ProfileSpeechPreviewPanel({required this.preference, super.key});

  final SpeechPreference preference;

  @override
  ConsumerState<ProfileSpeechPreviewPanel> createState() {
    return _ProfileSpeechPreviewPanelState();
  }
}

class _ProfileSpeechPreviewPanelState
    extends ConsumerState<ProfileSpeechPreviewPanel> {
  late final TextEditingController _previewTextController;
  bool _hasSeededDefaultText = false;

  @override
  void initState() {
    super.initState();
    _previewTextController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_hasSeededDefaultText) {
      return;
    }
    _previewTextController.text = AppLocalizations.of(
      context,
    )!.profileSpeechPreviewDefaultText;
    _hasSeededDefaultText = true;
  }

  @override
  void dispose() {
    _previewTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ProfileSpeechPreviewState previewState = ref.watch(
      profileSpeechPreviewControllerProvider,
    );
    ref.listen<ProfileSpeechPreviewState>(
      profileSpeechPreviewControllerProvider,
      (ProfileSpeechPreviewState? previous, ProfileSpeechPreviewState next) {
        if (previous?.errorMessage == next.errorMessage) {
          return;
        }
        if (next.errorMessage == null) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: LumosText(
              l10n.profileSpeechPreviewPlaybackError,
              style: LumosTextStyle.bodyMedium,
            ),
          ),
        );
        ref.read(profileSpeechPreviewControllerProvider.notifier).clearError();
      },
    );
    final double titleGap = context.compactValue(
      baseValue: context.spacing.xs,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double sectionGap = context.compactValue(
      baseValue: context.spacing.md,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double actionGap = context.compactValue(
      baseValue: context.spacing.sm,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool stackButtons = constraints.maxWidth <
            ProfileSpeechPreviewPanelConst.stackedActionWidthBreakpoint;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            LumosText(
              l10n.profileSpeechPreviewTitle,
              style: LumosTextStyle.labelLarge,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: titleGap),
            LumosText(
              l10n.profileSpeechPreviewSubtitle,
              style: LumosTextStyle.bodySmall,
            ),
            SizedBox(height: sectionGap),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _previewTextController,
              builder:
                  (
                    BuildContext context,
                    TextEditingValue value,
                    Widget? child,
                  ) {
                    final bool canPlayPreview =
                        StringUtils.normalizeText(value.text).isNotEmpty &&
                        !previewState.isBusy &&
                        !previewState.isPlaying;
                    final Widget playButton = LumosButton.primary(
                      text: l10n.profileSpeechPreviewPlayLabel,
                      leading: const LumosIcon(Icons.play_arrow_rounded),
                      isLoading: previewState.isBusy,
                      size: LumosButtonSize.medium,
                      onPressed: canPlayPreview
                          ? () {
                              unawaited(
                                ref
                                    .read(
                                      profileSpeechPreviewControllerProvider
                                          .notifier,
                                    )
                                    .play(
                                      preference: widget.preference,
                                      text: value.text,
                                    ),
                              );
                            }
                          : null,
                    );
                    final Widget stopButton = LumosButton.outline(
                      text: l10n.profileSpeechPreviewStopLabel,
                      leading: const LumosIcon(Icons.stop_rounded),
                      size: LumosButtonSize.medium,
                      onPressed: previewState.isBusy || previewState.isPlaying
                          ? () {
                              unawaited(
                                ref
                                    .read(
                                      profileSpeechPreviewControllerProvider
                                          .notifier,
                                    )
                                    .stop(),
                              );
                            }
                          : null,
                    );
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        LumosTextField(
                          controller: _previewTextController,
                          label: l10n.profileSpeechPreviewTextLabel,
                          maxLines: stackButtons ? 4 : 3,
                        ),
                        SizedBox(height: sectionGap),
                        if (stackButtons) ...<Widget>[
                          playButton,
                          SizedBox(height: actionGap),
                          stopButton,
                        ],
                        if (!stackButtons)
                          Row(
                            children: <Widget>[
                              Expanded(child: playButton),
                              SizedBox(width: actionGap),
                              Expanded(child: stopButton),
                            ],
                          ),
                      ],
                    );
                  },
            ),
          ],
        );
      },
    );
  }
}
