// ignore_for_file: library_private_types_in_public_api

import 'package:supabase_flutter/src/testing/range_type/range_comparable.dart';
import 'package:supabase_flutter/src/testing/supabase_test_error_messages.dart';
import 'package:supabase_flutter/src/testing/supabase_test_exceptions.dart';
import 'package:supabase_flutter/src/testing/supabase_test_extensions.dart';

enum RangeDataType { integer, float, date, timestamp, timestamptz }

abstract class RangeType {
  const RangeType({
    required this.lowerRangeInclusive,
    required this.upperRangeInclusive,
    required this.isLowerBoundInfinite,
    required this.isUpperBoundInfinite,
    required this.rangeDataType,
    required this.rawRangeString,
    required this.isEmpty,
  });

  factory RangeType._createFromDataType({
    dynamic upperRange,
    dynamic lowerRange,
    required bool lowerRangeInclusive,
    required bool upperRangeInclusive,
    required bool isLowerBoundInfinite,
    required bool isUpperBoundInfinite,
    required RangeDataType rangeDataType,
    required String rawRangeString,
    required bool isEmpty,
  }) {
    switch (rangeDataType) {
      case RangeDataType.integer:
        return IntegerRangeType(
          lowerRange: lowerRange,
          upperRange: upperRange,
          lowerRangeInclusive: lowerRangeInclusive,
          upperRangeInclusive: upperRangeInclusive,
          isLowerBoundInfinite: isLowerBoundInfinite,
          isUpperBoundInfinite: isUpperBoundInfinite,
          rangeDataType: rangeDataType,
          rawRangeString: rawRangeString,
          isEmpty: isEmpty,
        );
      case RangeDataType.float:
        return FloatRangeType(
          lowerRange: lowerRange,
          upperRange: upperRange,
          lowerRangeInclusive: lowerRangeInclusive,
          upperRangeInclusive: upperRangeInclusive,
          isLowerBoundInfinite: isLowerBoundInfinite,
          isUpperBoundInfinite: isUpperBoundInfinite,
          rangeDataType: rangeDataType,
          rawRangeString: rawRangeString,
          isEmpty: isEmpty,
        );
      case RangeDataType.date:
      case RangeDataType.timestamp:
      case RangeDataType.timestamptz:
        return DateRangeType.adjustPrecision(
          lowerRange: lowerRange,
          upperRange: upperRange,
          lowerRangeInclusive: lowerRangeInclusive,
          upperRangeInclusive: upperRangeInclusive,
          isLowerBoundInfinite: isLowerBoundInfinite,
          isUpperBoundInfinite: isUpperBoundInfinite,
          rangeDataType: rangeDataType,
          rawRangeString: rawRangeString,
          isEmpty: isEmpty,
        );
    }
  }

  factory RangeType.createRange(
      {required String range, RangeDataType? forceType}) {
    try {
      if (forceType != null && range.isEmpty) {
        return RangeType._createFromDataType(
          lowerRangeInclusive: false,
          upperRangeInclusive: false,
          isLowerBoundInfinite: false,
          isUpperBoundInfinite: false,
          rangeDataType: forceType,
          rawRangeString: '',
          isEmpty: true,
        );
      }

      final (firstValue, secondValue) = _getValuePair(range);
      final (isLowerBoundInfinite, isUpperBoundInfinite) = _areBoundsInfinite(
        range,
      );
      final (lowerRangeInclusive, upperRangeInclusive) = _getInclusivity(
        range,
        firstValueNull: firstValue.isEmpty,
        secondValueNull: secondValue.isEmpty,
      );

      final firstBracket = lowerRangeInclusive ? '[' : '(';
      final lastBracket = upperRangeInclusive ? ']' : ')';

      // This needs to be done, because the _getValuePair() method returns
      // infinity as if it was null, therefore we need to convert it back
      // in the rawRangeString
      final rawLowerBound = isLowerBoundInfinite ? '-infinity' : firstValue;
      final rawUpperBound = isUpperBoundInfinite ? 'infinity' : secondValue;

      final rawRangeString =
          "$firstBracket$rawLowerBound,$rawUpperBound$lastBracket";

      if (forceType != null) {
        late final dynamic firstValueParsed;
        late final dynamic secondValueParsed;
        late final Function parseFunction;

        switch (forceType) {
          case RangeDataType.integer:
            parseFunction = int.parse;
            break;
          case RangeDataType.float:
            parseFunction = double.parse;
            break;
          case RangeDataType.date:
          case RangeDataType.timestamp:
          case RangeDataType.timestamptz:
            parseFunction = DateTime.parse;
            break;
        }

        firstValueParsed =
            firstValue.isNotEmpty ? parseFunction(firstValue) : null;
        secondValueParsed =
            secondValue.isNotEmpty ? parseFunction(secondValue) : null;

        if (!_isValidRangeBounds(firstValueParsed, secondValueParsed)) {
          throw RangeTypeException(
            RangeTypeErrors.invalidBoundError,
          );
        }

        return RangeType._createFromDataType(
          lowerRange: firstValueParsed,
          upperRange: secondValueParsed,
          lowerRangeInclusive: lowerRangeInclusive,
          upperRangeInclusive: upperRangeInclusive,
          isLowerBoundInfinite: isLowerBoundInfinite,
          isUpperBoundInfinite: isUpperBoundInfinite,
          rangeDataType: forceType,
          rawRangeString: rawRangeString,
          isEmpty: range.isEmpty,
        );
      }

      final firstType = _inferValueType(firstValue);
      final secondType = _inferValueType(secondValue);

      if (firstType == null && secondType == null) {
        throw RangeTypeException(
          RangeTypeErrors.bothBoundsNullError,
        );
      }

      if (isLowerBoundInfinite && isUpperBoundInfinite) {
        throw RangeTypeException(
          RangeTypeErrors.bothBoundsInfiniteError,
        );
      }

      if (firstType != null && secondType != null) {
        if (firstType.runtimeType != secondType.runtimeType) {
          throw RangeTypeException(
            RangeTypeErrors.typeMismatchError(
              firstType.runtimeType,
              secondType.runtimeType,
            ),
          );
        }
      }

      final typeValue = firstType ?? secondType;
      late final RangeDataType rangeDataType;

      if (typeValue is int) {
        rangeDataType = RangeDataType.integer;
      }
      if (typeValue is double) {
        rangeDataType = RangeDataType.float;
      }

      if (typeValue is DateTime) {
        final dataType1 = _getDataTypeFromTimestamp(firstValue);
        final dataType2 = _getDataTypeFromTimestamp(secondValue);

        if (dataType1 != null && dataType2 != null) {
          if (dataType1 != dataType2) {
            throw RangeTypeException(
              RangeTypeErrors.datetimePrecisionError,
            );
          }
        }

        rangeDataType = (dataType1 ?? dataType2)!;
      }

      if (!_isValidRangeBounds(firstType, secondType)) {
        throw RangeTypeException(
          RangeTypeErrors.invalidBoundError,
        );
      }

      return RangeType._createFromDataType(
        lowerRange: firstType,
        upperRange: secondType,
        lowerRangeInclusive: lowerRangeInclusive,
        upperRangeInclusive: upperRangeInclusive,
        isLowerBoundInfinite: isLowerBoundInfinite,
        isUpperBoundInfinite: isUpperBoundInfinite,
        rangeDataType: rangeDataType,
        rawRangeString: rawRangeString,
        isEmpty: false,
      );
    } catch (err) {
      rethrow;
    }
  }

  final bool lowerRangeInclusive;
  final bool upperRangeInclusive;
  final bool isLowerBoundInfinite;
  final bool isUpperBoundInfinite;
  final RangeDataType rangeDataType;
  final String rawRangeString;

  final bool isEmpty;

  bool isInRange(dynamic value) {
    if (isEmpty) {
      return false;
    }

    return getComparable().isInRange(value);
  }

  bool isAdjacent(RangeType other) {
    if (isEmpty || other.isEmpty) {
      return false;
    }

    if (rangeDataType != other.rangeDataType) {
      throw RangeTypeException(
        RangeTypeErrors.adjacencyTypeError,
      );
    }

    return getComparable().isAdjacent(other.getComparable());
  }

  bool overlaps(RangeType other) {
    if (isEmpty || other.isEmpty) {
      return false;
    }

    if (rangeDataType != other.rangeDataType) {
      throw RangeTypeException(
        RangeTypeErrors.overlapTypeError,
      );
    }

    return getComparable().overlaps(other.getComparable());
  }

  bool strictlyLeftOf(RangeType other) {
    if (isEmpty || other.isEmpty) {
      return false;
    }

    if (rangeDataType != other.rangeDataType) {
      throw RangeTypeException(
        'Cannot check if a range of different type is strictly left of another',
      );
    }

    return getComparable().strictlyLeftOf(other.getComparable());
  }

  bool strictlyRightOf(RangeType other) {
    if (isEmpty || other.isEmpty) {
      return false;
    }

    if (rangeDataType != other.rangeDataType) {
      throw RangeTypeException(
        'Cannot check if a range of different type is strictly left of another',
      );
    }

    return getComparable().strictlyRightOf(other.getComparable());
  }

  bool doesNotExtendToTheLeftOf(RangeType other) {
    if (isEmpty || other.isEmpty) {
      return false;
    }

    if (rangeDataType != other.rangeDataType) {
      throw RangeTypeException(
        'Cannot check if a range of different type is strictly left of another',
      );
    }

    return getComparable().doesNotExtendToTheLeftOf(other.getComparable());
  }

  bool doesNotExtendToTheRightOf(RangeType other) {
    if (isEmpty || other.isEmpty) {
      return false;
    }

    if (rangeDataType != other.rangeDataType) {
      throw RangeTypeException(
        'Cannot check if a range of different type is strictly left of another',
      );
    }

    return getComparable().doesNotExtendToTheRightOf(other.getComparable());
  }

  bool operator >(RangeType other) => isEmpty || other.isEmpty
      ? false
      : getComparable() > other.getComparable();
  bool operator >=(RangeType other) => isEmpty || other.isEmpty
      ? false
      : getComparable() >= other.getComparable();
  bool operator <(RangeType other) => isEmpty || other.isEmpty
      ? false
      : getComparable() < other.getComparable();
  bool operator <=(RangeType other) => isEmpty || other.isEmpty
      ? false
      : getComparable() <= other.getComparable();

  // This must be implemented in the class, because it's type specific
  RangeComparable getComparable();

  @override
  String toString() => rawRangeString;

  @override
  bool operator ==(Object other);

  @override
  int get hashCode;

  static bool _isValidRangeBounds(dynamic lowerBound, dynamic upperBound) {
    if (lowerBound == null || upperBound == null) {
      return true;
    }

    if (lowerBound is DateTime?) {
      return lowerBound!.isBefore(upperBound) ||
          lowerBound.isAtSameMomentAs(upperBound);
    }

    return lowerBound <= upperBound;
  }

  static (bool, bool) _getInclusivity(
    String range, {
    bool firstValueNull = false,
    bool secondValueNull = false,
  }) {
    if (range.isEmpty) {
      return (false, false);
    }

    if (range.length < 2) {
      throw RangeTypeException(
        RangeTypeErrors.rangeLengthError,
      );
    }

    // Retrives and checks if the range strings have the correct brackets
    final firstBracket = range[0];
    final lastBracket = range[range.length - 1];

    if (!['[', '('].contains(firstBracket)) {
      throw RangeTypeException(
        RangeTypeErrors.firstBracketError,
      );
    }

    if (![']', ')'].contains(lastBracket)) {
      throw RangeTypeException(
        RangeTypeErrors.lastBracketError,
      );
    }

    late final bool lowerRangeInclusive;
    late final bool upperRangeInclusive;

    // Converts unspecified boundaries to exclusive
    if (firstValueNull) {
      lowerRangeInclusive = false;
    } else {
      lowerRangeInclusive = firstBracket == '[' ? true : false;
    }

    if (secondValueNull) {
      upperRangeInclusive = false;
    } else {
      upperRangeInclusive = lastBracket == ']' ? true : false;
    }

    return (lowerRangeInclusive, upperRangeInclusive);
  }

  static (String, String) _getValuePair(String range) {
    final valuePair = range.removeBrackets().split(',').trimAll();

    if (valuePair.length != 2) {
      throw RangeTypeException(
        RangeTypeErrors.thirdBoundError,
      );
    }

    // Returns as if it was null, in case one of the values is infinity
    // because infinity is treated the same as an unspecified bound
    // the only thing that changes is when you directly compare one range
    // to the other, because infinity != null, infinity is treated later
    // by the _areBoundsInfinite() method
    final lowerValue =
        ['-infinity', 'null'].contains(valuePair.first) ? '' : valuePair.first;
    final upperValue =
        ['infinity', 'null'].contains(valuePair.last) ? '' : valuePair.last;

    return (lowerValue, upperValue);
  }

  static dynamic _inferValueType(String value) {
    final intParse = int.tryParse(value);
    final floatParse = double.tryParse(value);
    final dateParse = DateTime.tryParse(value);

    if (value.isEmpty) {
      return null;
    } else if (intParse != null) {
      return intParse;
    } else if (floatParse != null) {
      return floatParse;
    } else if (dateParse != null) {
      return dateParse;
    }

    throw RangeTypeException(
      RangeTypeErrors.inferenceInvalidType(value),
    );
  }

  static (bool, bool) _areBoundsInfinite(String range) {
    final valuePair = range.removeBrackets().split(',').trimAll();

    if (valuePair.length != 2) {
      throw RangeTypeException(
        RangeTypeErrors.thirdBoundError,
      );
    }

    if (valuePair.first == 'infinity') {
      throw RangeTypeException(
        RangeTypeErrors.invalidUseOfInfinityError,
      );
    }

    if (valuePair.last == '-infinity') {
      throw RangeTypeException(
        RangeTypeErrors.invalidUseOfNegativeInfinityError,
      );
    }

    final isLowerBoundInfinite = valuePair.first == '-infinity';
    final isUpperBoundInfinite = valuePair.last == 'infinity';

    return (isLowerBoundInfinite, isUpperBoundInfinite);
  }

  static RangeDataType? _getDataTypeFromTimestamp(String timestamp) {
    if (timestamp.isEmpty) {
      return null;
    }

    // Matches all characters ignoring digits, this is used with the
    // replaceAll() function to remove all characters leaving only digits, e.g.
    // '2023-01-01T12:00:00+05:00' => '202301011200000500'
    final removeCharsRegex = RegExp(r'[^0-9\s]+');

    // Matches all '+', '-', 'z' and 'Z', this is used combined with the
    // split() function to split the timezone offset from the rest of the
    // ISO 8601 string. e.g.
    // 2022-01-01T12:00:00.000+05:00 => index of '+' == 23
    final hasTimezoneRegex = RegExp(r'[+\-Zz]');
    final rawNumbers = timestamp.replaceAll(removeCharsRegex, '');

    if (rawNumbers.length <= 8) {
      return RangeDataType.date;
    } else if (timestamp.split(hasTimezoneRegex).last.length <= 5) {
      return RangeDataType.timestamptz;
    } else {
      return RangeDataType.timestamp;
    }
  }
}

class IntegerRangeType extends RangeType {
  const IntegerRangeType({
    this.upperRange,
    this.lowerRange,
    required super.lowerRangeInclusive,
    required super.upperRangeInclusive,
    required super.isLowerBoundInfinite,
    required super.isUpperBoundInfinite,
    required super.rangeDataType,
    required super.rawRangeString,
    required super.isEmpty,
  });

  final int? upperRange;
  final int? lowerRange;

  @override
  RangeComparable<int> getComparable() {
    if (isEmpty) {
      throw RangeTypeException(
        RangeTypeErrors.emptyRangeComparableError,
      );
    }

    final newLowerRange = lowerRangeInclusive
        ? lowerRange
        : lowerRange == null
            ? null
            : lowerRange! + 1;
    final newUpperRange = upperRangeInclusive
        ? upperRange
        : upperRange == null
            ? null
            : upperRange! - 1;

    return RangeComparable<int>(
      lowerRange: newLowerRange,
      upperRange: newUpperRange,
      rangeType: rangeDataType,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is IntegerRangeType &&
      lowerRange == other.lowerRange &&
      upperRange == other.upperRange &&
      lowerRangeInclusive == other.lowerRangeInclusive &&
      upperRangeInclusive == other.upperRangeInclusive &&
      isLowerBoundInfinite == other.isLowerBoundInfinite &&
      isUpperBoundInfinite == other.isUpperBoundInfinite &&
      rangeDataType == other.rangeDataType &&
      rawRangeString == other.rawRangeString &&
      isEmpty == other.isEmpty;

  @override
  int get hashCode => Object.hashAll([
        lowerRange,
        upperRange,
        lowerRangeInclusive,
        upperRangeInclusive,
        isLowerBoundInfinite,
        isUpperBoundInfinite,
        rangeDataType,
        rawRangeString,
        isEmpty,
      ]);
}

class FloatRangeType extends RangeType {
  const FloatRangeType({
    this.upperRange,
    this.lowerRange,
    required super.lowerRangeInclusive,
    required super.upperRangeInclusive,
    required super.isLowerBoundInfinite,
    required super.isUpperBoundInfinite,
    required super.rangeDataType,
    required super.rawRangeString,
    required super.isEmpty,
  });

  final double? upperRange;
  final double? lowerRange;

  @override
  RangeComparable<double> getComparable() {
    if (isEmpty) {
      throw RangeTypeException(
        RangeTypeErrors.emptyRangeComparableError,
      );
    }

    final newLowerRange = lowerRangeInclusive
        ? lowerRange
        : lowerRange == null
            ? null
            : lowerRange! + 0.1;
    final newUpperRange = upperRangeInclusive
        ? upperRange
        : upperRange == null
            ? null
            : upperRange! - 0.1;

    return RangeComparable<double>(
      lowerRange: newLowerRange,
      upperRange: newUpperRange,
      rangeType: rangeDataType,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is FloatRangeType &&
      lowerRange == other.lowerRange &&
      upperRange == other.upperRange &&
      lowerRangeInclusive == other.lowerRangeInclusive &&
      upperRangeInclusive == other.upperRangeInclusive &&
      isLowerBoundInfinite == other.isLowerBoundInfinite &&
      isUpperBoundInfinite == other.isUpperBoundInfinite &&
      rangeDataType == other.rangeDataType &&
      rawRangeString == other.rawRangeString &&
      isEmpty == other.isEmpty;

  @override
  int get hashCode => Object.hashAll([
        lowerRange,
        upperRange,
        lowerRangeInclusive,
        upperRangeInclusive,
        isLowerBoundInfinite,
        isUpperBoundInfinite,
        rangeDataType,
        rawRangeString,
        isEmpty,
      ]);
}

class DateRangeType extends RangeType {
  const DateRangeType({
    this.upperRange,
    this.lowerRange,
    required super.lowerRangeInclusive,
    required super.upperRangeInclusive,
    required super.isLowerBoundInfinite,
    required super.isUpperBoundInfinite,
    required super.rangeDataType,
    required super.rawRangeString,
    required super.isEmpty,
  });

  factory DateRangeType.adjustPrecision({
    DateTime? upperRange,
    DateTime? lowerRange,
    required bool lowerRangeInclusive,
    required bool upperRangeInclusive,
    required bool isUpperBoundInfinite,
    required bool isLowerBoundInfinite,
    required RangeDataType rangeDataType,
    required String rawRangeString,
    required bool isEmpty,
  }) {
    if (isEmpty) {
      return DateRangeType(
        lowerRangeInclusive: lowerRangeInclusive,
        upperRangeInclusive: upperRangeInclusive,
        isLowerBoundInfinite: isLowerBoundInfinite,
        isUpperBoundInfinite: isUpperBoundInfinite,
        rangeDataType: rangeDataType,
        rawRangeString: rawRangeString,
        isEmpty: isEmpty,
      );
    }

    // Every data type except 'timestamptz' must be utc because it ignores timezones
    late final DateTime? newUpperRange;
    late final DateTime? newLowerRange;
    late final String newRawString;

    // Gets the first and last bracket
    final firstBracket = lowerRangeInclusive ? '[' : '(';
    final lastBracket = upperRangeInclusive ? ']' : ')';

    // If the data type is 'date' adjust the precision to the scope of a date
    // ignoring time and timezone and standardizes the ISO 8601 string of every
    // timestamp
    if (rangeDataType == RangeDataType.date) {
      if (upperRange != null) {
        newUpperRange = DateTime.utc(
          upperRange.year,
          upperRange.month,
          upperRange.day,
        );
      } else {
        newUpperRange = null;
      }

      if (lowerRange != null) {
        newLowerRange = DateTime.utc(
          lowerRange.year,
          lowerRange.month,
          lowerRange.day,
        );
      } else {
        newLowerRange = null;
      }

      // These are used to standardize the raw range string
      // We need to split by 'T' because the first part before T is only the
      // standardized date
      final newIsoString1 =
          newLowerRange?.toIso8601String().split('T')[0] ?? '';
      final newIsoString2 =
          newUpperRange?.toIso8601String().split('T')[0] ?? '';

      newRawString = "$firstBracket$newIsoString1,$newIsoString2$lastBracket";
    }

    if (rangeDataType == RangeDataType.timestamp) {
      if (upperRange != null) {
        newUpperRange = DateTime.utc(
          upperRange.year,
          upperRange.month,
          upperRange.day,
          upperRange.hour,
          upperRange.minute,
          upperRange.second,
          upperRange.millisecond,
        );
      } else {
        newUpperRange = null;
      }

      if (lowerRange != null) {
        newLowerRange = DateTime.utc(
          lowerRange.year,
          lowerRange.month,
          lowerRange.day,
          lowerRange.hour,
          lowerRange.minute,
          lowerRange.second,
          lowerRange.millisecond,
        );
      } else {
        newLowerRange = null;
      }

      // Generates the standardized ISO 8601 string and removes the UTC timezone
      // 'Z' symbol in the end
      final newIsoString1 =
          newLowerRange?.toIso8601String().replaceFirst('Z', '') ?? '';
      final newIsoString2 =
          newUpperRange?.toIso8601String().replaceFirst('Z', '') ?? '';

      newRawString = "$firstBracket$newIsoString1,$newIsoString2$lastBracket";
    }

    if (rangeDataType == RangeDataType.timestamptz) {
      // The standardization of a timestamp with timezone works by extracting
      // and removing the timezone offset, then parsing the timestamp without
      // the timezone as if it was an UTC date, it needs to be UTC so the
      // timezone offset is not applied directly, then after the timestamp is
      // parsed by the DateTime.parse() function, it is returned a standardized
      // ISO 8601 string, then we remove the last 'Z' character that indicates
      // UTC, and replace it with the timezone offset.

      newUpperRange = upperRange;
      newLowerRange = lowerRange;

      // Removes the infinity value so it can be treated as unspecified
      final editedRangeString = rawRangeString.replaceAll(
        RegExp(r'-?infinity'),
        '',
      );

      final timezoneOffsets = _extractTzOffsets(editedRangeString);
      final timestamps = _removeTzOffsets(editedRangeString);

      final splitTs = timestamps.removeBrackets().split(',');

      // Convert the timestamps to UTC so they can retain the original timestamp
      final List<String> utcTs = [];

      for (var element in splitTs) {
        if (element.isEmpty) {
          utcTs.add("");
          continue;
        }
        utcTs.add('${element}Z');
      }

      final newLowerRangeDt =
          utcTs[0].isNotEmpty ? DateTime.parse(utcTs[0]) : null;
      final newUpperRangeDt =
          utcTs[1].isNotEmpty ? DateTime.parse(utcTs[1]) : null;

      final newIsoString1 = newLowerRangeDt != null
          ? DateTime(
                newLowerRangeDt.year,
                newLowerRangeDt.month,
                newLowerRangeDt.day,
                newLowerRangeDt.hour,
                newLowerRangeDt.minute,
                newLowerRangeDt.second,
                newLowerRangeDt.millisecond,
                newLowerRangeDt.microsecond,
              ).toIso8601String().replaceAll('Z', '') +
              timezoneOffsets[0]
          : isLowerBoundInfinite
              ? "-infinity"
              : "";

      final newIsoString2 = newUpperRangeDt != null
          ? DateTime(
                newUpperRangeDt.year,
                newUpperRangeDt.month,
                newUpperRangeDt.day,
                newUpperRangeDt.hour,
                newUpperRangeDt.minute,
                newUpperRangeDt.second,
                newUpperRangeDt.millisecond,
                newUpperRangeDt.microsecond,
              ).toIso8601String().replaceAll('Z', '') +
              timezoneOffsets[1]
          : isUpperBoundInfinite
              ? "infinity"
              : "";

      newRawString = "$firstBracket$newIsoString1,$newIsoString2$lastBracket";
    }

    return DateRangeType(
      upperRange: newUpperRange,
      lowerRange: newLowerRange,
      lowerRangeInclusive: lowerRangeInclusive,
      upperRangeInclusive: upperRangeInclusive,
      isLowerBoundInfinite: isLowerBoundInfinite,
      isUpperBoundInfinite: isUpperBoundInfinite,
      rangeDataType: rangeDataType,
      rawRangeString: newRawString,
      isEmpty: false,
    );
  }

  final DateTime? upperRange;
  final DateTime? lowerRange;

  @override
  RangeComparable<DateTime> getComparable() {
    if (isEmpty) {
      throw RangeTypeException(
        RangeTypeErrors.emptyRangeComparableError,
      );
    }

    late final Duration duration;

    if (rangeDataType == RangeDataType.date) {
      duration = const Duration(days: 1);
    } else {
      duration = const Duration(milliseconds: 1);
    }

    final newLowerRange =
        lowerRangeInclusive ? lowerRange : lowerRange?.add(duration);
    final newUpperRange =
        upperRangeInclusive ? upperRange : upperRange?.subtract(duration);

    return RangeComparable<DateTime>(
      lowerRange: newLowerRange,
      upperRange: newUpperRange,
      rangeType: rangeDataType,
    );
  }

  static String _removeTzOffsets(String range) {
    // Matches all '+', '-', 'z' and 'Z', this is used combined with
    // lastIndexOf() to match the timezone offset in the end of the
    // ISO 8601 string. e.g.
    // 2022-01-01T12:00:00.000+05:00 => index of '+' == 23
    final hasTimezoneRegex = RegExp(r'[+\-Zz]');

    // Removes the brackets and spaces from the range, e.g.
    // '[5, 10]' => '5,10'this
    final rawRange = range.removeBrackets().removeSpaces();

    // Split the raw range by its limits, e.g.
    // '5,10' => ['5', '10']
    final splitRange = rawRange.split(',');
    final List<String> finalRangeSplit = [];

    for (final element in splitRange) {
      if (element.isEmpty) {
        finalRangeSplit.add(element);
        continue;
      }

      // Gets the starting index of the timezone offset in the ISO 8601 string
      final index = element.lastIndexOf(hasTimezoneRegex);

      // Removes the timezone offset as substring, e.g.
      // 2022-01-01T12:00:00.000+05:00 => '2022-01-01T12:00:00.000'
      final timestamp = element.substring(0, index);
      finalRangeSplit.add(timestamp);
    }

    final finalRange = finalRangeSplit.join(',');

    // Add the brackets back to the range string
    final reconstructedRange = range[0] + finalRange + range[range.length - 1];

    return reconstructedRange;
  }

  static List<String> _extractTzOffsets(String range) {
    // Matches all '+', '-', 'z' and 'Z', this is used combined with
    // lastIndexOf() to match the timezone offset in the end of the
    // ISO 8601 string. e.g.
    // 2022-01-01T12:00:00.000+05:00 => index of '+' == 23
    final hasTimezoneRegex = RegExp(r'[+\-Zz]');

    // Removes the brackets and spaces from the range, e.g.
    // '[5, 10]' => '5,10'
    final rawRange = range.removeBrackets().removeSpaces();

    // Split the raw range by its limits, e.g.
    // '5,10' => ['5', '10']
    final splitRange = rawRange.split(',');
    final List<String> offsets = [];

    for (final element in splitRange) {
      if (element.isEmpty) {
        offsets.add(element);
        continue;
      }

      // Gets the starting index of the timezone offset in the ISO 8601 string
      final index = element.lastIndexOf(hasTimezoneRegex);

      // Retrieves the timezone offset as substring, e.g.
      // 2022-01-01T12:00:00.000+05:00 => '+05:00'
      final tzOffset = element.substring(index);

      // Fix offset if minutes are ommited, e.g.
      // 2022-01-01T12:00:00.000+05:00 => '+05:00'
      // 2022-01-01T12:00:00.000+05 => '+05', after fix =>'+05:00'
      if (tzOffset != 'Z') {
        if (!tzOffset.contains(':')) {
          offsets.add("$tzOffset:00");
          continue;
        }
      }
      offsets.add(tzOffset);
    }

    return offsets;
  }

  @override
  bool operator ==(Object other) =>
      other is DateRangeType &&
      lowerRange == other.lowerRange &&
      upperRange == other.upperRange &&
      lowerRangeInclusive == other.lowerRangeInclusive &&
      upperRangeInclusive == other.upperRangeInclusive &&
      isLowerBoundInfinite == other.isLowerBoundInfinite &&
      isUpperBoundInfinite == other.isUpperBoundInfinite &&
      rangeDataType == other.rangeDataType &&
      rawRangeString == other.rawRangeString &&
      isEmpty == other.isEmpty;

  @override
  int get hashCode => Object.hashAll([
        lowerRange,
        upperRange,
        lowerRangeInclusive,
        upperRangeInclusive,
        isLowerBoundInfinite,
        isUpperBoundInfinite,
        rangeDataType,
        rawRangeString,
        isEmpty,
      ]);
}
