import 'package:flutter/foundation.dart';
import 'package:lumos/core/theme/responsive/screen_class.dart';
import 'package:lumos/core/theme/responsive/screen_info.dart';

@immutable
class AdaptiveLayout {
  const AdaptiveLayout({
    required this.pageHorizontalPadding,
    required this.pageVerticalPadding,
    required this.sectionGap,
    required this.gutter,
    required this.gridColumns,
    required this.useSplitView,
    required this.contentMaxWidth,
    required this.panelMaxWidth,
    required this.dialogMaxWidth,
    required this.flashcardMaxWidth,
    required this.studyContentMaxWidth,
    required this.resultDialogMaxWidth,
  });

  factory AdaptiveLayout.fromScreen(ScreenClass screenClass) {
    return switch (screenClass) {
      ScreenClass.compact => const AdaptiveLayout(
        pageHorizontalPadding: 20,
        pageVerticalPadding: 24,
        sectionGap: 24,
        gutter: 20,
        gridColumns: 1,
        useSplitView: false,
        contentMaxWidth: 560,
        panelMaxWidth: 480,
        dialogMaxWidth: 420,
        flashcardMaxWidth: 520,
        studyContentMaxWidth: 560,
        resultDialogMaxWidth: 420,
      ),
      ScreenClass.medium => const AdaptiveLayout(
        pageHorizontalPadding: 32,
        pageVerticalPadding: 32,
        sectionGap: 32,
        gutter: 28,
        gridColumns: 2,
        useSplitView: false,
        contentMaxWidth: 720,
        panelMaxWidth: 560,
        dialogMaxWidth: 520,
        flashcardMaxWidth: 620,
        studyContentMaxWidth: 720,
        resultDialogMaxWidth: 500,
      ),
      ScreenClass.expanded => const AdaptiveLayout(
        pageHorizontalPadding: 40,
        pageVerticalPadding: 40,
        sectionGap: 40,
        gutter: 32,
        gridColumns: 3,
        useSplitView: true,
        contentMaxWidth: 960,
        panelMaxWidth: 640,
        dialogMaxWidth: 560,
        flashcardMaxWidth: 680,
        studyContentMaxWidth: 900,
        resultDialogMaxWidth: 560,
      ),
      ScreenClass.large => const AdaptiveLayout(
        pageHorizontalPadding: 56,
        pageVerticalPadding: 48,
        sectionGap: 48,
        gutter: 40,
        gridColumns: 4,
        useSplitView: true,
        contentMaxWidth: 1120,
        panelMaxWidth: 720,
        dialogMaxWidth: 640,
        flashcardMaxWidth: 760,
        studyContentMaxWidth: 1040,
        resultDialogMaxWidth: 620,
      ),
    };
  }

  factory AdaptiveLayout.resolve(ScreenInfo screenInfo) {
    return AdaptiveLayout.fromScreen(screenInfo.screenClass);
  }

  final double pageHorizontalPadding;
  final double pageVerticalPadding;
  final double sectionGap;
  final double gutter;
  final int gridColumns;
  final bool useSplitView;
  final double contentMaxWidth;
  final double panelMaxWidth;
  final double dialogMaxWidth;
  final double flashcardMaxWidth;
  final double studyContentMaxWidth;
  final double resultDialogMaxWidth;
}
