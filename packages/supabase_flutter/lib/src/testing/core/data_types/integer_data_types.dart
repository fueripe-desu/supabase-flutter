// ignore_for_file: unrelated_type_equality_checks

import 'dart:math' as m;

import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/character_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/floating_point_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/primitive_data_types_extension.dart';
import 'package:supabase_flutter/src/testing/utils/constants.dart';

abstract class IntegerDataType<T extends IntegerDataType<T>> extends DataType {
  IntegerDataType(int intValue) {
    value = _checkRange(intValue);
  }

  late final int value;

  int get bitCount;
  int get bitLength => value.bitLength;
  int get sign => value.sign;

  bool get isEven => value.isEven;
  bool get isOdd => value.isOdd;
  bool get isNegative => value.isNegative;

  int get _maxValue;
  int get _minValue;
  String get _className;

  T createInstance(int value);

  T abs() {
    if (value == intMin) {
      _throwOutOfRange();
    }

    return this.createInstance(value.abs());
  }

  T ceil() => this.createInstance(value.ceil());

  T floor() => this.createInstance(value.floor());

  T round() => this.createInstance(value.round());

  T truncate() => this.createInstance(value.truncate());

  T clamp(int lowerLimit, int upperLimit) {
    if (lowerLimit > upperLimit) {
      throw ArgumentError(
        'Lower limit cannot be greater than the upper limit.',
      );
    }

    return this.createInstance(value.clamp(lowerLimit, upperLimit).toInt());
  }

  T gcd(Object other) {
    if (other is int) {
      return this.createInstance(value.gcd(other));
    } else if (other is IntegerDataType) {
      return this.createInstance(value.gcd(other.value));
    } else {
      throw ArgumentError(
        '${other.runtimeType} cannot be compared for gcd with Integer types.',
      );
    }
  }

  T pow(int exponent) {
    if (exponent.isNaN || exponent.isInfinite) {
      throw ArgumentError(
        'Exponent must be finite.',
      );
    }

    if (exponent < 0) {
      throw ArgumentError(
        'Exponent must be non-negative.',
      );
    }

    final result = toNumeric().pow(exponent).toMostPreciseInt();

    if (result is Numeric) {
      throw RangeError('Exponentiation result out of range.');
    }

    return this.createInstance((result as IntegerDataType).value);
  }

  T modInverse(int modulus) {
    if (modulus == 0) {
      throw ArgumentError('Modulus cannot be zero.');
    }

    if (modulus == 1) {
      throw ArgumentError('Modulus cannot be one.');
    }

    if (value == 0) {
      throw ArgumentError('Value cannot be zero.');
    }

    if (modulus < 1) {
      throw ArgumentError('Modulus must be positive.');
    }

    if (value == modulus) {
      throw ArgumentError('Value and modulus cannot be identical.');
    }

    if (gcd(modulus) != 1) {
      throw ArgumentError('Non-coprime values are forbidden.');
    }

    return this.createInstance(value.modInverse(modulus));
  }

  T modPow(int exponent, int modulus) {
    if (exponent < 0) {
      throw ArgumentError('Exponent must be non-negative.');
    }

    if (modulus < 1) {
      throw ArgumentError('Modulus must be positive.');
    }

    final result = toNumeric().pow(exponent).toMostPreciseInt();

    if (result is Numeric) {
      throw RangeError('Exponentiation result out of range.');
    }

    final intValue = (result as IntegerDataType).value;

    return this.createInstance(intValue % modulus);
  }

  T remainder(IntegerDataType other) {
    if (other == 0) {
      throw ArgumentError('Remainder by zero is forbidden.');
    }

    return this.createInstance(value.remainder(other.value));
  }

  T toSigned(int width) {
    if (width <= 0) {
      throw ArgumentError('Width must be positive.');
    }

    return this.createInstance(value.toSigned(width));
  }

  T toUnsigned(int width) {
    if (width <= 0) {
      throw ArgumentError('Width must be positive.');
    }

    return this.createInstance(value.toUnsigned(width));
  }

  @override
  int compareTo(Object other) {
    if (other is IntegerDataType) {
      return value.compareTo(other.value);
    } else if (other is FloatingPointDataType) {
      final thisCast = other.createInstance(value.toDouble());
      return thisCast.compareTo(other);
    } else if (other is ArbitraryPrecisionDataType) {
      if (other is Numeric) {
        return toNumeric().compareTo(other);
      } else if (other is Decimal) {
        return toDecimal().compareTo(other);
      }
    } else if (other is CharacterDataType) {
      return value.toString().compareTo(other.value);
    } else if (other is int) {
      return value.compareTo(other);
    } else if (other is double) {
      return value.toDouble().compareTo(other);
    } else if (other is String) {
      return value.toString().compareTo(other);
    }

    throw ArgumentError(
      'Comparison of int types is not supported with ${other.runtimeType}',
    );
  }

  // Unary operators
  @override
  T operator -() {
    if (value == _minValue) {
      _throwOutOfRange();
    }
    return createInstance(-value);
  }

  // Arithmetic operators
  @override
  DataType operator +(Object other) {
    return _performOperation(
      other: other,
      operationName: 'Addition',
      intFunc: (otherValue, _) => _safeAdd(value, otherValue),
      floatFunc: (otherValue) =>
          otherValue.createInstance(value.toDouble()) + otherValue,
      numericFunc: (otherValue) => toNumeric() + otherValue,
      decimalFunc: (otherValue) => toDecimal() + otherValue,
      pDoubleFunc: (otherValue) => Real(value + otherValue),
    );
  }

  @override
  DataType operator -(Object other) {
    return _performOperation(
      other: other,
      operationName: 'Subtraction',
      intFunc: (otherValue, _) => _safeSubtract(value, otherValue),
      floatFunc: (otherValue) =>
          otherValue.createInstance(value.toDouble()) - otherValue,
      numericFunc: (otherValue) => toNumeric() - otherValue,
      decimalFunc: (otherValue) => toDecimal() - otherValue,
      pDoubleFunc: (otherValue) => Real(value - otherValue),
    );
  }

  @override
  DataType operator *(Object other) {
    return _performOperation(
      other: other,
      operationName: 'Multiplication',
      intFunc: (otherValue, _) => _safeMultiply(value, otherValue),
      floatFunc: (otherValue) =>
          otherValue.createInstance(value.toDouble()) * otherValue,
      numericFunc: (otherValue) => toNumeric() * otherValue,
      decimalFunc: (otherValue) => toDecimal() * otherValue,
      pDoubleFunc: (otherValue) => Real(value * otherValue),
    );
  }

  @override
  DataType operator /(Object other) => _performDivision(other);

  @override
  DataType operator ~/(Object other) => _performIntegerDivision(other);

  @override
  DataType operator %(Object other) {
    return _performOperation(
      other: other,
      operationName: 'Modulo',
      intFunc: (otherValue, _) => _safeModulo(value, otherValue),
      floatFunc: (otherValue) =>
          otherValue.createInstance(value.toDouble()) % otherValue,
      numericFunc: (otherValue) => toNumeric() % otherValue,
      decimalFunc: (otherValue) => toDecimal() % otherValue,
      pDoubleFunc: (otherValue) {
        final thisCast = toReal();
        final otherCast = otherValue.toNumeric().toMostPreciseFloat();

        return thisCast % otherCast;
      },
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
  DataType operator &(Object other) {
    return _performOperation(
      other: other,
      operationName: 'Bitwise AND',
      intFunc: (otherValue, _) => value & otherValue,
    );
  }

  @override
  DataType operator ^(Object other) {
    return _performOperation(
      other: other,
      operationName: 'Bitwise XOR',
      intFunc: (otherValue, _) => value ^ otherValue,
    );
  }

  @override
  DataType operator |(Object other) {
    return _performOperation(
      other: other,
      operationName: 'Bitwise OR',
      intFunc: (otherValue, _) => value | otherValue,
    );
  }

  @override
  DataType operator <<(Object other) {
    return _performOperation(
      other: other,
      operationName: 'Left shift',
      intFunc: (otherValue, bits) => _safeLeftShift(value, otherValue, bits),
    );
  }

  @override
  DataType operator >>(Object other) {
    return _performOperation(
      other: other,
      operationName: 'Right shift',
      intFunc: (otherValue, bits) => _safeRightShift(value, otherValue, bits),
    );
  }

  @override
  DataType operator >>>(Object other) {
    throw UnsupportedError('Unsigned right shift is unsupported.');
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
    try {
      return compareTo(other) == 0;
    } on ArgumentError {
      return false;
    }
  }

  @override
  int get hashCode => value.hashCode;

  // Cast methods

  // Primitives
  @override
  String toString() => value.toString();

  @override
  String toDetailedString() => toString();

  String toRadixString(int radix) => value.toRadixString(radix);

  @override
  double toPrimitiveDouble() => value.toDouble();

  @override
  int toPrimitiveInt() => value;

  // Integer
  @override
  SmallInteger toSmallInteger() => SmallInteger(value);

  @override
  Integer toInteger() => Integer(value);

  @override
  BigInteger toBigInteger() => BigInteger(value);

  @override
  SmallSerial toSmallSerial() => SmallSerial(value);

  @override
  Serial toSerial() => Serial(value);

  @override
  BigSerial toBigSerial() => BigSerial(value);

  // Floating point
  @override
  Real toReal() => Real(value.toDouble());

  @override
  DoublePrecision toDoublePrecision() => DoublePrecision(value.toDouble());

  // Arbitrary precision
  @override
  Numeric toNumeric() => Numeric(
        value: value.toString(),
        precision: value.abs().toString().length,
        scale: 0,
      );

  @override
  Decimal toDecimal() => Decimal(
        value: value.toString(),
        precision: value.abs().toString().length,
        scale: 0,
      );

  // Character
  @override
  Char toChar() => Char(
        value.toString(),
        length: value.toString().length,
      );

  @override
  VarChar toVarChar() => VarChar(
        value.toString(),
        length: value.toString().length,
      );

  @override
  Text toText() => Text(value.toString());

  int _checkRange(int value) {
    if (value < _minValue || value > _maxValue) {
      _throwOutOfRange();
    }

    return value;
  }

  void _throwOutOfRange() {
    throw RangeError('$_className out of range.');
  }

  int _safeAdd(int a, int b) {
    if (a > 0 && b > intMax - a) {
      // int primitive would overflow
      _throwOutOfRange();
    } else if (a < 0 && b < intMin - a) {
      // int primitive would underflow
      _throwOutOfRange();
    }

    return a + b;
  }

  int _safeSubtract(int a, int b) {
    if (a < 0 && b > 0 && a < intMin + b) {
      // Subtraction would underflow
      _throwOutOfRange();
    } else if (a > 0 && b < 0 && a > intMax + b) {
      // Subtraction would overflow
      _throwOutOfRange();
    }

    return a - b;
  }

  int _safeMultiply(int a, int b) {
    if (a == 0 || b == 0) {
      return 0;
    } else if (a == intMin || b == intMin) {
      // Multiplying by the minimum value could cause overflow
      _throwOutOfRange();
    } else {
      // final signA = a.sign;
      // final signB = b.sign;
      final aAbs = a.abs();
      final bAbs = b.abs();

      // Use division to check for overflow before performing the multiplication
      if (aAbs > intMax ~/ bAbs) {
        _throwOutOfRange();
        // return signA == signB ? _maxValue : _minValue;
      }
    }

    return a * b;
  }

  double _safeDivide(int a, int b) {
    if (b == 0) {
      throw ArgumentError('Division by zero is not allowed.');
    }

    return a / b;
  }

  int _safeIntegerDivision(int a, int b) {
    if (b == 0) {
      throw ArgumentError('Division by zero is not allowed.');
    }

    if (a == intMin && b < 0) {
      _throwOutOfRange();
    }

    return a ~/ b;
  }

  int _safeModulo(int a, int b) {
    if (b == 0) {
      throw ArgumentError('Modulo by zero is not allowed.');
    }

    return a.remainder(b);
  }

  int _safeLeftShift(int a, int shift, int bits) {
    if (shift < 0) {
      throw ArgumentError('Shift amount must be non-negative.');
    }

    final newShift = shift % bits;
    int shiftedValue = a;
    for (int i = 0; i < newShift; i++) {
      // Check for overflow conditions
      if ((shiftedValue > 0 && shiftedValue > (1 << 62)) ||
          (shiftedValue < 0 &&
              (shiftedValue < -(1 << 62) || -shiftedValue > (1 << 62)))) {
        throw RangeError('Shift operation out of range');
      }
      shiftedValue = shiftedValue << 1;
    }

    return shiftedValue;
  }

  int _safeRightShift(int a, int shift, int bits) {
    if (shift < 0) {
      throw ArgumentError('Shift amount must be non-negative.');
    }

    return a >> (shift % bits);
  }

  (int, int) _getPrecisions(DataType other) {
    final thisPrecision = DataType.getPrecision(this);
    final otherPrecision = DataType.getPrecision(other);
    final maxPrecision = m.max(thisPrecision, otherPrecision);
    return (thisPrecision, maxPrecision);
  }

  DataType _performDivision(Object other) {
    if (other is IntegerDataType) {
      return Real(_safeDivide(value, other.value));
    } else if (other is FloatingPointDataType) {
      final thisCast = other.createInstance(value.toDouble());
      return thisCast / other;
    } else if (other is Numeric) {
      return toNumeric() / other;
    } else if (other is Decimal) {
      return toDecimal() / other;
    } else if (other is int) {
      return Real(_safeDivide(value, other));
    } else if (other is double) {
      if (other == 0) {
        throw ArgumentError('Division by zero is not allowed.');
      }
      return Real(value / other);
    }

    throw ArgumentError(
      'Division is not supported with ${other.runtimeType}.',
    );
  }

  IntegerDataType _performIntegerDivision(Object other) {
    if (other is IntegerDataType) {
      final result = _safeIntegerDivision(value, other.value);
      return _returnMorePrecise(other, result);
    }

    if (other is int) {
      return this.createInstance(_safeIntegerDivision(value, other));
    }

    if (other is double) {
      final thisCast = toDoublePrecision();
      final otherCast = other.toDoublePrecision();
      final result = thisCast / otherCast;
      final resultCast = result.toNumeric().truncate().toMostPreciseInt();

      if (resultCast is Numeric) {
        _throwOutOfRange();
      }
      return _returnMorePrecise(
        resultCast as IntegerDataType,
        resultCast.value,
      );
    }

    late final DataType thisCast;

    if (other is FloatingPointDataType) {
      thisCast = other.createInstance(value.toDouble());
    } else if (other is Numeric) {
      thisCast = toNumeric();
    } else if (other is Decimal) {
      thisCast = toDecimal();
    } else {
      throw ArgumentError(
        'Integer division is not supported with ${other.runtimeType}.',
      );
    }

    final result = thisCast / other;
    final resultCast = result.toNumeric().truncate().toMostPreciseInt();

    if (resultCast is Numeric) {
      _throwOutOfRange();
    }

    return _returnMorePrecise(
      resultCast as IntegerDataType,
      resultCast.value,
    );
  }

  IntegerDataType _returnMorePrecise(IntegerDataType other, dynamic value) {
    final (thisPrecision, maxPrecision) = _getPrecisions(other);
    if (maxPrecision == thisPrecision) {
      return this.createInstance(value);
    } else {
      return other.createInstance(value) as dynamic;
    }
  }

  DataType _performOperation({
    required Object other,
    required String operationName,
    dynamic Function(int otherValue, int bitCount)? intFunc,
    DataType Function(FloatingPointDataType otherValue)? floatFunc,
    DataType Function(Numeric otherValue)? numericFunc,
    DataType Function(Decimal otherValue)? decimalFunc,
    DataType Function(double otherValue)? pDoubleFunc,
  }) {
    if (other is IntegerDataType && intFunc != null) {
      final (thisPrecision, maxPrecision) = _getPrecisions(other);
      if (maxPrecision == thisPrecision) {
        final result = intFunc(other.value, this.bitCount);

        if (result is int) {
          return this.createInstance(result);
        }
        return result;
      } else {
        final result = intFunc(other.value, other.bitCount);

        if (result is int) {
          return other.createInstance(result);
        }
        return result;
      }
    } else if (other is FloatingPointDataType && floatFunc != null) {
      return floatFunc(other);
    } else if (other is Numeric && numericFunc != null) {
      return numericFunc(other);
    } else if (other is Decimal && decimalFunc != null) {
      return decimalFunc(other);
    } else if (other is int && intFunc != null) {
      return createInstance(intFunc(other, this.bitCount));
    } else if (other is double && pDoubleFunc != null) {
      return pDoubleFunc(other);
    }

    throw ArgumentError(
      '$operationName is only supported with int types.',
    );
  }
}

class BigInteger extends IntegerDataType<BigInteger> {
  BigInteger(super.intValue);

  static const int maxValue = 9223372036854775807;
  static const int minValue = -9223372036854775808;

  @override
  int get bitCount => 64;

  @override
  int get _maxValue => maxValue;
  @override
  int get _minValue => minValue;
  @override
  String get _className => 'BigInteger';

  @override
  BigInteger createInstance(int value) => BigInteger(value);

  @override
  bool identicalTo(DataType other) =>
      other is BigInteger && value == other.value;

  static final zero = BigInteger(0);
  static final positiveOne = BigInteger(1);
  static final negativeOne = BigInteger(-1);
  static final max = BigInteger(BigInteger.maxValue);
  static final min = BigInteger(BigInteger.minValue);

  static bool isValid(int intValue) {
    try {
      BigInteger(intValue);
      return true;
    } catch (err) {
      return false;
    }
  }

  static BigInteger? tryCreate(int intValue) {
    try {
      return BigInteger(intValue);
    } catch (err) {
      return null;
    }
  }
}

class SmallInteger extends IntegerDataType<SmallInteger> {
  SmallInteger(super.intValue);

  static const int maxValue = 32767;
  static const int minValue = -32768;

  @override
  int get bitCount => 16;

  @override
  int get _maxValue => maxValue;
  @override
  int get _minValue => minValue;
  @override
  String get _className => 'SmallInteger';

  @override
  SmallInteger createInstance(int value) => SmallInteger(value);

  @override
  bool identicalTo(DataType other) =>
      other is SmallInteger && value == other.value;

  static final zero = SmallInteger(0);
  static final positiveOne = SmallInteger(1);
  static final negativeOne = SmallInteger(-1);
  static final max = SmallInteger(SmallInteger.maxValue);
  static final min = SmallInteger(SmallInteger.minValue);

  static bool isValid(int intValue) {
    try {
      SmallInteger(intValue);
      return true;
    } catch (err) {
      return false;
    }
  }

  static SmallInteger? tryCreate(int intValue) {
    try {
      return SmallInteger(intValue);
    } catch (err) {
      return null;
    }
  }
}

class Integer extends IntegerDataType<Integer> {
  Integer(super.intValue);

  static const int maxValue = 2147483647;
  static const int minValue = -2147483648;

  @override
  int get bitCount => 32;

  @override
  int get _maxValue => maxValue;
  @override
  int get _minValue => minValue;
  @override
  String get _className => 'Integer';

  @override
  Integer createInstance(int value) => Integer(value);

  @override
  bool identicalTo(DataType other) => other is Integer && value == other.value;

  static final zero = Integer(0);
  static final positiveOne = Integer(1);
  static final negativeOne = Integer(-1);
  static final max = Integer(Integer.maxValue);
  static final min = Integer(Integer.minValue);

  static bool isValid(int intValue) {
    try {
      Integer(intValue);
      return true;
    } catch (err) {
      return false;
    }
  }

  static Integer? tryCreate(int intValue) {
    try {
      return Integer(intValue);
    } catch (err) {
      return null;
    }
  }
}

class SmallSerial extends IntegerDataType<SmallSerial> {
  SmallSerial(super.intValue);

  static const int maxValue = 32767;
  static const int minValue = 1;

  @override
  int get bitCount => 16;

  @override
  int get _maxValue => maxValue;
  @override
  int get _minValue => minValue;
  @override
  String get _className => 'SmallSerial';

  @override
  SmallSerial createInstance(int value) => SmallSerial(value);

  @override
  bool identicalTo(DataType other) =>
      other is SmallSerial && value == other.value;

  static final max = SmallSerial(SmallSerial.maxValue);
  static final min = SmallSerial(SmallSerial.minValue);

  static bool isValid(int intValue) {
    try {
      SmallSerial(intValue);
      return true;
    } catch (err) {
      return false;
    }
  }

  static SmallSerial? tryCreate(int intValue) {
    try {
      return SmallSerial(intValue);
    } catch (err) {
      return null;
    }
  }
}

class Serial extends IntegerDataType<Serial> {
  Serial(super.intValue);

  static const int maxValue = 2147483647;
  static const int minValue = 1;

  @override
  int get bitCount => 32;

  @override
  int get _maxValue => maxValue;
  @override
  int get _minValue => minValue;
  @override
  String get _className => 'Serial';

  @override
  Serial createInstance(int value) => Serial(value);

  @override
  bool identicalTo(DataType other) => other is Serial && value == other.value;

  static final max = Serial(Serial.maxValue);
  static final min = Serial(Serial.minValue);

  static bool isValid(int intValue) {
    try {
      Serial(intValue);
      return true;
    } catch (err) {
      return false;
    }
  }

  static Serial? tryCreate(int intValue) {
    try {
      return Serial(intValue);
    } catch (err) {
      return null;
    }
  }
}

class BigSerial extends IntegerDataType<BigSerial> {
  BigSerial(super.intValue);

  static const int maxValue = 9223372036854775806;
  static const int minValue = 1;

  @override
  int get bitCount => 64;

  @override
  int get _maxValue => maxValue;
  @override
  int get _minValue => minValue;
  @override
  String get _className => 'BigSerial';

  @override
  BigSerial createInstance(int value) => BigSerial(value);

  @override
  bool identicalTo(DataType other) =>
      other is BigSerial && value == other.value;

  static final max = BigSerial(BigSerial.maxValue);
  static final min = BigSerial(BigSerial.minValue);

  static bool isValid(int intValue) {
    try {
      BigSerial(intValue);
      return true;
    } catch (err) {
      return false;
    }
  }

  static BigSerial? tryCreate(int intValue) {
    try {
      return BigSerial(intValue);
    } catch (err) {
      return null;
    }
  }
}
