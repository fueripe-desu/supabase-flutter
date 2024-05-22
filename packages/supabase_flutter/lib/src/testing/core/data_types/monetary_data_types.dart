import 'package:supabase_flutter/src/testing/core/currency/currency.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/character_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/floating_point_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/primitive_data_types_extension.dart';
import 'package:supabase_flutter/src/testing/core/locale/locale.dart';

class Money extends DataType {
  Money(
    String amount, {
    String? localeString,
    Currency? overrideCurrency,
  }) {
    _builder = MoneyBuilder();
    final localeManager = Locale();

    late final Currency localeCurrency;

    if (localeString != null && localeManager.localeExists(localeString)) {
      if (localeManager.localeExists(localeString)) {
        localeCurrency = localeManager.getLocaleByString(localeString).currency;
      } else {
        throw ArgumentError('Locale specified does not exist.');
      }
    } else {
      localeCurrency = localeManager.getCurrentCurrency();
    }

    currency = overrideCurrency ?? localeCurrency;
    minorUnits = _builder.build(amount, currency);
  }

  factory Money.fromMinorUnits(
    Numeric minorUnits, {
    String? localeString,
    int? monetaryPrecision,
    Currency? overrideCurrency,
  }) {
    final builder = MoneyBuilder();
    final localeCurrency = _getCurrency(
        localeString: localeString, overrideCurrency: overrideCurrency);
    final amount = builder.minorUnitsToString(minorUnits, localeCurrency);
    return Money(amount, overrideCurrency: localeCurrency);
  }

  late final Currency currency;
  late final Numeric minorUnits;

  late final MoneyBuilder _builder;

  @override
  bool identicalTo(DataType other) =>
      other is Money &&
      currency == other.currency &&
      minorUnits == other.minorUnits;

  @override
  int compareTo(Object other) {
    if (other is Money) {
      return minorUnits.compareTo(other.minorUnits);
    }

    throw ArgumentError(
      'Comparison cannot be performed between ${other.runtimeType} and Money type.',
    );
  }

  // Unary operators
  @override
  DataType operator -() {
    return Money.fromMinorUnits((-minorUnits) as Numeric);
  }

  // Arithmetic operators
  @override
  Money operator +(Object other) {
    if (other is Money) {
      final operation = (minorUnits + other.minorUnits) as Numeric;
      return Money.fromMinorUnits(operation, overrideCurrency: currency);
    }

    throw ArgumentError(
      'Addition cannot be performed between ${other.runtimeType} and Money type.',
    );
  }

  @override
  DataType operator -(Object other) {
    if (other is Money) {
      final operation = (minorUnits - other.minorUnits) as Numeric;
      return Money.fromMinorUnits(operation, overrideCurrency: currency);
    }

    throw ArgumentError(
      'Subtraction cannot be performed between ${other.runtimeType} and Money type.',
    );
  }

  @override
  DataType operator *(Object other) {
    return _performOperation(
      other: other,
      operationName: 'Mutliplication',
      operationFunc: (otherValue) {
        final operation = (minorUnits * other) as Numeric;
        final truncated = operation.round();
        return Money.fromMinorUnits(truncated);
      },
    );
  }

  @override
  DataType operator /(Object other) {
    return _performOperation(
      other: other,
      operationName: 'Division',
      operationFunc: (otherValue) {
        final operation = (minorUnits / other) as Numeric;
        final truncated = operation.truncate();
        return Money.fromMinorUnits(truncated);
      },
    );
  }

  @override
  DataType operator ~/(Object other) {
    throw UnsupportedError('Integer division is not supported by Money.');
  }

  @override
  DataType operator %(Object other) {
    throw UnsupportedError('Modulo is not supported by Money.');
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
    throw UnsupportedError('Bitwise AND is not supported by Money.');
  }

  @override
  DataType operator |(Object other) {
    throw UnsupportedError('Bitwise OR is not supported by Money.');
  }

  @override
  DataType operator ^(Object other) {
    throw UnsupportedError('Bitwise XOR is not supported by Money.');
  }

  @override
  DataType operator <<(Object other) {
    throw UnsupportedError('Left shift is not supported by Money.');
  }

  @override
  DataType operator >>(Object other) {
    throw UnsupportedError('Right shift is not supported by Money.');
  }

  @override
  DataType operator >>>(Object other) {
    throw UnsupportedError('Unsigned right shift is not supported by Money.');
  }

  // Indexing operators
  @override
  DataType? operator [](int index) {
    throw UnsupportedError('Index operator is not supported by Money.');
  }

  @override
  void operator []=(int index, Object value) {
    throw UnsupportedError('Index assignment is not supported by Money.');
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
  int get hashCode => currency.hashCode ^ minorUnits.hashCode;

  // Cast methods

  // Primitives
  @override
  String toString() => _builder.minorUnitsToString(minorUnits, currency);

  @override
  String toDetailedString() =>
      'Value: ${toString()}, Currency: ${currency.currencyName} (${currency.fullCurrencyName})';

  @override
  double toPrimitiveDouble() {
    throw UnsupportedError('Cannot cast type Money to double primitive.');
  }

  @override
  int toPrimitiveInt() {
    throw UnsupportedError('Cannot cast type Money to int primitive.');
  }

  // Integer
  @override
  SmallInteger toSmallInteger() {
    throw UnsupportedError('Cannot cast type Money to SmallInteger.');
  }

  @override
  Integer toInteger() {
    throw UnsupportedError('Cannot cast type Money to Integer.');
  }

  @override
  BigInteger toBigInteger() {
    throw UnsupportedError('Cannot cast type Money to BigInteger.');
  }

  @override
  SmallSerial toSmallSerial() {
    throw UnsupportedError('Cannot cast type Money to SmallSerial.');
  }

  @override
  Serial toSerial() {
    throw UnsupportedError('Cannot cast type Money to Serial.');
  }

  @override
  BigSerial toBigSerial() {
    throw UnsupportedError('Cannot cast type Money to BigSerial.');
  }

  // Floating point
  @override
  Real toReal() {
    throw UnsupportedError('Cannot cast type Money to Real.');
  }

  @override
  DoublePrecision toDoublePrecision() {
    throw UnsupportedError('Cannot cast type Money to DoublePrecision.');
  }

  // Arbitrary precision
  @override
  Numeric toNumeric() {
    final minor = minorUnits % currency.minorUnitsInMajor;
    final major = (minorUnits - minor) / currency.minorUnitsInMajor;
    final newMajor = (major as Numeric).truncate().abs();
    final rawMinor = (minor as Numeric).truncate().abs();
    final newMinor = Numeric(
      value: rawMinor.value,
      precision: currency.scalePrecision,
      scale: 0,
    );
    return Numeric(
      value: '${minorUnits.isNegative ? '-' : ''}$newMajor.$newMinor',
      precision: newMajor.precision + newMinor.precision,
      scale: currency.scalePrecision,
    );
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
  Char toChar() {
    final string = toString();
    return Char(string, length: string.length);
  }

  @override
  VarChar toVarChar() {
    final string = toString();
    return VarChar(string, length: string.length);
  }

  @override
  Text toText() => Text(toString());

  DataType _performOperation({
    required Object other,
    required String operationName,
    required Money Function(Numeric otherValue) operationFunc,
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
      '$operationName cannot be performed between ${other.runtimeType} and Money type.',
    );
  }

  static Currency _getCurrency(
      {String? localeString, Currency? overrideCurrency}) {
    final localeManager = Locale();

    late final Currency localeCurrency;

    if (localeString != null) {
      if (localeManager.localeExists(localeString)) {
        localeCurrency = localeManager.getLocaleByString(localeString).currency;
      }
    } else {
      localeCurrency = localeManager.getCurrentCurrency();
    }

    return overrideCurrency ?? localeCurrency;
  }
}
