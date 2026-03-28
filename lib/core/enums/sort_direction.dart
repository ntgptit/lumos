import 'package:lumos/core/utils/string_utils.dart';

abstract final class SortDirectionApiConst {
  SortDirectionApiConst._();

  static const String ascending = 'ASC';
  static const String descending = 'DESC';
}

enum SortDirection {
  asc,
  desc;

  bool get isAscending => this == SortDirection.asc;
  bool get isDescending => this == SortDirection.desc;
  int get multiplier => isAscending ? 1 : -1;
  String get apiValue {
    if (isDescending) {
      return SortDirectionApiConst.descending;
    }
    return SortDirectionApiConst.ascending;
  }

  SortDirection get toggled {
    return isAscending ? SortDirection.desc : SortDirection.asc;
  }

  int applyToComparison(int comparison) => comparison * multiplier;

  static SortDirection fromApiValue(String rawValue) {
    final String normalized = StringUtils.normalizeUpper(rawValue);
    if (normalized == SortDirectionApiConst.descending) {
      return SortDirection.desc;
    }
    return SortDirection.asc;
  }
}
