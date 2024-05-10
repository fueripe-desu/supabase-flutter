import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/floating_point_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

typedef Char = Character;
typedef VarChar = CharacterVarying;

abstract class CharacterDataType<T extends CharacterDataType<T>>
    extends DataType {
  CharacterDataType(int? charLength, String charValue) {
    if (charLength != null) {
      if (charLength < 0) {
        throw Exception('Character length cannot be less than 0.');
      }

      if (_maxLength != null && charLength > _maxLength!) {
        throw Exception('Character length exceeds maximum length.');
      }
    }

    length = charLength;

    if (length == null) {
      value = charValue;
    } else if (length == 0) {
      value = '';
    } else {
      if (charValue.length < length! && _shouldPad) {
        value = charValue.padRight(length!);
      } else if (charValue.length > length!) {
        if (!_shouldTruncate) {
          throw Exception('Character length cannot exceed the given length.');
        }
        value = charValue.substring(0, length!);
      } else {
        value = charValue;
      }
    }
  }

  late final int? length;
  late final String value;

  int? get _maxLength;
  bool get _shouldPad;
  bool get _shouldTruncate;

  @override
  String toString() => value;

  @override
  bool operator ==(Object other) {
    if (other is CharacterDataType) {
      return value == other.value;
    }
    return false;
  }

  @override
  int get hashCode => Object.hashAll([length, value]);

  // Unary operators
  @override
  T operator -() => throw UnsupportedError(
        'Unary minus is not supported by character data types.',
      );

  // Arithmetic operators
  @override
  DataType operator +(Object other) {
    if (other is List) {
      return Text(value + other.join(','));
    }

    return Text(value + other.toString());
  }

  @override
  DataType operator -(Object other) => throw UnsupportedError(
        'Subtraction is not supported by character data types.',
      );

  @override
  DataType operator *(Object other) => throw UnsupportedError(
        'Multiplication is not supported by character data types.',
      );

  @override
  DataType operator /(Object other) => throw UnsupportedError(
        'Division is not supported by character data types.',
      );

  @override
  DataType operator ~/(Object other) => throw UnsupportedError(
        'Integer division is not supported by character data types.',
      );

  @override
  DataType operator %(Object other) => throw UnsupportedError(
        'Modulus is not supported by character data types.',
      );

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
  DataType operator &(Object other) => throw UnsupportedError(
        'Bitwise AND is not supported by character data types.',
      );

  @override
  DataType operator |(Object other) => throw UnsupportedError(
        'Bitwise OR is not supported by character data types.',
      );

  @override
  DataType operator ^(Object other) => throw UnsupportedError(
        'Bitwise XOR is not supported by character data types.',
      );

  @override
  DataType operator <<(Object other) => throw UnsupportedError(
        'Left shift is not supported by character data types.',
      );

  @override
  DataType operator >>(Object other) => throw UnsupportedError(
        'Right shift is not supported by character data types.',
      );

  @override
  DataType operator >>>(Object other) => throw UnsupportedError(
        'Unsigned right shift is not supported by character data types.',
      );

  // Indexing operators
  @override
  DataType? operator [](int index) {
    if (index >= 0 && index <= (value.length - 1)) {
      return Text(value[index]);
    }

    return null;
  }

  @override
  void operator []=(int index, Object value) => throw UnsupportedError(
        'Character data types are immutable, therefore index assignment is fobidden.',
      );

  @override
  int compareTo(Object other) => value.compareTo(other.toString());

  bool isNumber() => RegExp(r'^-?\d+$').hasMatch(value);
  bool isFractional() => double.tryParse(value) != null;
  bool isNumerical() => isNumber() || isFractional();
  bool isAlphabetic() => RegExp(r'^[a-zA-Z]+$').hasMatch(value);
  bool isAlphanumeric() => RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value);

  // Cast methods

  // Primitives
  @override
  int toPrimitiveInt() => int.parse(value);

  @override
  double toPrimitiveDouble() => double.parse(value);

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

  // Floating point
  @override
  Real toReal() => Real(toPrimitiveDouble());

  @override
  DoublePrecision toDoublePrecision() => DoublePrecision(toPrimitiveDouble());

  // Arbitray precision
  @override
  Numeric toNumeric() => Numeric(value: value);

  @override
  Decimal toDecimal() => Decimal(value: value);

  // Character
  @override
  Char toChar() => Char(value, length: value.length);

  @override
  VarChar toVarChar() => VarChar(value, length: value.length);

  @override
  Text toText() => Text(value);
}

class Character extends CharacterDataType<Character> {
  Character(String value, {required int length}) : super(length, value);

  @override
  int? get _maxLength => 1073741824;
  @override
  bool get _shouldPad => true;
  @override
  bool get _shouldTruncate => true;

  @override
  bool identicalTo(DataType other) =>
      other is Character && value == other.value && length == other.length;

  @override
  String toDetailedString() {
    // TODO: implement toDetailedString
    throw UnimplementedError();
  }
}

class CharacterVarying extends CharacterDataType<CharacterVarying> {
  CharacterVarying(String value, {int? length}) : super(length, value);

  @override
  int? get _maxLength => null;
  @override
  bool get _shouldPad => false;
  @override
  bool get _shouldTruncate => false;

  @override
  bool identicalTo(DataType other) =>
      other is VarChar && value == other.value && length == other.length;

  @override
  String toDetailedString() {
    // TODO: implement toDetailedString
    throw UnimplementedError();
  }
}

class Text extends CharacterDataType<Text> {
  Text(String value) : super(null, value);

  @override
  int? get _maxLength => null;
  @override
  bool get _shouldPad => false;
  @override
  bool get _shouldTruncate => false;

  @override
  bool identicalTo(DataType other) => other is Text && value == other.value;

  @override
  String toDetailedString() {
    // TODO: implement toDetailedString
    throw UnimplementedError();
  }
}
