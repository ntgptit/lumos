import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../core/utils/string_utils.dart';
import '../../../../../../../domain/entities/study/study_models.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../../../../shared/widgets/lumos_widgets.dart';
import '../../../../providers/profile_speech_preview_provider.dart';
import '../../../../providers/profile_speech_preview_state.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        LumosText(
          l10n.profileSpeechPreviewTitle,
          style: LumosTextStyle.titleMedium,
        ),
        const SizedBox(height: AppSpacing.xs),
        LumosText(
          l10n.profileSpeechPreviewSubtitle,
          style: LumosTextStyle.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.md),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: _previewTextController,
          builder: (BuildContext context, TextEditingValue value, Widget? child) {
            final bool canPlayPreview =
                StringUtils.normalizeName(value.text).isNotEmpty &&
                !previewState.isBusy &&
                !previewState.isPlaying;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                LumosTextField(
                  controller: _previewTextController,
                  label: l10n.profileSpeechPreviewTextLabel,
                  maxLines: 3,
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: LumosPrimaryButton(
                        label: l10n.profileSpeechPreviewPlayLabel,
                        icon: Icons.play_arrow_rounded,
                        isLoading: previewState.isBusy,
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
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: LumosOutlineButton(
                        label: l10n.profileSpeechPreviewStopLabel,
                        icon: Icons.stop_rounded,
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
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
