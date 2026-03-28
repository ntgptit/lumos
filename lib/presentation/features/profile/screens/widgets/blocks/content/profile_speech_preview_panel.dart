import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../../../core/utils/string_utils.dart';
import '../../../../../../../domain/entities/study/study_models.dart';
import '../../../../../../../l10n/app_localizations.dart';
import 'package:lumos/presentation/shared/composites/appbars/lumos_app_bar.dart';
import 'package:lumos/presentation/shared/composites/dialogs/lumos_action_sheet.dart';
import 'package:lumos/presentation/shared/composites/dialogs/lumos_dialog.dart';
import 'package:lumos/presentation/shared/composites/dialogs/lumos_prompt_dialog.dart';
import 'package:lumos/presentation/shared/composites/forms/lumos_search_bar.dart';
import 'package:lumos/presentation/shared/composites/forms/lumos_sort_bar.dart';
import 'package:lumos/presentation/shared/composites/lists/lumos_action_list_item.dart';
import 'package:lumos/presentation/shared/composites/lists/lumos_action_list_item_card.dart';
import 'package:lumos/presentation/shared/composites/states/lumos_empty_state.dart';
import 'package:lumos/presentation/shared/composites/states/lumos_error_state.dart';
import 'package:lumos/presentation/shared/composites/text/lumos_inline_text.dart';
import 'package:lumos/presentation/shared/layouts/lumos_screen_transition.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_floating_action_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_icon_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_outline_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_primary_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_secondary_button.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_card.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_icon.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_progress_bar.dart';
import 'package:lumos/presentation/shared/primitives/feedback/lumos_loading_indicator.dart';
import 'package:lumos/presentation/shared/primitives/feedback/lumos_snackbar.dart';
import 'package:lumos/presentation/shared/primitives/inputs/lumos_dropdown.dart';
import 'package:lumos/presentation/shared/primitives/inputs/lumos_text_field.dart';
import 'package:lumos/presentation/shared/primitives/layout/lumos_spacing.dart';
import 'package:lumos/presentation/shared/primitives/text/lumos_text.dart';
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
    final double titleGap = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.xs,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double sectionGap = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.md,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool stackButtons = constraints.maxWidth < 380;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            LumosText(
              l10n.profileSpeechPreviewTitle,
              style: LumosTextStyle.titleMedium,
            ),
            SizedBox(height: titleGap),
            LumosText(
              l10n.profileSpeechPreviewSubtitle,
              style: LumosTextStyle.bodyMedium,
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
                    final Widget playButton = LumosPrimaryButton(
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
                    );
                    final Widget stopButton = LumosOutlineButton(
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
                          SizedBox(height: sectionGap),
                          stopButton,
                        ],
                        if (!stackButtons)
                          Row(
                            children: <Widget>[
                              Expanded(child: playButton),
                              SizedBox(width: sectionGap),
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

