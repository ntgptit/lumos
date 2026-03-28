import 'package:lumos/core/utils/string_utils.dart';

enum FilterOperator {
  equals(symbol: '=', label: 'Equals'),
  contains(symbol: '~', label: 'Contains'),
  greaterThan(symbol: '>', label: 'Greater than'),
  lessThan(symbol: '<', label: 'Less than');

  const FilterOperator({required this.symbol, required this.label});

  final String symbol;
  final String label;

  bool get isTextOperator {
    return this == FilterOperator.equals || this == FilterOperator.contains;
  }

  bool get isRangeOperator {
    return this == FilterOperator.greaterThan ||
        this == FilterOperator.lessThan;
  }

  static FilterOperator fromName(String? value) {
    final normalized = StringUtils.normalizedLowerOrNull(value);
    for (final operator in FilterOperator.values) {
      if (operator.name == normalized) {
        return operator;
      }
    }
    return FilterOperator.equals;
  }
}
