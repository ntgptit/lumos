import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../domain/entities/study/study_models.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../../../../shared/widgets/lumos_widgets.dart';
import '../../../../providers/study_speech_playback_provider.dart';
import '../study_session_sub_mode_const.dart';
import '../widgets/study_session_layout_metrics.dart';
import '../widgets/study_session_progress_row.dart';
import 'widgets/study_session_review_card_viewport.dart';

abstract final class StudySessionReviewContentConst {
  StudySessionReviewContentConst._();

  static const String reviewMode = StudySessionSubModeConst.reviewMode;
  static const String rememberedActionId = 'MARK_REMEMBERED';
  static const String retryActionId = 'RETRY_ITEM';
  static const String nextActionId = 'GO_NEXT';
  static const int previousPageIndex = 0;
  static const int currentPageIndex = 1;
  static const int nextPageIndex = 2;
  static const EdgeInsetsGeometry contentPadding = EdgeInsets.fromLTRB(
    LumosSpacing.lg,
    LumosSpacing.md,
    LumosSpacing.lg,
    LumosSpacing.xl,
  );
  static const EdgeInsetsGeometry progressPadding = EdgeInsets.symmetric(
    horizontal: LumosSpacing.md,
  );
  static const double sectionSpacing = LumosSpacing.lg;
}

class StudySessionReviewContent extends StatefulWidget {
  const StudySessionReviewContent({
    required this.session,
    required this.speechPlaybackState,
    required this.onActionPressed,
    required this.onPlaySpeech,
    required this.onReplaySpeech,
    super.key,
  });

  final StudySessionData session;
  final StudySpeechPlaybackState speechPlaybackState;
  final Future<void> Function(String) onActionPressed;
  final VoidCallback onPlaySpeech;
  final VoidCallback onReplaySpeech;

  @override
  State<StudySessionReviewContent> createState() =>
      _StudySessionReviewContentState();
}

class _StudySessionReviewContentState extends State<StudySessionReviewContent> {
  late PageController _pageController;
  bool _isPerformingSwipeAction = false;
  bool _isFirstCardMessageVisible = false;

  @override
  void initState() {
    super.initState();
    _pageController = _createPageController();
  }

  @override
  void didUpdateWidget(covariant StudySessionReviewContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_usesFirstCardPager(oldWidget.session) !=
        _usesFirstCardPager(widget.session)) {
      _replacePageController();
    }
    if (oldWidget.session.currentItem.flashcardId ==
        widget.session.currentItem.flashcardId) {
      return;
    }
    _isPerformingSwipeAction = false;
    _jumpToCurrentPage();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compactHeight = constraints.maxHeight < 760;
        final EdgeInsets contentPadding =
            StudySessionLayoutMetrics.contentPadding(
              context,
              top: compactHeight ? LumosSpacing.sm : LumosSpacing.md,
              bottom: compactHeight ? LumosSpacing.lg : LumosSpacing.xl,
            );
        final EdgeInsets progressPadding =
            StudySessionLayoutMetrics.progressPadding(
              context,
              horizontal: compactHeight ? LumosSpacing.sm : LumosSpacing.md,
            );
        final double sectionSpacing = StudySessionLayoutMetrics.sectionSpacing(
          context,
          baseValue: compactHeight
              ? LumosSpacing.md
              : StudySessionReviewContentConst.sectionSpacing,
        );
        return Padding(
          padding: contentPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: progressPadding,
                child: StudySessionProgressRow(
                  progressValue: widget.session.progress.sessionProgress,
                ),
              ),
              SizedBox(height: sectionSpacing),
              Expanded(
                child: StudySessionReviewCardViewport(
                  session: widget.session,
                  speechPlaybackState: widget.speechPlaybackState,
                  onPlaySpeech: widget.onPlaySpeech,
                  onReplaySpeech: widget.onReplaySpeech,
                  canSwipeHorizontally: _canSwipeHorizontally(),
                  controller: _pageController,
                  itemCount: _pagerItemCount,
                  currentPageIndex: _currentPageIndex,
                  onPageChanged: _handlePageChanged,
                  onLeadingEdgeAttempt: _handleLeadingEdgeAttempt,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handlePageChanged(int pageIndex) {
    unawaited(_processPageChanged(pageIndex));
  }

  void _jumpToCurrentPage() {
    if (!_pageController.hasClients) {
      return;
    }
    _pageController.jumpToPage(_currentPageIndex);
  }

  bool _canSwipeHorizontally() {
    return _actionForPage(StudySessionReviewContentConst.previousPageIndex) !=
            null ||
        _actionForPage(_nextPageIndex) != null;
  }

  Future<void> _processPageChanged(int pageIndex) async {
    final String? actionId = _actionForPage(pageIndex);
    if (actionId == null) {
      _jumpToCurrentPage();
      return;
    }
    if (_isPerformingSwipeAction) {
      return;
    }
    _isPerformingSwipeAction = true;
    _jumpToCurrentPage();
    try {
      await _submitSwipeAction(actionId);
    } finally {
      if (mounted) {
        _isPerformingSwipeAction = false;
        _jumpToCurrentPage();
      }
    }
  }

  String? _actionForPage(int pageIndex) {
    if (_isBackwardSwipeUnlocked &&
        pageIndex == StudySessionReviewContentConst.previousPageIndex) {
      if (_allowsAction(StudySessionReviewContentConst.retryActionId)) {
        return StudySessionReviewContentConst.retryActionId;
      }
      if (_allowsAction(StudySessionReviewContentConst.nextActionId)) {
        return StudySessionReviewContentConst.nextActionId;
      }
      return null;
    }
    if (pageIndex == _nextPageIndex) {
      if (_allowsAction(StudySessionReviewContentConst.rememberedActionId)) {
        return StudySessionReviewContentConst.rememberedActionId;
      }
      if (_allowsAction(StudySessionReviewContentConst.nextActionId)) {
        return StudySessionReviewContentConst.nextActionId;
      }
    }
    return null;
  }

  bool _allowsAction(String actionId) {
    return widget.session.allowedActions.contains(actionId);
  }

  Future<void> _submitSwipeAction(String actionId) async {
    await widget.onActionPressed(actionId);
    if (actionId == StudySessionReviewContentConst.nextActionId) {
      return;
    }
    await widget.onActionPressed(StudySessionReviewContentConst.nextActionId);
  }

  PageController _createPageController() {
    return PageController(initialPage: _currentPageIndex);
  }

  void _replacePageController() {
    final PageController previousController = _pageController;
    _pageController = _createPageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      previousController.dispose();
    });
  }

  bool _usesFirstCardPager(StudySessionData session) {
    return session.progress.completedItems == 0;
  }

  bool get _isBackwardSwipeUnlocked {
    return !_usesFirstCardPager(widget.session);
  }

  int get _currentPageIndex {
    if (_isBackwardSwipeUnlocked) {
      return StudySessionReviewContentConst.currentPageIndex;
    }
    return StudySessionReviewContentConst.previousPageIndex;
  }

  int get _nextPageIndex {
    if (_isBackwardSwipeUnlocked) {
      return StudySessionReviewContentConst.nextPageIndex;
    }
    return StudySessionReviewContentConst.currentPageIndex;
  }

  int get _pagerItemCount {
    return _nextPageIndex + 1;
  }

  void _handleLeadingEdgeAttempt() {
    if (_isBackwardSwipeUnlocked) {
      return;
    }
    _showFirstCardMessage();
  }

  void _showFirstCardMessage() {
    if (!mounted) {
      return;
    }
    if (_isFirstCardMessageVisible) {
      return;
    }
    final ScaffoldMessengerState? messenger = ScaffoldMessenger.maybeOf(
      context,
    );
    if (messenger == null) {
      return;
    }
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    _isFirstCardMessageVisible = true;
    final ScaffoldFeatureController<SnackBar, SnackBarClosedReason> controller =
        messenger.showSnackBar(
          LumosSnackbar(
            context: context,
            message: l10n.studyReviewFirstCardToast,
          ),
        );
    unawaited(
      controller.closed.then((_) {
        _isFirstCardMessageVisible = false;
      }),
    );
  }
}
