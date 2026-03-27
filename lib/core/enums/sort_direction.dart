enum SortDirection {
  asc,
  desc;

  bool get isAscending => this == SortDirection.asc;
  int get multiplier => isAscending ? 1 : -1;

  SortDirection get toggled {
    return isAscending ? SortDirection.desc : SortDirection.asc;
  }

  int applyToComparison(int comparison) => comparison * multiplier;
}
