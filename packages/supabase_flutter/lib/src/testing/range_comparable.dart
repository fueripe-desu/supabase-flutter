import 'package:supabase_flutter/src/testing/range_type.dart';

class RangeComparable<T> {
  RangeComparable({
    required this.lowerRange,
    required this.upperRange,
    required this.rangeType,
  });

  final T upperRange;
  final T lowerRange;
  final RangeDataType rangeType;

  final List<Type> supportedTypes = [int, double, DateTime];

  bool isInRange(dynamic value) {
    try {
      if (value is DateTime) {
        final lr = lowerRange as DateTime;
        final ur = upperRange as DateTime;

        final isInLowerRange = value.isAtSameMomentAs(lr) || value.isAfter(lr);
        final isInUpperRange = value.isAtSameMomentAs(ur) || value.isBefore(ur);

        return isInLowerRange && isInUpperRange;
      }

      return value >= lowerRange && value <= upperRange;
    } catch (err) {
      throw Exception('${value.runtimeType} is an unsupported type.');
    }
  }

  bool isAdjacent(RangeComparable<T> other) {
    // If ranges overlap, they cannot be adjacent
    if (overlaps(other)) {
      return false;
    }

    if (T == double) {
      final thisCast = this as RangeComparable<double>;
      final otherCast = other as RangeComparable<double>;

      return (thisCast.lowerRange - 0.1 == otherCast.upperRange) ||
          (thisCast.upperRange + 0.1 == otherCast.lowerRange);
    }

    if (T == DateTime) {
      final thisCast = this as RangeComparable<DateTime>;
      final otherCast = other as RangeComparable<DateTime>;

      late final Duration duration;

      if (rangeType == RangeDataType.date) {
        duration = const Duration(days: 1);
      } else {
        duration = const Duration(milliseconds: 1);
      }

      // Check for contiguous boundaries
      return ((thisCast.lowerRange.subtract(duration))
              .isAtSameMomentAs(otherCast.upperRange)) ||
          ((thisCast.upperRange.add(duration))
              .isAtSameMomentAs(otherCast.lowerRange));
    }

    final thisCast = this as RangeComparable<int>;
    final otherCast = other as RangeComparable<int>;

    return (thisCast.lowerRange - 1 == otherCast.upperRange) ||
        (thisCast.upperRange + 1 == otherCast.lowerRange);
  }

  bool overlaps(RangeComparable<T> other) {
    if (T == DateTime) {
      final otherCast = other as RangeComparable<DateTime>;
      final thisCast = this as RangeComparable<DateTime>;

      final lowerOverlaps =
          thisCast.lowerRange.isAtSameMomentAs(otherCast.upperRange) ||
              thisCast.lowerRange.isBefore(otherCast.upperRange);

      final upperOverlaps =
          thisCast.upperRange.isAtSameMomentAs(otherCast.lowerRange) ||
              thisCast.upperRange.isAfter(otherCast.lowerRange);

      return lowerOverlaps && upperOverlaps;
    }

    final otherCast = other as RangeComparable<num>;
    final thisCast = this as RangeComparable<num>;

    return thisCast.lowerRange <= otherCast.upperRange &&
        thisCast.upperRange >= otherCast.lowerRange;
  }

  bool operator >(RangeComparable other) => _compare(
        other: other,
        dateTimeFunc: (
          thisLowerRange,
          otherLowerRange,
          thisUpperRange,
          otherUpperRange,
        ) {
          if (thisLowerRange.isAtSameMomentAs(otherLowerRange)) {
            return thisUpperRange.isAfter(otherUpperRange);
          } else {
            return thisLowerRange.isAfter(otherLowerRange);
          }
        },
        compareFunc: (
          thisLowerRange,
          otherLowerRange,
          thisUpperRange,
          otherUpperRange,
        ) {
          if (thisLowerRange == otherLowerRange) {
            return thisUpperRange > otherUpperRange;
          } else {
            return thisLowerRange > otherLowerRange;
          }
        },
      );

  bool operator >=(RangeComparable other) => _compare(
        other: other,
        dateTimeFunc: (
          thisLowerRange,
          otherLowerRange,
          thisUpperRange,
          otherUpperRange,
        ) {
          if (thisLowerRange.isAtSameMomentAs(otherLowerRange)) {
            return thisUpperRange.isAtSameMomentAs(otherUpperRange) ||
                thisUpperRange.isAfter(otherUpperRange);
          } else {
            return thisLowerRange.isAfter(otherLowerRange);
          }
        },
        compareFunc: (
          thisLowerRange,
          otherLowerRange,
          thisUpperRange,
          otherUpperRange,
        ) {
          if (thisLowerRange == otherLowerRange) {
            return thisUpperRange >= otherUpperRange;
          } else {
            return thisLowerRange > otherLowerRange;
          }
        },
      );

  bool operator <(RangeComparable other) => _compare(
        other: other,
        dateTimeFunc: (
          thisLowerRange,
          otherLowerRange,
          thisUpperRange,
          otherUpperRange,
        ) {
          if (thisLowerRange.isAtSameMomentAs(otherLowerRange)) {
            return thisUpperRange.isBefore(otherUpperRange);
          } else {
            return thisLowerRange.isBefore(otherLowerRange);
          }
        },
        compareFunc: (
          thisLowerRange,
          otherLowerRange,
          thisUpperRange,
          otherUpperRange,
        ) {
          if (thisLowerRange == otherLowerRange) {
            return thisUpperRange < otherUpperRange;
          } else {
            return thisLowerRange < otherLowerRange;
          }
        },
      );

  bool operator <=(RangeComparable other) => _compare(
        other: other,
        dateTimeFunc: (
          thisLowerRange,
          otherLowerRange,
          thisUpperRange,
          otherUpperRange,
        ) {
          if (thisLowerRange.isAtSameMomentAs(otherLowerRange)) {
            return thisUpperRange.isAtSameMomentAs(otherUpperRange) ||
                thisUpperRange.isBefore(otherUpperRange);
          } else {
            return thisLowerRange.isBefore(otherLowerRange);
          }
        },
        compareFunc: (
          thisLowerRange,
          otherLowerRange,
          thisUpperRange,
          otherUpperRange,
        ) {
          if (thisLowerRange == otherLowerRange) {
            return thisUpperRange <= otherUpperRange;
          } else {
            return thisLowerRange < otherLowerRange;
          }
        },
      );

  @override
  bool operator ==(Object other) => _compare(
        other: other as RangeComparable,
        dateTimeFunc: (
          thisLowerRange,
          otherLowerRange,
          thisUpperRange,
          otherUpperRange,
        ) =>
            thisLowerRange.isAtSameMomentAs(otherLowerRange) &&
            thisUpperRange.isAtSameMomentAs(otherUpperRange),
        compareFunc: (
          thisLowerRange,
          otherLowerRange,
          thisUpperRange,
          otherUpperRange,
        ) =>
            thisLowerRange == otherLowerRange &&
            thisUpperRange == otherUpperRange,
      );

  @override
  int get hashCode => Object.hash(lowerRange, upperRange);

  bool _compare({
    required RangeComparable other,
    required bool Function(
      DateTime thisLowerRange,
      DateTime otherLowerRange,
      DateTime thisUpperRange,
      DateTime otherUpperRange,
    ) dateTimeFunc,
    required bool Function(
      dynamic thisLowerRange,
      dynamic otherLowerRange,
      dynamic thisUpperRange,
      dynamic otherUpperRange,
    ) compareFunc,
  }) {
    if (T == DateTime && other.lowerRange is DateTime) {
      return dateTimeFunc(
        this.lowerRange as DateTime,
        other.lowerRange as DateTime,
        this.upperRange as DateTime,
        other.upperRange as DateTime,
      );
    } else if (lowerRange.runtimeType == other.lowerRange.runtimeType) {
      return compareFunc(
        this.lowerRange,
        other.lowerRange,
        this.upperRange,
        other.upperRange,
      );
    }

    throw Exception(
      'Cannot compare two range types of different types',
    );
  }
}
