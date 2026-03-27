import '../../constants/text_styles.dart';

export '../../constants/text_styles.dart'
    show AppTextStyleConfig, AppTypographyConst, Material3TypeScaleConst;

abstract final class TypographyTokens {
  static String get defaultFontFamily => AppTypographyConst.kDefaultFontFamily;
  static List<String> get fallbackFonts => AppTypographyConst.kFallbackFonts;

  static AppTextStyleConfig get displayLarge =>
      AppTypographyConst.displayLargeStyle;
  static AppTextStyleConfig get displayMedium =>
      AppTypographyConst.displayMediumStyle;
  static AppTextStyleConfig get displaySmall =>
      AppTypographyConst.displaySmallStyle;

  static AppTextStyleConfig get headlineLarge =>
      AppTypographyConst.headlineLargeStyle;
  static AppTextStyleConfig get headlineMedium =>
      AppTypographyConst.headlineMediumStyle;
  static AppTextStyleConfig get headlineSmall =>
      AppTypographyConst.headlineSmallStyle;

  static AppTextStyleConfig get titleLarge =>
      AppTypographyConst.titleLargeStyle;
  static AppTextStyleConfig get titleMedium =>
      AppTypographyConst.titleMediumStyle;
  static AppTextStyleConfig get titleSmall =>
      AppTypographyConst.titleSmallStyle;

  static AppTextStyleConfig get bodyLarge => AppTypographyConst.bodyLargeStyle;
  static AppTextStyleConfig get bodyMedium =>
      AppTypographyConst.bodyMediumStyle;
  static AppTextStyleConfig get bodySmall => AppTypographyConst.bodySmallStyle;

  static AppTextStyleConfig get labelLarge =>
      AppTypographyConst.labelLargeStyle;
  static AppTextStyleConfig get labelMedium =>
      AppTypographyConst.labelMediumStyle;
  static AppTextStyleConfig get labelSmall =>
      AppTypographyConst.labelSmallStyle;
}
