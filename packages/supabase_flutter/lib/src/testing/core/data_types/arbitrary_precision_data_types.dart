import 'dart:math';

import 'package:decimal/decimal.dart' as d;
import 'package:supabase_flutter/src/testing/core/data_types/character_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/floating_point_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/primitive_data_types_extension.dart';
import 'package:supabase_flutter/src/testing/supabase_test_extensions.dart';

abstract class ArbitraryPrecisionDataType<
    T extends ArbitraryPrecisionDataType<T>> extends FractionalDataType {
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

    final trimmed = value.trim();

    hasBoundedScale = floatScale != null;

    // We need to check if value is unconstrained from the get-go
    // so other methods can recognize if they can use precision
    // and scale
    isUnconstrained = floatPrecision == null && !hasBoundedScale;

    // If value is in scientific notation, convert it back
    // to full precision by using Decimal.
    if (_isScientificNotation(trimmed)) {
      _originalString = d.Decimal.parse(trimmed).toString();
    } else {
      _originalString = trimmed;
    }

    if (!_isValidNumeric(_originalString)) {
      throw ArgumentError('The string \'$_originalString\' is not valid.');
    }

    // If it is not unconstrained, then precision and scale need
    // to be set before calling any other method
    if (!isUnconstrained) {
      precision = floatPrecision!;
      scale = floatScale ?? 0;
    } else {
      _calculateUnconstrained(_originalString);
    }

    _calculateDigitsBeforeAndAfter();

    if (digitsBefore > Numeric.maxDigitsBefore) {
      throw RangeError(
        'The amount of digits before the fractional point exceeded the maximum limit.',
      );
    }

    if (digitsAfter > Numeric.maxDigitsAfter) {
      throw RangeError(
        'The amount of digits after the fractional point exceeded the maximum limit.',
      );
    }

    if (hasBoundedScale && scale < 0) {
      _calculateNegativeScaleValue();
    } else {
      rawValueString = _clamp(_originalString, isUnconstrained);
    }

    _value = d.Decimal.parse(rawValueString);
    maxValue = _calculateMaxValue();
    minValue = '-$maxValue';
  }

  static const int maxDigitsBefore = 131072;
  static const int maxDigitsAfter = 16383;

  late final String maxValue;
  late final String minValue;

  late final int precision;
  late final int scale;
  late final bool isUnconstrained;
  late final bool hasBoundedScale;
  late final int digitsBefore;
  late final int digitsAfter;
  late final String rawValueString;

  late final d.Decimal _value;
  late final String _originalString;

  // Getters
  bool get isFractional => !isUnconstrained && precision == scale;
  bool get isNegative => this < 0;
  bool get hasDecimalPoint => this.scale > 0;
  int get sign => compareTo(0);
  String get value => toString();

  T createInstance(int? floatPrecision, int? floatScale, String value);

  T abs() {
    if (isNegative) {
      return this.createInstance(
        precision,
        scale < 0 ? 0 : scale,
        value.substring(1),
      );
    }

    return this.createInstance(precision, scale < 0 ? 0 : scale, value);
  }

  T ceil({int ceilScale = 0}) {
    final treatedScale = scale < 0 ? 0 : scale;
    final newCeilScale = ceilScale < 0 ? 0 : ceilScale;
    final rounded = _value.ceil(scale: ceilScale);
    final plainString = rounded.toString();

    if (precision == treatedScale) {
      late final String newValue;

      if (plainString.contains('.')) {
        newValue = _removeSign(plainString);
      } else {
        newValue = _removeSign('$plainString.0');
      }

      final splitted = newValue.split('.');
      final integerPart = splitted[0];
      final isResultFractional =
          integerPart.length == 1 && integerPart[0] == '0';

      if (!isResultFractional) {
        final newPrecision = integerPart.length + treatedScale;
        return this.createInstance(
          newPrecision,
          treatedScale,
          plainString,
        );
      }

      if (newCeilScale != 0) {
        return this.createInstance(
          newCeilScale,
          newCeilScale,
          plainString,
        );
      }
    }

    if (treatedScale == 0 && newCeilScale != 0) {
      final newScale = newCeilScale;
      final newPrecision = precision + newScale;
      return this.createInstance(
        newPrecision,
        newScale,
        plainString,
      );
    }

    return this.createInstance(
      newCeilScale != 0 ? precision - newCeilScale : precision,
      newCeilScale != 0 ? newCeilScale : treatedScale,
      plainString,
    );
  }

  T clamp(
    ArbitraryPrecisionDataType lowerLimit,
    ArbitraryPrecisionDataType upperLimit,
  ) {
    if (lowerLimit > upperLimit) {
      throw ArgumentError(
        'Lower limit cannot be greater than the upper limit.',
      );
    }

    final lowerDec = d.Decimal.parse(lowerLimit.value);
    final upperDec = d.Decimal.parse(upperLimit.value);
    final clamped = _value.clamp(lowerDec, upperDec);

    late final int newScale;
    late final int newPrecision;

    if (_value != clamped) {
      final lowerScale = lowerLimit.scale < 0 ? 0 : lowerLimit.scale;
      final upperScale = upperLimit.scale < 0 ? 0 : upperLimit.scale;
      final highestBoundScale = max(lowerScale, upperScale);
      final highestBoundPrecision = max(
        lowerLimit.precision,
        upperLimit.precision,
      );

      newScale = max(highestBoundScale, scale < 0 ? 0 : scale);
      newPrecision = max(highestBoundPrecision, precision);
    } else {
      newScale = scale < 0 ? 0 : scale;
      newPrecision = precision;
    }

    return this.createInstance(newPrecision, newScale, clamped.toString());
  }

  T floor({int floorScale = 0}) {
    final treatedScale = scale < 0 ? 0 : scale;
    final newFloorScale = floorScale < 0 ? 0 : floorScale;
    final rounded = _value.floor(scale: floorScale);
    final plainString = rounded.toString();

    if (precision == treatedScale) {
      late final String newValue;

      if (plainString.contains('.')) {
        newValue = _removeSign(plainString);
      } else {
        newValue = _removeSign('$plainString.0');
      }

      final splitted = newValue.split('.');
      final integerPart = splitted[0];
      final isResultFractional =
          integerPart.length == 1 && integerPart[0] == '0';

      if (!isResultFractional) {
        final newPrecision = integerPart.length + treatedScale;
        return this.createInstance(
          newPrecision,
          treatedScale,
          plainString,
        );
      }
    }

    if (treatedScale == 0 && newFloorScale != 0) {
      final newScale = newFloorScale;
      final newPrecision = precision + newScale;
      return this.createInstance(
        newPrecision,
        newScale,
        plainString,
      );
    }

    return this.createInstance(
      newFloorScale != 0 ? precision - newFloorScale : precision,
      newFloorScale != 0 ? newFloorScale : treatedScale,
      plainString,
    );
  }

  T pow(int exponent) {
    if (_value == d.Decimal.zero && exponent < 0) {
      throw ArgumentError(
        'Exponentiation of zero base with negative exponent is not allowed.',
      );
    }

    final result = _value.pow(exponent);
    final castDec = result.toDecimal(scaleOnInfinitePrecision: scale);
    final castNum = Numeric(value: castDec.toString());
    late final String plainString;

    if (castNum.scale == 0 && scale > 0) {
      plainString = '${castDec.toString()}.0';
    } else {
      plainString = castDec.toString();
    }

    final (newPrecision, newScale) =
        _getPrecisionAndScaleFromString(plainString);

    return this.createInstance(
      newPrecision,
      newScale,
      plainString,
    );
  }

  T remainder(ArbitraryPrecisionDataType other) => (this % other) as T;

  T round({int roundScale = 0}) {
    final treatedScale = scale < 0 ? 0 : scale;
    final newRoundScale = roundScale < 0 ? 0 : roundScale;
    final rounded = _value.round(scale: roundScale);
    final plainString = rounded.toString();

    if (precision == treatedScale) {
      late final String newValue;

      if (plainString.contains('.')) {
        newValue = _removeSign(plainString);
      } else {
        newValue = _removeSign('$plainString.0');
      }

      final splitted = newValue.split('.');
      final integerPart = splitted[0];
      final isResultFractional =
          integerPart.length == 1 && integerPart[0] == '0';

      if (!isResultFractional) {
        final newPrecision = integerPart.length + treatedScale;
        return this.createInstance(
          newPrecision,
          treatedScale,
          plainString,
        );
      }
    }

    if (treatedScale == 0 && newRoundScale != 0) {
      final newScale = newRoundScale;
      final newPrecision = precision + newScale;
      return this.createInstance(
        newPrecision,
        newScale,
        plainString,
      );
    }

    return this.createInstance(
      newRoundScale != 0 ? precision - newRoundScale : precision,
      newRoundScale != 0 ? newRoundScale : treatedScale,
      plainString,
    );
  }

  T shift(int value) {
    final result = _value.shift(value);
    final plainString = result.toString();
    final (newPrecision, newScale) =
        _getPrecisionAndScaleFromString(plainString);

    return this.createInstance(
      newPrecision,
      newScale,
      plainString,
    );
  }

  T truncate() {
    final result = _value.truncate();
    final plainString = result.toString();
    final (newPrecision, newScale) =
        _getPrecisionAndScaleFromString(plainString);

    return this.createInstance(
      newPrecision,
      newScale,
      plainString,
    );
  }

  @override
  int compareTo(Object other) {
    if (other is IntegerDataType) {
      return this.compareTo(other.toNumeric());
    } else if (other is FloatingPointDataType) {
      return this.compareTo(other.toNumeric());
    } else if (other is ArbitraryPrecisionDataType) {
      final decimalCast = d.Decimal.parse(other.value);
      if (_value < decimalCast) {
        return -1;
      } else if (_value > decimalCast) {
        return 1;
      } else {
        return 0;
      }
    } else if (other is CharacterDataType) {
      return value.compareTo(other.value);
    } else if (other is int) {
      return this.compareTo(other.toNumeric());
    } else if (other is double) {
      return this.compareTo(other.toNumeric());
    } else if (other is String) {
      return value.compareTo(other);
    }

    throw ArgumentError(
      'Comparison of arbitrary precision types is not supported with ${other.runtimeType}',
    );
  }

  // Unary operators
  @override
  DataType operator -() {
    if (isNegative) {
      return this.createInstance(precision, scale, value.substring(1));
    } else {
      return this.createInstance(precision, scale, '-$value');
    }
  }

  // Arithmetic operators
  @override
  DataType operator +(Object other) {
    return _performOperation(
      other: other,
      operationName: 'Addition',
      operationFunc: (otherValue) {
        final (newPrecision, newScale, newValue) = _safeAdd(
          this,
          otherValue,
        );

        return this.createInstance(newPrecision, newScale, newValue);
      },
    );
  }

  @override
  DataType operator -(Object other) {
    return _performOperation(
      other: other,
      operationName: 'Subtraction',
      operationFunc: (otherValue) {
        final (newPrecision, newScale, newValue) = _safeSubtract(
          this,
          otherValue,
        );

        return this.createInstance(newPrecision, newScale, newValue);
      },
    );
  }

  @override
  DataType operator *(Object other) {
    return _performOperation(
      other: other,
      operationName: 'Multiplication',
      operationFunc: (otherValue) {
        final (newPrecision, newScale, newValue) = _safeMultiply(
          this,
          otherValue,
        );

        return this.createInstance(newPrecision, newScale, newValue);
      },
    );
  }

  @override
  DataType operator /(Object other) {
    return _performOperation(
      other: other,
      operationName: 'Division',
      operationFunc: (otherValue) {
        final (newPrecision, newScale, newValue) = _safeDivide(
          this,
          otherValue,
        );

        return this.createInstance(newPrecision, newScale, newValue);
      },
    );
  }

  @override
  DataType operator ~/(Object other) {
    return _performOperation(
      other: other,
      operationName: 'Integer division',
      operationFunc: (otherValue) {
        final (newPrecision, newScale, newValue) = _safeIntegerDivide(
          this,
          otherValue,
        );

        final integerCast = Numeric(
          value: newValue,
          precision: newPrecision,
          scale: newScale,
        ).toMostPreciseInt();

        if (integerCast is Numeric) {
          throw RangeError('Integer division result out of range.');
        }

        return integerCast;
      },
    );
  }

  @override
  DataType operator %(Object other) {
    return _performOperation(
      other: other,
      operationName: 'Modulo',
      operationFunc: (otherValue) {
        final (newPrecision, newScale, newValue) = _safeModulo(
          this,
          otherValue,
        );

        return this.createInstance(newPrecision, newScale, newValue);
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
    throw UnsupportedError(
      'Bitwise AND is not supported by arbitrary precision types.',
    );
  }

  @override
  T operator ^(Object other) {
    throw UnsupportedError(
      'Bitwise XOR is not supported by arbitrary precision types.',
    );
  }

  @override
  T operator |(Object other) {
    throw UnsupportedError(
      'Bitwise OR is not supported by arbitrary precision types.',
    );
  }

  @override
  DataType operator <<(Object other) {
    throw UnsupportedError(
      'Left shift is not supported by arbitrary precision types.',
    );
  }

  @override
  DataType operator >>(Object other) {
    throw UnsupportedError(
      'Right shift is not supported by arbitrary precision types.',
    );
  }

  @override
  DataType operator >>>(Object other) {
    throw UnsupportedError(
      'Unsigned right shift is not supported by arbitrary precision types.',
    );
  }

  // Indexing operators
  @override
  DataType operator [](int index) {
    throw UnsupportedError(
      'Index operator is not supported by arbitrary precision types.',
    );
  }

  @override
  void operator []=(int index, Object value) {
    throw UnsupportedError(
      'Index assignment is unsupported by arbitrary precision types.',
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
  int get hashCode {
    return Object.hash(
      maxValue,
      minValue,
      precision,
      scale,
      digitsBefore,
      digitsAfter,
      rawValueString,
      _value,
      _originalString,
    );
  }

  // Cast methods

  // Primitives
  @override
  String toString() => _toString();

  @override
  String toDetailedString() =>
      'Precision: $precision, Scale: $scale, Value: $value';

  @override
  int toPrimitiveInt() {
    // If value is out of BigInteger range, then it is not a
    // representable value for a dart int primitive, as it
    // would throw a FormatException when trying to parse it.
    final min = BigInteger(BigInteger.minValue);
    final max = BigInteger(BigInteger.maxValue);
    if (this < min || this > max) {
      throw RangeError('Integer out of range.');
    }

    late final String parseValue;
    if (hasDecimalPoint) {
      parseValue = value.split('.')[0];
    } else {
      parseValue = value;
    }

    return int.parse(parseValue);
  }

  @override
  double toPrimitiveDouble() {
    final result = double.parse(_value.toString());

    if (result.isInfinite || result.isNaN) {
      throw RangeError('Double primitive out of range.');
    }

    return result;
  }

  // Integer
  @override
  SmallInteger toSmallInteger() => SmallInteger(toPrimitiveInt());

  @override
  Integer toInteger() => Integer(toPrimitiveInt());

  @override
  BigInteger toBigInteger() => BigInteger(toPrimitiveInt());

  @override
  SmallSerial toSmallSerial() => SmallSerial(toPrimitiveInt());

  @override
  Serial toSerial() => Serial(toPrimitiveInt());

  @override
  BigSerial toBigSerial() => BigSerial(toPrimitiveInt());

  DataType toMostPreciseInt() {
    if (isWithinSmallIntegerRange()) {
      return toSmallInteger();
    } else if (isWithinIntegerRange()) {
      return toInteger();
    } else if (isWithinBigIntegerRange()) {
      return toBigInteger();
    } else {
      return toNumeric().truncate();
    }
  }

  // Floating point
  @override
  Real toReal() => Real(toPrimitiveDouble());

  @override
  DoublePrecision toDoublePrecision() => DoublePrecision(toPrimitiveDouble());

  DataType toMostPreciseFloat() {
    if (isWithinRealRange()) {
      return toReal();
    } else if (isWithinDoublePrecisionRange()) {
      return toDoublePrecision();
    } else {
      return toNumeric();
    }
  }

  // Arbitrary precision
  @override
  Numeric toNumeric() {
    final newValue = toString();
    final withoutSign = _removeSign(newValue);

    if (precision == scale) {
      return Numeric(
        value: newValue,
        precision: precision,
        scale: scale,
      );
    }

    late final int newScale;
    late final int newPrecision;

    if (withoutSign.contains('.')) {
      final splitted = withoutSign.split('.');
      newScale = _countScale(withoutSign);
      newPrecision = splitted[0].length + newScale;
    } else {
      newScale = 0;
      newPrecision = withoutSign.length;
    }

    return Numeric(value: newValue, precision: newPrecision, scale: newScale);
  }

  @override
  Decimal toDecimal() {
    final numeric = toNumeric();
    return Decimal(
      value: numeric.value,
      precision: numeric.precision,
      scale: numeric.scale,
    );
  }

  // Character
  @override
  Char toChar() => Char(value, length: value.length);

  @override
  VarChar toVarChar() => VarChar(value, length: value.length);

  @override
  Text toText() => Text(value);

  // Range methods
  bool isWithinSmallIntegerRange() =>
      _value.truncate() >= d.Decimal.fromInt(SmallInteger.minValue) &&
      _value.truncate() <= d.Decimal.fromInt(SmallInteger.maxValue);

  bool isWithinIntegerRange() =>
      _value.truncate() >= d.Decimal.fromInt(Integer.minValue) &&
      _value.truncate() <= d.Decimal.fromInt(Integer.maxValue);

  bool isWithinBigIntegerRange() =>
      _value.truncate() >= d.Decimal.fromInt(BigInteger.minValue) &&
      _value.truncate() <= d.Decimal.fromInt(BigInteger.maxValue);

  bool isWithinRealRange() =>
      _value >= d.Decimal.parse(Real.minValue.toString()) &&
      _value <= d.Decimal.parse(Real.maxValue.toString());

  bool isWithinDoublePrecisionRange() =>
      _value >= d.Decimal.parse(DoublePrecision.minValue.toString()) &&
      _value <= d.Decimal.parse(DoublePrecision.maxValue.toString());

  // Private methods
  String _toString() {
    final valueString = _value.toString();

    // In case there's no fractional point, the value
    // can be returned directly, as Postgres does not
    // use padding in the integer part of the value
    // string representation
    if (hasBoundedScale && scale <= 0) {
      return valueString;
    }

    if (valueString.contains('.')) {
      final splitted = valueString.split('.');
      final actualScale = splitted[1].length;

      // If value is unconstrained, you can't rely on 'scale'
      // to know whether trailing zeroes are necessary or not
      // so you need to calculate the scale of the original
      // value by counting the decimal places of rawRangeString
      if (isUnconstrained) {
        final decLen = rawValueString.split('.')[1].length;

        if (actualScale < decLen) {
          final decimalPart = splitted[1];
          final padded = decimalPart.padRight(decLen, '0');
          return '${splitted[0]}.$padded';
        } else {
          return valueString;
        }
      }

      if (actualScale < scale) {
        final decimalPart = splitted[1];
        final padded = decimalPart.padRight(scale, '0');
        return '${splitted[0]}.$padded';
      } else {
        return valueString;
      }
    } else {
      if (rawValueString.contains('.')) {
        final decimalPart = '.${rawValueString.split('.')[1]}';
        return valueString + decimalPart;
      }

      return valueString;
    }
  }

  (int, int) _getPrecisionAndScaleFromString(String value) {
    final withoutSign = _removeSign(value);
    final newScale = _countScale(withoutSign);

    late final int newPrecision;
    if (newScale > 0) {
      newPrecision = withoutSign.split('.')[0].length + newScale;
    } else {
      newPrecision = withoutSign.length;
    }

    return (newPrecision, newScale);
  }

  String _calculateMaxValue() {
    if (isUnconstrained) {
      late final int integerLen;
      late final int decimalLen;
      late final String pointString;

      if (rawValueString.contains('.')) {
        final splitted = rawValueString.split('.');
        integerLen = splitted[0].length;
        decimalLen = splitted[1].length;
        pointString = '.';
      } else {
        integerLen = _removeSign(rawValueString).length;
        decimalLen = 0;
        pointString = '';
      }

      final beforeString = '9' * integerLen;
      final afterString = '9' * decimalLen;

      return beforeString + pointString + afterString;
    }

    final beforeString = '9' * digitsBefore;
    final afterString = '9' * digitsAfter;
    final hasPoint = rawValueString.contains('.');
    final isNegative = scale < 0;
    final pointString = hasPoint && !isNegative ? '.' : '';

    if (beforeString == '') {
      return '0$pointString$afterString';
    }

    return beforeString + pointString + afterString;
  }

  d.Decimal _roundToScale(String value, int scale) {
    final factor = d.Decimal.parse('10').pow(-scale).toDecimal();
    final valueDecimal = d.Decimal.parse(value);
    return (valueDecimal / factor).round().toDecimal() * factor;
  }

  bool _isScientificNotation(String value) {
    // Regular expression for matching scientific notation
    // Matches patterns like 1.23e+10, 1E-10, etc.
    final regex = RegExp(r'^[+\-]?\d+(\.\d+)?[eE][+\-]?\d+$');

    return regex.hasMatch(value);
  }

  bool _isValidNumeric(String value) {
    if (value.trim().isEmpty) {
      return false;
    }

    if (!_containsAtLeastOneNumber(value)) {
      return false;
    }

    if (!_hasAllowedCharacters(value)) {
      return false;
    }

    if (!_hasValidNegation(value)) {
      return false;
    }

    if (!_hasValidFractional(value)) {
      return false;
    }

    return true;
  }

  bool _hasAllowedCharacters(String value) =>
      RegExp(r'^[-.\d]+$').hasMatch(value);

  bool _hasValidNegation(String value) {
    final hyphenCount = value.count('-');

    if (hyphenCount == 0) {
      return true;
    }

    if (hyphenCount == 1 && value[0] == '-') {
      return true;
    }

    return false;
  }

  bool _hasValidFractional(String value) {
    if (value.contains('.')) {
      final isNegated = value[0] == '-';
      final hasRightAmount = value.count('.') == 1;
      final isInTheBeginning = value[0] == '.';
      final isInTheEnd = value[value.length - 1] == '.';

      if (isNegated) {
        return value[1] != '.' && !isInTheEnd && hasRightAmount;
      }

      return !isInTheBeginning && !isInTheEnd && hasRightAmount;
    }

    return true;
  }

  bool _containsAtLeastOneNumber(String value) => RegExp(r'\d').hasMatch(value);

  (String, String) _extractBeforeAndAfter(String value) {
    final valueSplit = value.split('.');

    return (valueSplit[0], valueSplit[1]);
  }

  void _calculateDigitsBeforeAndAfter() {
    if (!isUnconstrained) {
      // If neither precision nor scale are null, then digits before
      // and after are calculated normally
      if (scale < 0) {
        digitsBefore = precision;
        digitsAfter = 0;
      } else {
        digitsBefore = precision - scale;
        digitsAfter = precision - digitsBefore;
      }
    } else if (!isUnconstrained && !hasBoundedScale) {
      // If only scale is null, then digitsAfter is 0 because it
      // treats the number as having no fractional point
      digitsBefore = precision;
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
    final rounded = _roundToScale(before, scale).toString();
    rawValueString = rounded;
  }

  void _calculateUnconstrained(String unconstrainedValue) {
    final withoutSign = _removeSign(unconstrainedValue);

    if (withoutSign.contains('.')) {
      final splitted = withoutSign.split('.');
      scale = splitted[1].length;
      precision = splitted[0].length + scale;
    } else {
      precision = withoutSign.length;
      scale = 0;
    }
  }

  String _clamp(String value, bool isUnconstrained) {
    final withoutSign = _removeSign(value);
    final isValueNegative = value[0] == '-';

    late final String before;
    late final String? after;
    if (value.count('.') == 1) {
      (before, after) = _extractBeforeAndAfter(withoutSign);
    } else {
      before = withoutSign;

      if (!isUnconstrained && scale > 0) {
        after = '0' * scale;
      } else {
        after = null;
      }
    }

    late final String newBefore;
    late final String newAfter;

    if (digitsBefore == 0) {
      // If there are no digits before the fractional point
      // then the value only considers numbers after the point
      // therefore, the final value is less than 1 but greater
      // than -1.
      newBefore = isValueNegative ? '-0' : '0';
    } else if (before.length < digitsBefore) {
      late final String processedBefore;

      // If there are less digits in the actual number compared
      // to the expected amount, then leading 0s are added.
      if (isUnconstrained) {
        processedBefore = before;
      } else {
        processedBefore = before.padLeft(digitsBefore, '0');
      }

      newBefore = isValueNegative ? '-$processedBefore' : processedBefore;
    } else if (before.length > digitsBefore) {
      // If there are more digits than expected, the part
      // before the fractional point is cut.
      final processedBefore = before.substring(0, digitsBefore);
      newBefore = isValueNegative ? '-$processedBefore' : processedBefore;
    } else {
      newBefore = isValueNegative ? '-$before' : before;
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

  int _countScale(String value) {
    if (value.contains('.')) {
      return value.split('.')[1].length;
    } else {
      return 0;
    }
  }

  String _removeSign(String value) {
    if (value[0] == '-') {
      return value.substring(1);
    }
    return value;
  }

  // Arithmetic private methods
  (int, int, String) _safeAdd(
    ArbitraryPrecisionDataType a,
    ArbitraryPrecisionDataType b,
  ) {
    final result = d.Decimal.parse(a.value) + d.Decimal.parse(b.value);
    final plainString = result.toString();
    // If the value has a minus sign it must be removed
    // so it won't count as the string's length
    final withoutSign = _removeSign(plainString);

    late final int newScale;
    late final int newPrecision;
    late final String integerPart;

    if (withoutSign.contains('.')) {
      integerPart = withoutSign.split('.')[0];
      newScale = _countScale(withoutSign);
    } else {
      integerPart = withoutSign;

      if (a.scale < 0 && b.scale < 0) {
        newScale = 0;
      } else {
        newScale = max(a.scale, b.scale);
      }
    }

    final isResultFractional = integerPart.length == 1 && integerPart[0] == '0';

    if (a.isFractional && b.isFractional && isResultFractional) {
      newPrecision = newScale;
    } else if (newScale > 0) {
      newPrecision = integerPart.length + newScale;
    } else {
      newPrecision = withoutSign.length;
    }

    return (newPrecision, newScale, plainString);
  }

  (int, int, String) _safeSubtract(
    ArbitraryPrecisionDataType a,
    ArbitraryPrecisionDataType b,
  ) {
    final result = d.Decimal.parse(a.value) - d.Decimal.parse(b.value);
    final plainString = result.toString();
    // If the value has a minus sign it must be removed
    // so it won't count as the string's length
    final withoutSign = _removeSign(plainString);

    late final int newScale;
    late final int newPrecision;
    late final String integerPart;

    if (withoutSign.contains('.')) {
      integerPart = withoutSign.split('.')[0];
      newScale = _countScale(withoutSign);
    } else {
      integerPart = withoutSign;
      if (a.scale < 0 && b.scale < 0) {
        newScale = 0;
      } else {
        newScale = max(a.scale, b.scale);
      }
    }

    final isResultFractional = integerPart.length == 1 && integerPart[0] == '0';

    if (a.isFractional && b.isFractional && isResultFractional) {
      newPrecision = newScale;
    } else if (newScale > 0) {
      newPrecision = withoutSign.split('.')[0].length + newScale;
    } else {
      newPrecision = withoutSign.length;
    }

    return (newPrecision, newScale, plainString);
  }

  (int, int, String) _safeMultiply(
    ArbitraryPrecisionDataType a,
    ArbitraryPrecisionDataType b,
  ) {
    final result = d.Decimal.parse(a.value) * d.Decimal.parse(b.value);
    final plainString = result.toString();
    // If the value has a minus sign it must be removed
    // so it won't count as the string's length
    final withoutSign = _removeSign(plainString);

    late final int newScale;

    // If any of the scales are negative, then the new scale is
    // always zero.
    final hasADec = a.hasDecimalPoint;
    final hasBDec = b.hasDecimalPoint;
    if ((!hasADec && !hasBDec) && (a.scale < 0 || b.scale < 0)) {
      newScale = 0;
    } else {
      // We still need to calculate the scale like this to ensure
      // the final scale is calculated correctly when scales are
      // negative
      final newAScale = a.scale.isNegative ? 0 : a.scale;
      final newBScale = b.scale.isNegative ? 0 : b.scale;
      newScale = newAScale + newBScale;
    }

    late final int newPrecision;

    if (a.isFractional && b.isFractional) {
      newPrecision = newScale;
    } else if (newScale > 0) {
      newPrecision = withoutSign.split('.')[0].length + newScale;
    } else {
      newPrecision = withoutSign.length;
    }

    return (newPrecision, newScale, plainString);
  }

  (int, int, String) _safeDivide(
    ArbitraryPrecisionDataType a,
    ArbitraryPrecisionDataType b,
  ) {
    final bParsed = d.Decimal.parse(b.value);

    if (bParsed == d.Decimal.zero) {
      throw ArgumentError('Division by zero is not allowed.');
    }

    final result = d.Decimal.parse(a.value) / bParsed;
    final plainString =
        result.toDecimal(scaleOnInfinitePrecision: 20).toString();

    // If the value has a minus sign it must be removed
    // so it won't count as the string's length
    final withoutSign = _removeSign(plainString);
    const newScale = 20;

    late final String integerPart;

    if (withoutSign.contains('.')) {
      integerPart = withoutSign.split('.')[0];
    } else {
      integerPart = withoutSign;
    }

    final isResultFractional = integerPart.length == 1 && integerPart[0] == '0';

    late final int newPrecision;

    if (a.isFractional && b.isFractional && isResultFractional) {
      newPrecision = newScale;
    } else if (newScale > 0) {
      if (withoutSign.contains('.')) {
        newPrecision = withoutSign.split('.')[0].length + newScale;
      } else {
        newPrecision = withoutSign.length + newScale;
      }
    } else {
      newPrecision = withoutSign.length;
    }

    return (newPrecision, newScale, plainString);
  }

  (int, int, String) _safeIntegerDivide(
    ArbitraryPrecisionDataType a,
    ArbitraryPrecisionDataType b,
  ) {
    final bParsed = d.Decimal.parse(b.value);

    if (bParsed == d.Decimal.zero) {
      throw ArgumentError('Integer division by zero is not allowed.');
    }

    final result = d.Decimal.parse(a.value) ~/ bParsed;
    final plainString = result.toString();

    // If the value has a minus sign it must be removed
    // so it won't count as the string's length
    final withoutSign = _removeSign(plainString);

    return (withoutSign.length, 0, plainString);
  }

  (int, int, String) _safeModulo(
    ArbitraryPrecisionDataType a,
    ArbitraryPrecisionDataType b,
  ) {
    final bParsed = d.Decimal.parse(b.value);

    if (bParsed == d.Decimal.zero) {
      throw ArgumentError('Modulo by zero is not allowed.');
    }

    // The remainder() method is used instead of the actual %
    // operator, because Postgres implements the standard remainder
    // where negative values are also allowed.
    final result = d.Decimal.parse(a.value).remainder(bParsed);
    final plainString = result.toString();

    // If the value has a minus sign it must be removed
    // so it won't count as the string's length
    final withoutSign = _removeSign(plainString);

    late final int newScale;

    if (withoutSign.contains('.')) {
      newScale = _countScale(withoutSign);
    } else {
      if (a.hasDecimalPoint || b.hasDecimalPoint) {
        newScale = 1;
      } else {
        newScale = 0;
      }
    }

    late final int newPrecision;

    if (a.isFractional && b.isFractional) {
      newPrecision = newScale;
    } else if (newScale > 0) {
      newPrecision = withoutSign.split('.')[0].length + newScale;
    } else {
      newPrecision = withoutSign.length;
    }

    return (newPrecision, newScale, plainString);
  }

  DataType _performOperation({
    required Object other,
    required String operationName,
    required DataType Function(Numeric otherValue) operationFunc,
  }) {
    if (other is IntegerDataType) {
      return operationFunc(other.toNumeric());
    } else if (other is FloatingPointDataType) {
      return operationFunc(other.toNumeric());
    } else if (other is ArbitraryPrecisionDataType) {
      return operationFunc(other.toNumeric());
    } else if (other is int) {
      return operationFunc(other.toNumeric());
    } else if (other is double) {
      return operationFunc(other.toNumeric());
    }

    throw ArgumentError(
      '$operationName of int types is not supported with ${other.runtimeType}',
    );
  }
}

class Numeric extends ArbitraryPrecisionDataType<Numeric> {
  static const int maxDigitsBefore = 131072;
  static const int maxDigitsAfter = 16383;
  static const int defaultScaleForInfiniteDecimal = 20;

  Numeric({int? precision, int? scale, required String value})
      : super(precision, scale, value);

  static final integerZero = Numeric(value: '0', precision: 1, scale: 0);
  static final floatZero = Numeric(value: '0.0', precision: 2, scale: 1);
  static final negativeOne = Numeric(value: '-1', precision: 1, scale: 0);
  static final positiveOne = Numeric(value: '1', precision: 1, scale: 0);

  static bool isValid({int? precision, int? scale, required String value}) {
    try {
      Numeric(value: value, precision: precision, scale: scale);
      return true;
    } catch (err) {
      return false;
    }
  }

  static Numeric? tryCreate(
      {int? precision, int? scale, required String value}) {
    try {
      return Numeric(value: value, precision: precision, scale: scale);
    } catch (err) {
      return null;
    }
  }

  @override
  bool identicalTo(DataType other) =>
      other is Numeric &&
      _value == d.Decimal.parse(other.value) &&
      precision == other.precision &&
      (scale < 0 ? 0 : scale) == (other.scale < 0 ? 0 : other.scale) &&
      isNegative == other.isNegative;

  @override
  Numeric createInstance(
    int? floatPrecision,
    int? floatScale,
    String value,
  ) =>
      Numeric(precision: floatPrecision, scale: floatScale, value: value);
}

class Decimal extends ArbitraryPrecisionDataType<Decimal> {
  static const int maxDigitsBefore = 131072;
  static const int maxDigitsAfter = 16383;
  static const int defaultScaleForInfiniteDecimal = 20;

  Decimal({int? precision, int? scale, required String value})
      : super(precision, scale, value);

  static final integerZero = Decimal(value: '0', precision: 1, scale: 0);
  static final floatZero = Decimal(value: '0.0', precision: 2, scale: 1);
  static final negativeOne = Decimal(value: '-1', precision: 1, scale: 0);
  static final positiveOne = Decimal(value: '1', precision: 1, scale: 0);

  static bool isValid({int? precision, int? scale, required String value}) {
    try {
      Decimal(value: value, precision: precision, scale: scale);
      return true;
    } catch (err) {
      return false;
    }
  }

  static Decimal? tryCreate(
      {int? precision, int? scale, required String value}) {
    try {
      return Decimal(value: value, precision: precision, scale: scale);
    } catch (err) {
      return null;
    }
  }

  @override
  bool identicalTo(DataType other) =>
      other is Decimal &&
      _value == d.Decimal.parse(other.value) &&
      precision == other.precision &&
      (scale < 0 ? 0 : scale) == (other.scale < 0 ? 0 : other.scale) &&
      isNegative == other.isNegative;

  @override
  Decimal createInstance(
    int? floatPrecision,
    int? floatScale,
    String value,
  ) =>
      Decimal(precision: floatPrecision, scale: floatScale, value: value);
}
