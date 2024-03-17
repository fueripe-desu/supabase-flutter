import 'package:decimal/decimal.dart';
import 'package:supabase_flutter/src/testing/supabase_test_extensions.dart';

abstract class DataType implements Comparable<Object> {
  // Unary operators
  DataType operator -();

  // Arithmetic operators
  DataType operator +(Object other);
  DataType operator -(Object other);
  DataType operator *(Object other);
  DataType operator /(Object other);
  DataType operator ~/(Object other);
  DataType operator %(Object other);

  // relational operators
  bool operator >(Object other);
  bool operator <(Object other);
  bool operator >=(Object other);
  bool operator <=(Object other);

  // Bitwise and shift operators
  DataType operator &(Object other);
  DataType operator |(Object other);
  DataType operator ^(Object other);
  DataType operator <<(Object other);
  DataType operator >>(Object other);
  DataType operator >>>(Object other);

  // Indexing operators
  DataType operator [](int index);
  void operator []=(int index, Object value);

  // Equality operator
  @override
  bool operator ==(Object other);

  @override
  int get hashCode;
}

abstract class FloatDataType extends DataType {
  FloatDataType(int? floatPrecision, int? floatScale, String value) {
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

abstract class IntegerDataType extends DataType {
  IntegerDataType(int intValue) {
    value = _clamp(intValue);
  }
  late final int value;

  int get _maxValue;
  int get _minValue;

  int _clamp(int value) {
    if (value < _minValue) {
      return _minValue;
    } else if (value > _maxValue) {
      return _maxValue;
    }
    return value;
  }

  int _safeAdd(int a, int b) {
    if (a > 0 && b > _maxValue - a) {
      // Addition would overflow
      return _maxValue;
    } else if (a < 0 && b < _minValue - a) {
      // Addition would underflow
      return _minValue;
    }

    return a + b;
  }

  int _safeSubtract(int a, int b) {
    if (a < 0 && b > 0 && a < _minValue + b) {
      // Subtraction would underflow
      return _minValue;
    } else if (a > 0 && b < 0 && a > _maxValue + b) {
      // Subtraction would overflow
      return _maxValue;
    }

    return a - b;
  }

  int _safeMultiply(int a, int b) {
    if (a == 0 || b == 0) {
      return 0;
    } else if (a == _minValue || b == _minValue) {
      // Multiplying by the minimum value could cause overflow
      return _minValue;
    } else {
      final signA = a.sign;
      final signB = b.sign;
      a = a.abs();
      b = b.abs();

      // Use division to check for overflow before performing the multiplication
      if (a > _maxValue ~/ b) {
        return signA == signB ? _maxValue : _minValue;
      }
    }

    return a * b;
  }

  int _safeDivide(int a, int b) {
    if (b == 0) {
      throw ArgumentError('Division by zero is not allowed.');
    }

    return _clamp(a ~/ b);
  }

  int _safeModulo(int a, int b) {
    if (b == 0) {
      throw ArgumentError('Modulo by zero is not allowed.');
    }

    return _clamp(a % b);
  }

  int _safeLeftShift(int a, int shift) {
    if (shift < 0) {
      throw ArgumentError('Shift amount must be non-negative.');
    }

    int shiftedValue = a;
    for (int i = 0; i < shift; i++) {
      if (shiftedValue > _maxValue >> 1 || shiftedValue < _minValue >> 1) {
        // If shifting would cause overflow, clamp to max or min value
        shiftedValue = shiftedValue > 0 ? _maxValue : _minValue;
        break;
      }
      shiftedValue = shiftedValue << 1;
    }

    return _clamp(shiftedValue);
  }

  int _safeRightShift(int a, int shift) {
    if (shift < 0) {
      throw ArgumentError('Shift amount must be non-negative.');
    }

    return _clamp(a >> shift);
  }

  int _safeUnsignedRightShift(int a, int shift) {
    if (shift < 0) {
      throw ArgumentError('Shift amount must be non-negative.');
    }

    // Treating the number as if it were unsigned for the shift
    // unsigned right shift '>>>' fills in zeros on the left
    return _clamp((a & 0xFFFFFFFFFFFFFFFF) >>> shift);
  }
}

class BigInteger extends IntegerDataType {
  BigInteger(super.intValue);

  // Max and min are one digit less than the representable amount
  // in 64-bit machines, the representable amounts are:
  //
  // Posititive: 9223372036854775807
  // Negative: -9223372036854775808
  //
  // This is to be on the safe side and avoid overflowing the value,
  // as well as dart static analyzer won't allow a value bigger than
  // that, so it needs to be a digit less so we can test it without
  // major problems.
  static const int maxValue = 9223372036854775806;
  static const int minValue = -9223372036854775807;

  @override
  int get _maxValue => maxValue;

  @override
  int get _minValue => minValue;

  @override
  int compareTo(Object other) {
    if (other is int) {
      return value.compareTo(other);
    } else if (other is IntegerDataType) {
      return value.compareTo(other.value);
    } else {
      throw ArgumentError(
        'Comparison is only supported with BigInteger or int types.',
      );
    }
  }

  // Unary operators
  @override
  BigInteger operator -() {
    if (value == minValue) {
      return BigInteger(maxValue);
    }
    return BigInteger(-value);
  }

  // Arithmetic operators
  @override
  BigInteger operator +(Object other) {
    if (other is BigInteger) {
      return BigInteger(_safeAdd(value, other.value));
    } else if (other is int) {
      return BigInteger(_safeAdd(value, other));
    }
    throw ArgumentError(
      'Addition is only supported with BigInteger or int types.',
    );
  }

  @override
  BigInteger operator -(Object other) {
    if (other is BigInteger) {
      return BigInteger(_safeSubtract(value, other.value));
    } else if (other is int) {
      return BigInteger(_safeSubtract(value, other));
    }
    throw ArgumentError(
      'Subtraction is only supported with BigInteger or int types.',
    );
  }

  @override
  BigInteger operator *(Object other) {
    if (other is BigInteger) {
      return BigInteger(_safeMultiply(value, other.value));
    } else if (other is int) {
      return BigInteger(_safeMultiply(value, other));
    }

    throw ArgumentError(
      'Multiplication is only supported with BigInteger or int types.',
    );
  }

  @override
  BigInteger operator /(Object other) {
    if (other is BigInteger) {
      return BigInteger(_safeDivide(value, other.value));
    } else if (other is int) {
      return BigInteger(_safeDivide(value, other));
    }

    throw ArgumentError(
      'Division is only supported with BigInteger or int types.',
    );
  }

  @override
  DataType operator ~/(Object other) {
    if (other is BigInteger) {
      return BigInteger(_safeDivide(value, other.value));
    } else if (other is int) {
      return BigInteger(_safeDivide(value, other));
    }

    throw ArgumentError(
      'Whole division is only supported with BigInteger or int types.',
    );
  }

  @override
  BigInteger operator %(Object other) {
    if (other is BigInteger) {
      return BigInteger(_safeModulo(value, other.value));
    } else if (other is int) {
      return BigInteger(_safeModulo(value, other));
    }

    throw ArgumentError(
      'Modulo is only supported with BigInteger or int types.',
    );
  }

  // Relational operators
  @override
  bool operator <(Object other) => compareTo(other) < 0;

  @override
  bool operator >(Object other) => compareTo(other) > 0;

  @override
  bool operator <=(Object other) => compareTo(other) <= 0;

  @override
  bool operator >=(Object other) => compareTo(other) >= 0;

  // Shift and bitwise operators
  @override
  BigInteger operator &(Object other) {
    if (other is BigInteger) {
      return BigInteger(value & other.value);
    } else if (other is int) {
      return BigInteger(value & other);
    }
    throw ArgumentError(
      'Bitwise AND is only supported with BigInteger or int types.',
    );
  }

  @override
  BigInteger operator ^(Object other) {
    if (other is BigInteger) {
      return BigInteger(value ^ other.value);
    } else if (other is int) {
      return BigInteger(value ^ other);
    }
    throw ArgumentError(
      'Bitwise XOR is only supported with BigInteger or int types.',
    );
  }

  @override
  BigInteger operator |(Object other) {
    if (other is BigInteger) {
      return BigInteger(value | other.value);
    } else if (other is int) {
      return BigInteger(value | other);
    }
    throw ArgumentError(
      'Bitwise OR is only supported with BigInteger or int types.',
    );
  }

  @override
  DataType operator <<(Object other) {
    if (other is BigInteger) {
      return BigInteger(_safeLeftShift(value, other.value));
    } else if (other is int) {
      return BigInteger(_safeLeftShift(value, other));
    }
    throw ArgumentError(
      'Left shift is only supported with BigInteger or int types.',
    );
  }

  @override
  DataType operator >>(Object other) {
    if (other is BigInteger) {
      return BigInteger(_safeRightShift(value, other.value));
    } else if (other is int) {
      return BigInteger(_safeRightShift(value, other));
    }
    throw ArgumentError(
      'Right shift is only supported with BigInteger or int types.',
    );
  }

  @override
  DataType operator >>>(Object other) {
    if (other is BigInteger) {
      return BigInteger(_safeUnsignedRightShift(value, other.value));
    } else if (other is int) {
      return BigInteger(_safeUnsignedRightShift(value, other));
    }
    throw ArgumentError(
      'Unsigned right shift is only supported with BigInteger or int types.',
    );
  }

  // Indexing operators
  @override
  DataType operator [](int index) {
    throw UnsupportedError('Index operator is unsupported by BigInteger');
  }

  @override
  void operator []=(int index, Object value) {
    throw UnsupportedError('Index assignment is unsupported by BigInteger');
  }

  @override
  bool operator ==(Object other) {
    if (other is BigInteger) {
      return value == other.value;
    } else if (other is int) {
      return value == other;
    }
    return false;
  }

  @override
  int get hashCode => value.hashCode;
}

class Numeric extends FloatDataType {
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

testIt() {}
