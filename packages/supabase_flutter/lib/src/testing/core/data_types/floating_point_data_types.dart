import 'dart:math' as m;

import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/character_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/primitive_data_types_extension.dart';

abstract class FloatingPointDataType<T extends FloatingPointDataType<T>>
    extends FractionalDataType {
  FloatingPointDataType(double floatValue) {
    final checked = _checkRange(floatValue);
    final rounded = _roundPlaces(checked, _maxDecimalPlaces);

    value = rounded;
  }

  late final double value;

  int get decimalPlaceCount => toString().split('.')[1].length;
  int get sign => compareTo(0);
  bool get isNegative => value.isNegative;
  bool get isWhole => value == truncate().value;
  bool get isFractional => !isWhole;

  double get _maxValue;
  double get _minValue;
  int get _maxDecimalPlaces;
  String get _className;

  T createInstance(double value);

  T abs() => this.createInstance(value.abs());

  T ceil() => this.createInstance(value.ceilToDouble());

  T clamp(double lowerLimit, double upperLimit) {
    if (lowerLimit.isInfinite || lowerLimit.isNaN) {
      throw ArgumentError('Lower limit must be finite.');
    }

    if (upperLimit.isInfinite || upperLimit.isNaN) {
      throw ArgumentError('Upper limit must be finite.');
    }

    if (lowerLimit > upperLimit) {
      throw ArgumentError(
        'Upper limit must be greater than or equal to lower limit.',
      );
    }

    return this.createInstance(value.clamp(lowerLimit, upperLimit).toDouble());
  }

  T floor() => this.createInstance(value.floorToDouble());

  T pow(int exponent) {
    if (exponent.isInfinite || exponent.isNaN) {
      throw ArgumentError('Exponent must be finite.');
    }

    final result = toNumeric().pow(exponent).toMostPreciseFloat();

    if (result is Numeric) {
      throw RangeError('Exponentiation result out of range.');
    }

    return this.createInstance(m.pow(value, exponent).toDouble());
  }

  T remainder(FloatingPointDataType other) =>
      this.createInstance(value.remainder(other.value));

  T round() => this.createInstance(value.roundToDouble());

  T truncate() => this.createInstance(value.truncateToDouble());

  bool closeTo(DataType other, double delta);

  @override
  int compareTo(Object other) {
    if (other is IntegerDataType) {
      return value.compareTo(other.value);
    } else if (other is FloatingPointDataType) {
      return value.compareTo(other.value);
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
      if (other.isNaN || other.isInfinite) {
        throw ArgumentError('Second operand must be finite.');
      }
      return value.compareTo(other);
    } else if (other is String) {
      return value.toString().compareTo(other);
    }

    throw ArgumentError(
      'Comparison of floating point types is not supported with ${other.runtimeType}',
    );
  }

  // Unary operators
  @override
  T operator -() {
    return createInstance(-value);
  }

  // Arithmetic operators
  @override
  DataType operator +(Object other) {
    return _performOperation(
      other: other,
      operationName: 'Addition',
      operationFunc: (otherValue) => value + otherValue,
      arbitraryFunc: (otherValue) => toNumeric() + otherValue,
    );
  }

  @override
  DataType operator -(Object other) {
    return _performOperation(
      other: other,
      operationName: 'Subtraction',
      operationFunc: (otherValue) => value - otherValue,
      arbitraryFunc: (otherValue) => toNumeric() - otherValue,
    );
  }

  @override
  DataType operator *(Object other) {
    return _performOperation(
      other: other,
      operationName: 'Multiplication',
      operationFunc: (otherValue) => value * otherValue,
      arbitraryFunc: (otherValue) => toNumeric() * otherValue,
    );
  }

  @override
  DataType operator /(Object other) {
    return _performOperation(
      other: other,
      operationName: 'Division',
      operationFunc: (otherValue) {
        if (otherValue == 0) {
          throw ArgumentError('Division by zero is not allowed.');
        }

        return value / otherValue;
      },
      arbitraryFunc: (otherValue) => toNumeric() / otherValue,
    );
  }

  @override
  DataType operator ~/(Object other) {
    return _safeIntegerDivision(
      other: other,
      operationFunc: (a, b) =>
          ((a ~/ b) as ArbitraryPrecisionDataType).toMostPreciseInt(),
    );
  }

  @override
  DataType operator %(Object other) {
    return _performOperation(
      other: other,
      operationName: 'Modulo',
      operationFunc: (otherValue) {
        if (otherValue == 0) {
          throw ArgumentError('Modulo by zero is not allowed.');
        }

        return value.remainder(otherValue);
      },
      arbitraryFunc: (otherValue) => toNumeric() % otherValue,
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
    throw UnsupportedError(
      'Bitwise AND is not supported by $_className.',
    );
  }

  @override
  T operator ^(Object other) {
    throw UnsupportedError(
      'Bitwise XOR is not supported by $_className.',
    );
  }

  @override
  T operator |(Object other) {
    throw UnsupportedError(
      'Bitwise OR is not supported by $_className.',
    );
  }

  @override
  DataType operator <<(Object other) {
    throw UnsupportedError(
      'Left shift is not supported by $_className.',
    );
  }

  @override
  DataType operator >>(Object other) {
    throw UnsupportedError(
      'Right shift is not supported by $_className.',
    );
  }

  @override
  DataType operator >>>(Object other) {
    throw UnsupportedError(
      'Unsigned right shift is not supported by $_className.',
    );
  }

  // Indexing operators
  @override
  DataType operator [](int index) {
    throw UnsupportedError(
      'Index operator is not supported by $_className.',
    );
  }

  @override
  void operator []=(int index, Object value) {
    throw UnsupportedError(
      'Index assignment is unsupported by $_className.',
    );
  }

  // Equality and hashcode
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

  @override
  int toPrimitiveInt() => value.toPrimitiveInt();

  @override
  double toPrimitiveDouble() => value.toPrimitiveDouble();

  // Integer
  @override
  SmallInteger toSmallInteger() => value.toSmallInteger();

  @override
  Integer toInteger() => value.toInteger();

  @override
  BigInteger toBigInteger() => value.toBigInteger();

  @override
  SmallSerial toSmallSerial() => value.toSmallSerial();

  @override
  Serial toSerial() => value.toSerial();

  @override
  BigSerial toBigSerial() => value.toBigSerial();

  // Floating point
  @override
  Real toReal() => value.toReal();

  @override
  DoublePrecision toDoublePrecision() => value.toDoublePrecision();

  // Arbitrary precision
  @override
  Numeric toNumeric() => value.toNumeric();

  @override
  Decimal toDecimal() => value.toDecimal();

  // Character
  @override
  Char toChar() => value.toChar();

  @override
  VarChar toVarChar() => value.toVarChar();

  @override
  Text toText() => value.toText();

  // Private methods
  double _checkRange(double value) {
    if (value.isInfinite) {
      _throwOutOfRange();
    }

    final valueCast = value.toNumeric();
    if (valueCast < _minValue.toNumeric() ||
        valueCast > _maxValue.toNumeric()) {
      _throwOutOfRange();
    }

    return value;
  }

  void _throwOutOfRange() {
    throw RangeError('$_className out of range.');
  }

  double _roundPlaces(double value, int fixedPlaces) {
    if (fixedPlaces < 0 && fixedPlaces > 20) {
      throw ArgumentError(
        'Cannot round to less than 0 or more than 20 decimal places.',
      );
    }

    final roundedString = value.toStringAsFixed(fixedPlaces);
    return double.parse(roundedString);
  }

  (int, int) _getPrecisions(DataType other) {
    final thisPrecision = DataType.getPrecision(this);
    final otherPrecision = DataType.getPrecision(other);
    final maxPrecision = m.max(thisPrecision, otherPrecision);
    return (thisPrecision, maxPrecision);
  }

  DataType _safeIntegerDivision({
    required Object other,
    required DataType Function(
      ArbitraryPrecisionDataType a,
      ArbitraryPrecisionDataType b,
    ) operationFunc,
  }) {
    if (other is IntegerDataType) {
      final result = operationFunc(toNumeric(), other.toNumeric());

      final resultPrecision = DataType.getPrecision(result);
      final otherPrecision = DataType.getPrecision(other);
      final maxPrecision = m.max(resultPrecision, otherPrecision);

      if (resultPrecision == maxPrecision) {
        return result;
      } else {
        if (result is! IntegerDataType) {
          return result;
        }
        return other.createInstance(result.value);
      }
    } else if (other is FloatingPointDataType) {
      return operationFunc(toNumeric(), other.toNumeric());
    } else if (other is ArbitraryPrecisionDataType) {
      return operationFunc(toNumeric(), other);
    } else if (other is int) {
      return operationFunc(toNumeric(), other.toNumeric());
    } else if (other is double) {
      return operationFunc(toNumeric(), other.toNumeric());
    }

    throw ArgumentError(
      'Integer division of floating point types is not supported with ${other.runtimeType}',
    );
  }

  DataType _performOperation({
    required Object other,
    required String operationName,
    required double Function(double otherValue) operationFunc,
    required DataType Function(
      ArbitraryPrecisionDataType otherValue,
    ) arbitraryFunc,
  }) {
    if (other is IntegerDataType) {
      final result = operationFunc(other.value.toDouble());
      return this.createInstance(result);
    } else if (other is FloatingPointDataType) {
      final (thisPrecision, maxPrecision) = _getPrecisions(other);
      final result = operationFunc(other.value);

      if (maxPrecision == thisPrecision) {
        return this.createInstance(result);
      } else {
        return other.createInstance(result);
      }
    } else if (other is ArbitraryPrecisionDataType) {
      final result = arbitraryFunc(other);
      if (other is Numeric) {
        return result.toNumeric();
      } else if (other is Decimal) {
        return result.toDecimal();
      }
    } else if (other is int) {
      final result = operationFunc(other.toDouble());
      return this.createInstance(result);
    } else if (other is double) {
      return this.createInstance(operationFunc(other));
    }

    throw ArgumentError(
      '$operationName of floating point types is not supported with ${other.runtimeType}',
    );
  }
}

class Real extends FloatingPointDataType<Real> {
  static const maxValue = 3.40282347e+38;
  static const minValue = -3.40282347e+38;

  Real(super.floatValue);

  @override
  double get _maxValue => maxValue;

  @override
  double get _minValue => minValue;

  @override
  int get _maxDecimalPlaces => 6;

  @override
  String get _className => 'Real';

  @override
  Real createInstance(double value) => Real(value);

  @override
  bool identicalTo(DataType other) => other is Real && value == other.value;

  @override
  bool closeTo(DataType other, double delta) {
    if (delta.isNaN || delta.isInfinite) {
      throw ArgumentError('Delta must be finite.');
    }

    if (delta.isNegative) {
      throw ArgumentError('Delta must be non-negative.');
    }

    if (other is! Real) {
      return false;
    }

    return (value - other.value).abs() <= delta;
  }

  static final zero = Real(0);
  static final max = Real(Real.maxValue);
  static final min = Real(Real.minValue);

  static bool isValid(double floatValue) {
    try {
      Real(floatValue);
      return true;
    } catch (err) {
      return false;
    }
  }

  static Real? tryCreate(double floatValue) {
    try {
      return Real(floatValue);
    } catch (err) {
      return null;
    }
  }
}

class DoublePrecision extends FloatingPointDataType<DoublePrecision> {
  static const maxValue = 1.7976931348623157e+308;
  static const minValue = -1.7976931348623157e+308;

  DoublePrecision(super.floatValue);

  @override
  double get _maxValue => maxValue;

  @override
  double get _minValue => minValue;

  @override
  int get _maxDecimalPlaces => 15;

  @override
  String get _className => 'DoublePrecision';

  @override
  DoublePrecision createInstance(double value) => DoublePrecision(value);

  @override
  bool identicalTo(DataType other) =>
      other is DoublePrecision && value == other.value;

  @override
  bool closeTo(DataType other, double delta) {
    if (delta.isNaN || delta.isInfinite) {
      throw ArgumentError('Delta must be finite.');
    }

    if (delta.isNegative) {
      throw ArgumentError('Delta must be non-negative.');
    }

    if (other is! DoublePrecision) {
      return false;
    }

    return (value - other.value).abs() <= delta;
  }

  static final zero = DoublePrecision(0);
  static final max = DoublePrecision(DoublePrecision.maxValue);
  static final min = DoublePrecision(DoublePrecision.minValue);

  static bool isValid(double floatValue) {
    try {
      DoublePrecision(floatValue);
      return true;
    } catch (err) {
      return false;
    }
  }

  static DoublePrecision? tryCreate(double floatValue) {
    try {
      return DoublePrecision(floatValue);
    } catch (err) {
      return null;
    }
  }
}
