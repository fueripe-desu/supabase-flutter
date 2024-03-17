import 'package:decimal/decimal.dart';
import 'package:supabase_flutter/src/testing/core/data_types/data_types.dart';
import 'package:supabase_flutter/src/testing/supabase_test_extensions.dart';

abstract class ArbitraryPrecisionDataType extends FractionalDataType {
  ArbitraryPrecisionDataType(
      int? floatPrecision, int? floatScale, String value) {
    if (floatPrecision != null) {
      if (floatPrecision < 0) {
        throw ArgumentError('Precision must be positive.');
      }

      if (floatPrecision > (maxDigitsBefore + maxDigitsAfter)) {
        throw ArgumentError(
          'Precision exceeds maximum value, which is ${maxDigitsBefore + maxDigitsAfter}',
        );
      }
    }

    if (floatPrecision == null && floatScale != null) {
      throw ArgumentError(
        'If scale is not null, then precision cannot be null.',
      );
    }

    if (floatPrecision != null && floatScale != null) {
      if (floatScale > floatPrecision) {
        throw ArgumentError(
          'Scale must be less than or equal to precision.',
        );
      }
    }

    _originalString = value;
    precision = floatPrecision;
    scale = floatScale;

    _calculateDigitsBeforeAndAfter();

    if (scale != null && scale! < 0) {
      _calculateNegativeScaleValue();
    } else {
      rawValueString = _clamp(_originalString, isUnconstrained);
    }

    _value = Decimal.parse(rawValueString);
    maxValue = _calculateMaxValue();
    minValue = '-$maxValue';
  }

  static const int maxDigitsBefore = 131072;
  static const int maxDigitsAfter = 16383;

  late final String maxValue;
  late final String minValue;

  late final int? precision;
  late final int? scale;
  late final int digitsBefore;
  late final int digitsAfter;
  late final String rawValueString;

  late final Decimal _value;
  late final String _originalString;

  bool get isUnconstrained => precision == null && scale == null;
  String get value => _value.toString();

  String _calculateMaxValue() {
    final beforeString = '9' * digitsBefore;
    final afterString = '9' * digitsAfter;
    final hasPoint = rawValueString.contains('.');
    final isNegative = scale != null && scale! < 0;
    final pointString = hasPoint && !isNegative ? '.' : '';

    return beforeString + pointString + afterString;
  }

  Decimal _roundToScale(String value, int scale) {
    final factor = Decimal.parse('10').pow(-scale).toDecimal();
    final valueDecimal = Decimal.parse(value);
    return (valueDecimal / factor).round().toDecimal() * factor;
  }

  (String, String) _extractBeforeAndAfter(String value) {
    final valueSplit = value.split('.');

    return (valueSplit[0], valueSplit[1]);
  }

  void _calculateDigitsBeforeAndAfter() {
    if (precision != null && scale != null) {
      // If neither precision nor scale are null, then digits before
      // and after are calculated normally
      if (scale! < 0) {
        digitsBefore = precision!;
        digitsAfter = 0;
      } else {
        digitsBefore = (precision as int) - (scale as int);
        digitsAfter = (precision as int) - digitsBefore;
      }
    } else if (precision != null && scale == null) {
      // If only scale is null, then digitsAfter is 0 because it
      // treats the number as having no fractional point
      digitsBefore = precision!;
      digitsAfter = 0;
    } else {
      // If both are not specified, then the number goes up to the
      // implementation limits
      digitsBefore = maxDigitsBefore;
      digitsAfter = maxDigitsAfter;
    }
  }

  void _calculateNegativeScaleValue() {
    final before = _originalString.split('.')[0];
    final rounded = _roundToScale(before, scale!).toString();
    rawValueString = rounded;
  }

  String _clamp(String value, bool isUnconstrained) {
    late final String before;
    late final String? after;
    if (value.count('.') == 1) {
      (before, after) = _extractBeforeAndAfter(value);
    } else {
      before = value;
      after = null;
    }

    late final String newBefore;
    late final String newAfter;

    if (digitsBefore == 0) {
      // If there are no digits before the fractional point
      // then the value only considers numbers after the point
      // therefore, the final value is less than 1 but greater
      // than -1.
      newBefore = '0';
    } else if (before.length < digitsBefore) {
      // If there are less digits in the actual number compared
      // to the expected amount, then leading 0s are added.
      if (isUnconstrained) {
        newBefore = before;
      } else {
        newBefore = before.padLeft(digitsBefore, '0');
      }
    } else if (before.length > digitsBefore) {
      // If there are more digits than expected, the part
      // before the fractional point is cut.
      newBefore = before.substring(0, digitsBefore);
    } else {
      newBefore = before;
    }

    if (after != null) {
      if (digitsAfter == 0) {
        // If there are no digits after the fractional point
        // then the value only considers numbers before the point
        // therefore, the final value is truncated to an integer.
        return newBefore;
      } else if (after.length < digitsAfter) {
        // If there are less digits in the actual number compared
        // to the expected amount, then trailing 0s are added.
        if (isUnconstrained) {
          newAfter = after;
        } else {
          newAfter = after.padRight(digitsAfter, '0');
        }
      } else if (after.length > digitsAfter) {
        // If there are more digits than expected, the part
        // before the fractional point is cut.
        newAfter = after.substring(0, digitsAfter);
      } else {
        newAfter = after;
      }
    } else {
      newAfter = '';
    }

    return '$newBefore${after == null ? '' : '.'}$newAfter';
  }
}

class Numeric extends ArbitraryPrecisionDataType {
  static const int maxDigitsBefore = 131072;
  static const int maxDigitsAfter = 16383;

  Numeric({int? precision, int? scale, required String value})
      : super(precision, scale, value);

  @override
  DataType operator %(Object other) {
    // TODO: implement %
    throw UnimplementedError();
  }

  @override
  DataType operator &(Object other) {
    // TODO: implement &
    throw UnimplementedError();
  }

  @override
  DataType operator *(Object other) {
    // TODO: implement *
    throw UnimplementedError();
  }

  @override
  DataType operator +(Object other) {
    // TODO: implement +
    throw UnimplementedError();
  }

  @override
  DataType operator -(Object other) {
    // TODO: implement -
    throw UnimplementedError();
  }

  @override
  DataType operator -() {
    // TODO: implement -
    throw UnimplementedError();
  }

  @override
  DataType operator /(Object other) {
    // TODO: implement /
    throw UnimplementedError();
  }

  @override
  bool operator <(Object other) {
    // TODO: implement <
    throw UnimplementedError();
  }

  @override
  DataType operator <<(Object other) {
    // TODO: implement <<
    throw UnimplementedError();
  }

  @override
  bool operator <=(Object other) {
    // TODO: implement <=
    throw UnimplementedError();
  }

  @override
  bool operator >(Object other) {
    // TODO: implement >
    throw UnimplementedError();
  }

  @override
  bool operator >=(Object other) {
    // TODO: implement >=
    throw UnimplementedError();
  }

  @override
  DataType operator >>(Object other) {
    // TODO: implement >>
    throw UnimplementedError();
  }

  @override
  DataType operator >>>(Object other) {
    // TODO: implement >>>
    throw UnimplementedError();
  }

  @override
  DataType operator [](int index) {
    // TODO: implement []
    throw UnimplementedError();
  }

  @override
  void operator []=(int index, Object value) {
    // TODO: implement []=
  }

  @override
  DataType operator ^(Object other) {
    // TODO: implement ^
    throw UnimplementedError();
  }

  @override
  int compareTo(Object other) {
    // TODO: implement compareTo
    throw UnimplementedError();
  }

  @override
  DataType operator |(Object other) {
    // TODO: implement |
    throw UnimplementedError();
  }

  @override
  DataType operator ~/(Object other) {
    // TODO: implement ~/
    throw UnimplementedError();
  }
}
