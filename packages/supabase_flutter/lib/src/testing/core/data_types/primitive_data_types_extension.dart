import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/character_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/floating_point_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

extension PrimitiveInteger on int {
  // Primitives
  int toPrimitiveInt() => this;
  double toPrimitiveDouble() => toDouble();

  // Integer
  SmallInteger toSmallInteger() => SmallInteger(this);
  Integer toInteger() => Integer(this);
  BigInteger toBigInteger() => BigInteger(this);

  // Serial
  SmallSerial toSmallSerial() => SmallSerial(this);
  Serial toSerial() => Serial(this);
  BigSerial toBigSerial() => BigSerial(this);

  // Floating point
  Real toReal() => Real(toDouble());
  DoublePrecision toDoublePrecision() => DoublePrecision(toDouble());

  // Arbitrary precision
  Numeric toNumeric() {
    late final int precision;

    if (isNegative) {
      precision = toString().substring(1).length;
    } else {
      precision = toString().length;
    }

    return Numeric(value: toString(), precision: precision, scale: 0);
  }

  Decimal toDecimal() {
    late final int precision;

    if (isNegative) {
      precision = toString().substring(1).length;
    } else {
      precision = toString().length;
    }

    return Decimal(value: toString(), precision: precision, scale: 0);
  }

  // Character
  Char toChar() {
    final cast = toString();
    return Char(cast, length: cast.length);
  }

  VarChar toVarChar() {
    final cast = toString();
    return VarChar(cast, length: cast.length);
  }

  Text toText() => Text(toString());
}

extension PrimitiveDouble on double {
  // Primitives
  int toPrimitiveInt() => toInt();
  double toPrimitiveDouble() => this;

  // Integer
  SmallInteger toSmallInteger() => SmallInteger(toInt());
  Integer toInteger() => Integer(toInt());
  BigInteger toBigInteger() => BigInteger(toInt());

  // Serial
  SmallSerial toSmallSerial() => SmallSerial(toInt());
  Serial toSerial() => Serial(toInt());
  BigSerial toBigSerial() => BigSerial(toInt());

  // Floating point
  Real toReal() => Real(this);
  DoublePrecision toDoublePrecision() => DoublePrecision(this);

  // Arbitrary precision
  Numeric toNumeric() {
    if (isInfinite) {
      throw ArgumentError('Cannot cast infinite double primitives to Numeric.');
    }

    final valueString = toString();
    final unconstrained = Numeric(value: valueString);
    final withoutSign = unconstrained.abs().toString();
    final withSign = unconstrained.toString();

    if (withoutSign.contains('.')) {
      final splitted = withoutSign.split('.');
      final scale = splitted[1].length;
      final precision = splitted[0].length + scale;
      return Numeric(value: withSign, precision: precision, scale: scale);
    }

    return Numeric(
      value: withSign,
      precision: withoutSign.length + 1,
      scale: 1,
    );
  }

  Decimal toDecimal() => toNumeric().toDecimal();

  // Character
  Char toChar() {
    final cast = toString();
    return Char(cast, length: cast.length);
  }

  VarChar toVarChar() {
    final cast = toString();
    return VarChar(cast, length: cast.length);
  }

  Text toText() => Text(toString());
}

extension PrimitiveString on String {
  // Primitives
  int toPrimitiveInt() {
    final parsed = int.tryParse(this);

    if (parsed == null) {
      throw ArgumentError('The string \'$this\' is not a valid int.');
    }

    return parsed;
  }

  double toPrimitiveDouble() {
    final parsed = double.tryParse(this);

    if (parsed == null) {
      throw ArgumentError('The string \'$this\' is not a valid double.');
    }

    return parsed;
  }

  // Integer
  SmallInteger toSmallInteger() => SmallInteger(toPrimitiveInt());
  Integer toInteger() => Integer(toPrimitiveInt());
  BigInteger toBigInteger() => BigInteger(toPrimitiveInt());

  // Serial
  SmallSerial toSmallSerial() => SmallSerial(toPrimitiveInt());
  Serial toSerial() => Serial(toPrimitiveInt());
  BigSerial toBigSerial() => BigSerial(toPrimitiveInt());

  // Floating point
  Real toReal() => Real(toPrimitiveDouble());
  DoublePrecision toDoublePrecision() => DoublePrecision(toPrimitiveDouble());

  // Arbitrary precision
  Numeric toNumeric() {
    final unconstrained = Numeric(value: this);

    return Numeric(
      value: unconstrained.toString(),
      precision: unconstrained.precision,
      scale: unconstrained.scale,
    );
  }

  Decimal toDecimal() {
    final unconstrained = Decimal(value: this);

    return Decimal(
      value: unconstrained.toString(),
      precision: unconstrained.precision,
      scale: unconstrained.scale,
    );
  }

  // Character
  Char toChar() => Char(this, length: length);
  VarChar toVarChar() => VarChar(this, length: length);
  Text toText() => Text(this);
}
