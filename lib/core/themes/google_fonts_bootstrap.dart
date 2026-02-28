import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants/text_styles.dart';

abstract final class GoogleFontsBootstrapConst {
  static const Duration pendingTimeout = Duration(seconds: 20);
  static const List<String> requiredFontFamilies = <String>[
    AppTypographyConst.kDefaultFontFamily,
    AppTypographyConst.kGoogleFontInter,
    AppTypographyConst.kGoogleFontPoppins,
  ];
  static const String offlineMissingFontsMessage =
      'Google Fonts cache not found while device is offline. '
      'Please connect to the internet once to download required fonts.';
  static const String onlineFetchFailedMessage =
      'Unable to download required Google Fonts for offline use. '
      'Please retry when network is stable.';
}

class GoogleFontsBootstrapException implements Exception {
  const GoogleFontsBootstrapException({
    required this.message,
    required this.details,
  });

  final String message;
  final String details;

  @override
  String toString() {
    return '$message Details: $details';
  }
}

abstract final class AppGoogleFontsBootstrap {
  static Future<void> ensureFontsReady() async {
    GoogleFonts.config.allowRuntimeFetching = true;
    _queueRequiredFonts();

    try {
      await GoogleFonts.pendingFonts().timeout(
        GoogleFontsBootstrapConst.pendingTimeout,
      );
    } on Exception catch (error) {
      final bool hasNetwork = await _hasNetworkConnection();
      if (!hasNetwork) {
        throw GoogleFontsBootstrapException(
          message: GoogleFontsBootstrapConst.offlineMissingFontsMessage,
          details: error.toString(),
        );
      }
      throw GoogleFontsBootstrapException(
        message: GoogleFontsBootstrapConst.onlineFetchFailedMessage,
        details: error.toString(),
      );
    }

    GoogleFonts.config.allowRuntimeFetching = false;
  }

  static void _queueRequiredFonts() {
    for (final String family
        in GoogleFontsBootstrapConst.requiredFontFamilies) {
      GoogleFonts.getFont(
        family,
        fontWeight: AppTypographyConst.kFontWeightRegular,
      );
      GoogleFonts.getFont(
        family,
        fontWeight: AppTypographyConst.kFontWeightMedium,
      );
    }
  }

  static Future<bool> _hasNetworkConnection() async {
    try {
      final List<ConnectivityResult> connectivityResults = await Connectivity()
          .checkConnectivity();
      if (connectivityResults.isEmpty) {
        return false;
      }
      return connectivityResults.any(
        (ConnectivityResult result) => result != ConnectivityResult.none,
      );
    } on Exception {
      return false;
    }
  }
}
