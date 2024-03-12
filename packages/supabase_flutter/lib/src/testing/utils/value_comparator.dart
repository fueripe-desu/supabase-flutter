import 'package:supabase_flutter/src/testing/range_type/range_type.dart';

class ValueComparator {
  int compareValues(dynamic value1, dynamic value2) {
    if (value1 is String && value2 is String) {
      return compareString(value1, value2);
    } else if (value1 is DateTime && value2 is DateTime) {
      return compareDateTime(value1, value2);
    } else if (value1 is bool && value2 is bool) {
      return compareBool(value1, value2);
    } else if (value1 is List && value2 is List) {
      return compareLists(value1, value2);
    } else if (value1 is Map && value2 is Map) {
      return compareMap(value1, value2);
    } else if (value1 is RangeType && value2 is RangeType) {
      return compareRange(value1, value2);
    } else {
      return value1.compareTo(value2);
    }
  }

  int compareString(String value1, String value2) => value1.compareTo(value2);

  int compareDateTime(DateTime value1, DateTime value2) {
    if (value1.isAfter(value2)) {
      return 1;
    } else if (value1.isAtSameMomentAs(value2)) {
      return 0;
    } else {
      return -1;
    }
  }

  int compareBool(bool value1, bool value2) {
    final integer1 = value1 ? 1 : 0;
    final integer2 = value2 ? 1 : 0;
    if (integer1 > integer2) {
      return 1;
    } else if (integer1 == integer2) {
      return 0;
    } else {
      return -1;
    }
  }

  int compareLists(List list1, List list2) {
    final minLength = list1.length < list2.length ? list1.length : list2.length;
    for (int i = 0; i < minLength; i++) {
      final baseValue = list1[i];
      final castValue = list2[i];

      final comparison = compareValues(baseValue, castValue);
      if (comparison != 0) {
        return comparison;
      }
    }
    return list1.length.compareTo(list2.length);
  }

  int compareMap(Map value1, Map value2) {
    final cast1 = value1.toString();
    final cast2 = value2.toString();

    return cast1.compareTo(cast2);
  }

  int compareRange(RangeType range1, RangeType range2) {
    final comparable1 = range1.getComparable();
    final comparable2 = range2.getComparable();

    if (comparable1 > comparable2) {
      return 1;
    } else if (comparable1 == comparable2) {
      return 0;
    } else {
      return -1;
    }
  }
}
