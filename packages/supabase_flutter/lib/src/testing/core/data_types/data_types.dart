import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/character_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/floating_point_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

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
  DataType? operator [](int index);
  void operator []=(int index, Object value);

  // Equality operator
  @override
  bool operator ==(Object other);

  @override
  int get hashCode;

  // Casting methods

  // Primitives
  @override
  String toString();
  int toPrimitiveInt();
  double toPrimitiveDouble();

  // Integer
  SmallInteger toSmallInteger();
  Integer toInteger();
  BigInteger toBigInteger();

  // Serial
  SmallSerial toSmallSerial();
  Serial toSerial();
  BigSerial toBigSerial();

  // Floating point
  Real toReal();
  DoublePrecision toDoublePrecision();

  // Arbitrary precision
  Numeric toNumeric();
  Decimal toDecimal();

  // Character
  Char toChar();
  VarChar toVarChar();
  Text toText();

  // String
  String toDetailedString();

  // Comparison methods
  bool identicalTo(DataType other);

  static int getPrecision(Object dataType) {
    if (dataType is SmallSerial) {
      return 1;
    } else if (dataType is Serial) {
      return 2;
    } else if (dataType is BigSerial) {
      return 3;
    } else if (dataType is SmallInteger) {
      return 4;
    } else if (dataType is Integer) {
      return 5;
    } else if (dataType is BigInteger) {
      return 6;
    } else if (dataType is Real) {
      return 7;
    } else if (dataType is DoublePrecision) {
      return 8;
    } else if (dataType is Numeric) {
      return 9;
    } else {
      return 0;
    }
  }
}

abstract class FractionalDataType extends DataType {}
