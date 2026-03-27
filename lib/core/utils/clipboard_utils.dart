import 'package:flutter/services.dart';
import 'package:lumos/core/utils/string_utils.dart';

abstract final class ClipboardUtils {
  static Future<void> copy(String text) {
    return Clipboard.setData(ClipboardData(text: text));
  }

  static Future<void> copyIfHasText(String? text) {
    final value = StringUtils.trimmedOrNull(text);
    if (value == null) {
      return Future.value();
    }
    return copy(value);
  }

  static Future<String?> paste() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    return data?.text;
  }
}
