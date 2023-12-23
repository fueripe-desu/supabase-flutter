import 'package:supabase_flutter/src/testing/supabase_test_extensions.dart';

enum RangeDataType { integer, float, date, timestamp, timestamptz }

abstract class RangeType {
  const RangeType({
    required this.lowerRangeInclusive,
    required this.upperRangeInclusive,
    required this.rangeDataType,
    required this.rawRangeString,
  });

  factory RangeType.createRange({required String range}) {
    try {
      // Retrives and checks if the range strings have the correct brackets
      final firstBracket = range[0];
      final lastBracket = range[range.length - 1];

      if (!['[', '('].contains(firstBracket)) {
        throw Exception(
          'Range type string must start with an inclusive \'[\' or exclusive \'(\' range.',
        );
      }

      if (![']', ')'].contains(lastBracket)) {
        throw Exception(
          'Range type string must start with an inclusive \']\' or exclusive \')\' range.',
        );
      }

      final lowerRangeInclusive = firstBracket == '[' ? true : false;
      final upperRangeInclusive = lastBracket == ']' ? true : false;

      final valuePair = range.removeBrackets().removeSpaces().split(',');

      if (valuePair.length != 2) {
        throw Exception(
          'Range type string must have only two values divided by comma: lower range and upper range.',
        );
      }

      if (int.tryParse(valuePair[0]) != null) {
        if (int.tryParse(valuePair[1]) == null) {
          throw Exception(
            'Because the lower range is int, upper range must also be int, but instead got: ${valuePair[1]}',
          );
        }

        return IntegerRangeType(
          lowerRange: int.parse(valuePair[0]),
          upperRange: int.parse(valuePair[1]),
          lowerRangeInclusive: lowerRangeInclusive,
          upperRangeInclusive: upperRangeInclusive,
          rangeDataType: RangeDataType.integer,
          rawRangeString: range.removeSpaces(),
        );
      }

      if (double.tryParse(valuePair[0]) != null) {
        if (double.tryParse(valuePair[1]) == null) {
          throw Exception(
            'Because the lower range is double, upper range must also be double, but instead got: ${valuePair[1]}',
          );
        }

        return FloatRangeType(
          lowerRange: double.parse(valuePair[0]),
          upperRange: double.parse(valuePair[1]),
          lowerRangeInclusive: lowerRangeInclusive,
          upperRangeInclusive: upperRangeInclusive,
          rangeDataType: RangeDataType.float,
          rawRangeString: range.removeSpaces(),
        );
      }

      // Reassigns valuePair without removing spaces, because they are needed
      // in certain circumstances
      valuePair.clear();
      valuePair.addAll(range.removeBrackets().split(',').trimAll());

      if (DateTime.tryParse(valuePair[0]) != null) {
        if (DateTime.tryParse(valuePair[1]) == null) {
          throw Exception(
            'Because the lower range is a DateTime, upper range must also be DateTime, but instead got: ${valuePair[1]}',
          );
        }

        final dataType1 = _getDataTypeFromTimestamp(valuePair[0]);
        final dataType2 = _getDataTypeFromTimestamp(valuePair[1]);

        if (dataType1 != dataType2) {
          throw Exception(
              'Lower range and upper range must be specified with the same precision.');
        }

        return DateRangeType.adjustPrecision(
          lowerRange: DateTime.parse(valuePair[0]),
          upperRange: DateTime.parse(valuePair[1]),
          lowerRangeInclusive: lowerRangeInclusive,
          upperRangeInclusive: upperRangeInclusive,
          rangeDataType: dataType1,
          rawRangeString: range,
        );
      }

      throw Exception('Invalid range value.');
    } catch (err) {
      throw Exception('Invalid range value.');
    }
  }

  final bool lowerRangeInclusive;
  final bool upperRangeInclusive;
  final RangeDataType rangeDataType;
  final String rawRangeString;

  bool isInRange(dynamic value);
  List<dynamic> getComparable();

  bool operator >(RangeType other);

  static RangeDataType _getDataTypeFromTimestamp(String timestamp) {
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
    required this.upperRange,
    required this.lowerRange,
    required super.lowerRangeInclusive,
    required super.upperRangeInclusive,
    required super.rangeDataType,
    required super.rawRangeString,
  });

  final int upperRange;
  final int lowerRange;

  @override
  bool isInRange(dynamic value) {
    final valueToCheck = value as int;
    final bool inLowerRange = lowerRangeInclusive
        ? valueToCheck >= lowerRange
        : valueToCheck > lowerRange;
    final bool inUpperRange = upperRangeInclusive
        ? valueToCheck <= upperRange
        : valueToCheck < upperRange;

    return inLowerRange && inUpperRange;
  }

  @override
  List<int> getComparable() {
    final newLowerRange = lowerRangeInclusive ? lowerRange : lowerRange + 1;
    final newUpperRange = upperRangeInclusive ? upperRange : upperRange - 1;

    return [newLowerRange, newUpperRange];
  }

  @override
  bool operator >(RangeType other) {
    if (other is IntegerRangeType) {
      final thisComparable = getComparable();
      final otherComparable = other.getComparable();

      final thisLowerRange = thisComparable[0];
      final otherUpperRange = otherComparable[1];

      return thisLowerRange > otherUpperRange;
    }

    throw Exception(
      'Cannot compare range type with an object of a different type',
    );
  }
}

class FloatRangeType extends RangeType {
  const FloatRangeType({
    required this.upperRange,
    required this.lowerRange,
    required super.lowerRangeInclusive,
    required super.upperRangeInclusive,
    required super.rangeDataType,
    required super.rawRangeString,
  });

  final double upperRange;
  final double lowerRange;

  @override
  bool isInRange(dynamic value) {
    final valueToCheck = (value is int) ? value.toDouble() : value as double;
    final bool inLowerRange = lowerRangeInclusive
        ? valueToCheck >= lowerRange
        : valueToCheck > lowerRange;
    final bool inUpperRange = upperRangeInclusive
        ? valueToCheck <= upperRange
        : valueToCheck < upperRange;

    return inLowerRange && inUpperRange;
  }

  @override
  List<double> getComparable() {
    final newLowerRange = lowerRangeInclusive ? lowerRange : lowerRange + 0.1;
    final newUpperRange = upperRangeInclusive ? upperRange : upperRange - 0.1;

    return [newLowerRange, newUpperRange];
  }

  @override
  bool operator >(RangeType other) {
    if (other is FloatRangeType) {
      final thisComparable = getComparable();
      final otherComparable = other.getComparable();

      final thisLowerRange = thisComparable[0];
      final otherUpperRange = otherComparable[1];

      return thisLowerRange > otherUpperRange;
    }

    throw Exception(
      'Cannot compare range type with an object of a different type',
    );
  }
}

class DateRangeType extends RangeType {
  const DateRangeType({
    required this.upperRange,
    required this.lowerRange,
    required super.lowerRangeInclusive,
    required super.upperRangeInclusive,
    required super.rangeDataType,
    required super.rawRangeString,
  });

  factory DateRangeType.adjustPrecision({
    required DateTime upperRange,
    required DateTime lowerRange,
    required bool lowerRangeInclusive,
    required bool upperRangeInclusive,
    required RangeDataType rangeDataType,
    required String rawRangeString,
  }) {
    // Every data type except 'timestamptz' must be utc because it ignores timezones
    late final DateTime newUpperRange;
    late final DateTime newLowerRange;
    late final String newRawString;

    // Gets the first and last bracket
    final firstBracket = lowerRangeInclusive ? '[' : '(';
    final lastBracket = upperRangeInclusive ? ']' : ')';

    // If the data type is 'date' adjust the precision to the scope of a date
    // ignoring time and timezone and standardizes the ISO 8601 string of every
    // timestamp
    if (rangeDataType == RangeDataType.date) {
      newUpperRange = DateTime.utc(
        upperRange.year,
        upperRange.month,
        upperRange.day,
      );

      newLowerRange = DateTime.utc(
        lowerRange.year,
        lowerRange.month,
        lowerRange.day,
      );

      final newIsoString1 = newLowerRange.toIso8601String();
      final newIsoString2 = newUpperRange.toIso8601String();

      newRawString = "$firstBracket$newIsoString1,$newIsoString2$lastBracket";
    }

    if (rangeDataType == RangeDataType.timestamp) {
      newUpperRange = DateTime.utc(
        upperRange.year,
        upperRange.month,
        upperRange.day,
        upperRange.hour,
        upperRange.minute,
        upperRange.second,
        upperRange.millisecond,
      );

      newLowerRange = DateTime.utc(
        lowerRange.year,
        lowerRange.month,
        lowerRange.day,
        lowerRange.hour,
        lowerRange.minute,
        lowerRange.second,
        lowerRange.millisecond,
      );

      final newIsoString1 = newLowerRange.toIso8601String();
      final newIsoString2 = newUpperRange.toIso8601String();

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

      final timezoneOffsets = _extractTzOffsets(rawRangeString);
      final timestamps = _removeTzOffsets(rawRangeString);

      final splitTs = timestamps.removeBrackets().split(',');

      // Convert the timestamps to UTC so they can retain the original timestamp
      final List<String> utcTs = [];

      for (var element in splitTs) {
        utcTs.add('${element}Z');
      }

      final newLowerRangeDt = DateTime.parse(utcTs[0]);
      final newUpperRangeDt = DateTime.parse(utcTs[1]);

      final newIsoString1 = DateTime.utc(
            newLowerRangeDt.year,
            newLowerRangeDt.month,
            newLowerRangeDt.day,
            newLowerRangeDt.hour,
            newLowerRangeDt.minute,
            newLowerRangeDt.second,
            newLowerRangeDt.millisecond,
          ).toIso8601String().replaceAll('Z', '') +
          timezoneOffsets[0];

      final newIsoString2 = DateTime.utc(
            newUpperRangeDt.year,
            newUpperRangeDt.month,
            newUpperRangeDt.day,
            newUpperRangeDt.hour,
            newUpperRangeDt.minute,
            newUpperRangeDt.second,
            newUpperRangeDt.millisecond,
          ).toIso8601String().replaceAll('Z', '') +
          timezoneOffsets[1];

      newRawString = "$firstBracket$newIsoString1,$newIsoString2$lastBracket";
    }

    return DateRangeType(
      upperRange: newUpperRange,
      lowerRange: newLowerRange,
      lowerRangeInclusive: lowerRangeInclusive,
      upperRangeInclusive: upperRangeInclusive,
      rangeDataType: rangeDataType,
      rawRangeString: newRawString,
    );
  }

  final DateTime upperRange;
  final DateTime lowerRange;

  @override
  bool isInRange(dynamic value) {
    final valueToCheck = value as DateTime;
    final inLowerRange = lowerRangeInclusive
        ? valueToCheck.isAtSameMomentAs(lowerRange) ||
            valueToCheck.isAfter(lowerRange)
        : valueToCheck.isAfter(lowerRange);
    final inUpperRange = upperRangeInclusive
        ? valueToCheck.isAtSameMomentAs(upperRange) ||
            valueToCheck.isBefore(upperRange)
        : valueToCheck.isBefore(upperRange);

    return inLowerRange && inUpperRange;
  }

  @override
  List<DateTime> getComparable() {
    late final Duration duration;

    if (rangeDataType == RangeDataType.date) {
      duration = const Duration(days: 1);
    } else {
      duration = const Duration(milliseconds: 1);
    }

    final newLowerRange =
        lowerRangeInclusive ? lowerRange : lowerRange.add(duration);
    final newUpperRange =
        upperRangeInclusive ? upperRange : upperRange.subtract(duration);

    return [newLowerRange, newUpperRange];
  }

  @override
  bool operator >(RangeType other) {
    if (other is DateRangeType) {
      final thisComparable = getComparable();
      final otherComparable = other.getComparable();

      final thisLowerRange = thisComparable[0];
      final otherUpperRange = otherComparable[1];

      return thisLowerRange.isAfter(otherUpperRange);
    }

    throw Exception(
      'Cannot compare range type with an object of a different type',
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
}
