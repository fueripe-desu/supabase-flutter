import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/character_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/floating_point_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
  group('toString() method', () {
    test('should cast correctly an int value', () {
      final value = Numeric(value: '20', precision: 2, scale: 0);
      expect(value.toString() == '20', true);
    });

    test('should cast correctly a positive zero int value', () {
      final value = Numeric(value: '0', precision: 1, scale: 0);
      expect(value.toString() == '0', true);
    });

    test('should cast correctly a negative zero int value', () {
      final value = Numeric(value: '-0', precision: 1, scale: 0);
      expect(value.toString() == '0', true);
    });

    test('should cast correctly a negative int value', () {
      final value = Numeric(value: '-20', precision: 2, scale: 0);
      expect(value.toString() == '-20', true);
    });

    test('should cast correctly an int with unspecified scale', () {
      final value = Numeric(value: '20', precision: 2);
      expect(value.toString() == '20', true);
    });

    test('should cast correctly a negative int with unspecified scale', () {
      final value = Numeric(value: '-20', precision: 2);
      expect(value.toString() == '-20', true);
    });

    test(
        'should cast correctly an int with precision greater than the actual value',
        () {
      final value = Numeric(value: '20', precision: 4, scale: 0);
      expect(value.toString() == '20', true);
    });

    test(
        'should cast correctly an int with precision greater than the actual value and unspecified scale',
        () {
      final value = Numeric(value: '20', precision: 4);
      expect(value.toString() == '20', true);
    });
  });

  group('toDetailedString() method', () {
    test('should cast correctly an int value', () {
      final value = Numeric(value: '20', precision: 2, scale: 0);
      expect(
        value.toDetailedString() == 'Precision: 2, Scale: 0, Value: 20',
        true,
      );
    });

    test('should cast correctly a positive zero int value', () {
      final value = Numeric(value: '0', precision: 1, scale: 0);
      expect(
        value.toDetailedString() == 'Precision: 1, Scale: 0, Value: 0',
        true,
      );
    });

    test('should cast correctly a negative zero int value', () {
      final value = Numeric(value: '-0', precision: 1, scale: 0);
      expect(
        value.toDetailedString() == 'Precision: 1, Scale: 0, Value: 0',
        true,
      );
    });

    test('should cast correctly a negative int value', () {
      final value = Numeric(value: '-20', precision: 2, scale: 0);
      expect(
        value.toDetailedString() == 'Precision: 2, Scale: 0, Value: -20',
        true,
      );
    });

    test('should cast correctly an int with unspecified scale', () {
      final value = Numeric(value: '20', precision: 2);
      expect(
        value.toDetailedString() == 'Precision: 2, Scale: 0, Value: 20',
        true,
      );
    });

    test('should cast correctly a negative int with unspecified scale', () {
      final value = Numeric(value: '-20', precision: 2);
      expect(
        value.toDetailedString() == 'Precision: 2, Scale: 0, Value: -20',
        true,
      );
    });

    test(
        'should cast correctly an int with precision greater than the actual value',
        () {
      final value = Numeric(value: '20', precision: 4, scale: 0);
      expect(
        value.toDetailedString() == 'Precision: 4, Scale: 0, Value: 20',
        true,
      );
    });

    test(
        'should cast correctly an int with precision greater than the actual value and unspecified scale',
        () {
      final value = Numeric(value: '20', precision: 4);
      expect(
        value.toDetailedString() == 'Precision: 4, Scale: 0, Value: 20',
        true,
      );
    });
  });

  group('toPrimitiveInt() method', () {
    test('should cast correctly an int value', () {
      final value = Numeric(value: '20', precision: 2, scale: 0);
      expect(value.toPrimitiveInt(), 20);
      expect(value.toPrimitiveInt(), isA<int>());
    });

    test('should cast correctly a zero value', () {
      final value = Numeric(value: '0', precision: 2, scale: 0);
      expect(value.toPrimitiveInt(), 0);
      expect(value.toPrimitiveInt(), isA<int>());
    });

    test('should cast correctly a negative int value', () {
      final value = Numeric(value: '-20', precision: 2, scale: 0);
      expect(value.toPrimitiveInt(), -20);
      expect(value.toPrimitiveInt(), isA<int>());
    });

    test('should throw a RangeError if value overflows', () {
      final value = Numeric(
        value: '9223372036854775806123',
        precision: 22,
        scale: 0,
      );
      expect(() => value.toPrimitiveInt(), throwsRangeError);
    });

    test('should throw a RangeError if value underflows', () {
      final value = Numeric(
        value: '-9223372036854775806123',
        precision: 22,
        scale: 0,
      );
      expect(() => value.toPrimitiveInt(), throwsRangeError);
    });
  });

  group('toPrimitiveDouble() method', () {
    test('should cast correctly an int value', () {
      final value = Numeric(value: '20', precision: 2, scale: 0);
      expect(value.toPrimitiveDouble(), 20.0);
      expect(value.toPrimitiveDouble(), isA<double>());
    });

    test('should cast correctly a zero value', () {
      final value = Numeric(value: '0', precision: 2, scale: 0);
      expect(value.toPrimitiveDouble(), 0.0);
      expect(value.toPrimitiveDouble(), isA<double>());
    });

    test('should cast correctly a negative int value', () {
      final value = Numeric(value: '-20', precision: 2, scale: 0);
      expect(value.toPrimitiveDouble(), -20.0);
      expect(value.toPrimitiveDouble(), isA<double>());
    });

    test('should throw a RangeError if value overflows', () {
      final value = Numeric(
        value: '1e400',
        precision: 401,
        scale: 0,
      );
      expect(() => value.toPrimitiveDouble(), throwsRangeError);
    });

    test('should throw a RangeError if value underflows', () {
      final value = Numeric(
        value: '-1e400',
        precision: 401,
        scale: 0,
      );
      expect(() => value.toPrimitiveDouble(), throwsRangeError);
    });
  });

  group('toBigInteger() method', () {
    test('should cast correctly an int value', () {
      final value = Numeric(value: '20', precision: 2, scale: 0);
      final expected = BigInteger(20);
      final operation = value.toBigInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a zero value', () {
      final value = Numeric(value: '0', precision: 1, scale: 0);
      final expected = BigInteger(0);
      final operation = value.toBigInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a negative int value', () {
      final value = Numeric(value: '-20', precision: 2, scale: 0);
      final expected = BigInteger(-20);
      final operation = value.toBigInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should throw a RangeError if value overflows', () {
      final value = Numeric(
        value: '9223372036854775806123',
        precision: 22,
        scale: 0,
      );
      expect(() => value.toBigInteger(), throwsRangeError);
    });

    test('should throw a RangeError if value underflows', () {
      final value = Numeric(
        value: '-9223372036854775806123',
        precision: 22,
        scale: 0,
      );
      expect(() => value.toBigInteger(), throwsRangeError);
    });
  });

  group('toInteger() method', () {
    test('should cast correctly an int value', () {
      final value = Numeric(value: '20', precision: 2, scale: 0);
      final expected = Integer(20);
      final operation = value.toInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a zero value', () {
      final value = Numeric(value: '0', precision: 1, scale: 0);
      final expected = Integer(0);
      final operation = value.toInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a negative int value', () {
      final value = Numeric(value: '-20', precision: 2, scale: 0);
      final expected = Integer(-20);
      final operation = value.toInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should throw a RangeError if value overflows', () {
      final value = Numeric(
        value: '9223372036854775806123',
        precision: 22,
        scale: 0,
      );
      expect(() => value.toInteger(), throwsRangeError);
    });

    test('should throw a RangeError if value underflows', () {
      final value = Numeric(
        value: '-9223372036854775806123',
        precision: 22,
        scale: 0,
      );
      expect(() => value.toInteger(), throwsRangeError);
    });
  });

  group('toSmallInteger() method', () {
    test('should cast correctly an int value', () {
      final value = Numeric(value: '20', precision: 2, scale: 0);
      final expected = SmallInteger(20);
      final operation = value.toSmallInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a zero value', () {
      final value = Numeric(value: '0', precision: 1, scale: 0);
      final expected = SmallInteger(0);
      final operation = value.toSmallInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a negative int value', () {
      final value = Numeric(value: '-20', precision: 2, scale: 0);
      final expected = SmallInteger(-20);
      final operation = value.toSmallInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should throw a RangeError if value overflows', () {
      final value = Numeric(
        value: '9223372036854775806123',
        precision: 22,
        scale: 0,
      );
      expect(() => value.toSmallInteger(), throwsRangeError);
    });

    test('should throw a RangeError if value underflows', () {
      final value = Numeric(
        value: '-9223372036854775806123',
        precision: 22,
        scale: 0,
      );
      expect(() => value.toSmallInteger(), throwsRangeError);
    });
  });

  group('toBigSerial() method', () {
    test('should cast correctly an int value', () {
      final value = Numeric(value: '20', precision: 2, scale: 0);
      final expected = BigSerial(20);
      final operation = value.toBigSerial();
      expect(operation.identicalTo(expected), true);
    });

    test('should throw a RangeError if casting zero value', () {
      final value = Numeric(value: '0', precision: 1, scale: 0);
      expect(() => value.toBigSerial(), throwsRangeError);
    });

    test('should throw a RangeError if casting negative value', () {
      final value = Numeric(value: '-1', precision: 1, scale: 0);
      expect(() => value.toBigSerial(), throwsRangeError);
    });
  });

  group('toSerial() method', () {
    test('should cast correctly an int value', () {
      final value = Numeric(value: '20', precision: 2, scale: 0);
      final expected = Serial(20);
      final operation = value.toSerial();
      expect(operation.identicalTo(expected), true);
    });

    test('should throw a RangeError if casting zero value', () {
      final value = Numeric(value: '0', precision: 1, scale: 0);
      expect(() => value.toSerial(), throwsRangeError);
    });

    test('should throw a RangeError if casting negative value', () {
      final value = Numeric(value: '-1', precision: 1, scale: 0);
      expect(() => value.toSerial(), throwsRangeError);
    });
  });

  group('toSmallSerial() method', () {
    test('should cast correctly an int value', () {
      final value = Numeric(value: '20', precision: 2, scale: 0);
      final expected = SmallSerial(20);
      final operation = value.toSmallSerial();
      expect(operation.identicalTo(expected), true);
    });

    test('should throw a RangeError if casting zero value', () {
      final value = Numeric(value: '0', precision: 1, scale: 0);
      expect(() => value.toSmallSerial(), throwsRangeError);
    });

    test('should throw a RangeError if casting negative value', () {
      final value = Numeric(value: '-1', precision: 1, scale: 0);
      expect(() => value.toSmallSerial(), throwsRangeError);
    });
  });

  group('toReal() method', () {
    test('should cast correctly an int value', () {
      final value = Numeric(value: '20', precision: 2, scale: 0);
      final expected = Real(20);
      final operation = value.toReal();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a zero value', () {
      final value = Numeric(value: '0', precision: 1, scale: 0);
      final expected = Real(0);
      final operation = value.toReal();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a negative int value', () {
      final value = Numeric(value: '-20', precision: 2, scale: 0);
      final expected = Real(-20);
      final operation = value.toReal();
      expect(operation.identicalTo(expected), true);
    });

    test('should throw a RangeError if value overflows', () {
      final value = Numeric(
        value: '1e400',
        precision: 401,
        scale: 0,
      );
      expect(() => value.toReal(), throwsRangeError);
    });

    test('should throw a RangeError if value underflows', () {
      final value = Numeric(
        value: '-1e400',
        precision: 401,
        scale: 0,
      );
      expect(() => value.toReal(), throwsRangeError);
    });
  });

  group('toDoublePrecision() method', () {
    test('should cast correctly an int value', () {
      final value = Numeric(value: '20', precision: 2, scale: 0);
      final expected = DoublePrecision(20);
      final operation = value.toDoublePrecision();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a zero value', () {
      final value = Numeric(value: '0', precision: 1, scale: 0);
      final expected = DoublePrecision(0);
      final operation = value.toDoublePrecision();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a negative int value', () {
      final value = Numeric(value: '-20', precision: 2, scale: 0);
      final expected = DoublePrecision(-20);
      final operation = value.toDoublePrecision();
      expect(operation.identicalTo(expected), true);
    });

    test('should throw a RangeError if value overflows', () {
      final value = Numeric(
        value: '1e400',
        precision: 401,
        scale: 0,
      );
      expect(() => value.toDoublePrecision(), throwsRangeError);
    });

    test('should throw a RangeError if value underflows', () {
      final value = Numeric(
        value: '-1e400',
        precision: 401,
        scale: 0,
      );
      expect(() => value.toDoublePrecision(), throwsRangeError);
    });
  });

  group('toNumeric() method', () {
    test('should cast correctly an int value', () {
      final value = Numeric(value: '20', precision: 2, scale: 0);
      final expected = Numeric(value: '20', precision: 2, scale: 0);
      final operation = value.toNumeric();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a zero value', () {
      final value = Numeric(value: '0', precision: 1, scale: 0);
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value.toNumeric();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a negative int value', () {
      final value = Numeric(value: '-20', precision: 2, scale: 0);
      final expected = Numeric(value: '-20', precision: 2, scale: 0);
      final operation = value.toNumeric();
      expect(operation.identicalTo(expected), true);
    });
  });

  group('toDecimal() method', () {
    test('should cast correctly an int value', () {
      final value = Numeric(value: '20', precision: 2, scale: 0);
      final expected = Decimal(value: '20', precision: 2, scale: 0);
      final operation = value.toDecimal();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a zero value', () {
      final value = Numeric(value: '0', precision: 1, scale: 0);
      final expected = Decimal(value: '0', precision: 1, scale: 0);
      final operation = value.toDecimal();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a negative int value', () {
      final value = Numeric(value: '-20', precision: 2, scale: 0);
      final expected = Decimal(value: '-20', precision: 2, scale: 0);
      final operation = value.toDecimal();
      expect(operation.identicalTo(expected), true);
    });
  });

  group('toChar() method', () {
    test('should cast correctly an int value', () {
      final value = Numeric(value: '20', precision: 2, scale: 0);
      final expected = Char('20', length: 2);
      final operation = value.toChar();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a zero value', () {
      final value = Numeric(value: '0', precision: 1, scale: 0);
      final expected = Char('0', length: 1);
      final operation = value.toChar();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a negative int value', () {
      final value = Numeric(value: '-20', precision: 2, scale: 0);
      final expected = Char('-20', length: 3);
      final operation = value.toChar();
      expect(operation.identicalTo(expected), true);
    });
  });

  group('toVarChar() method', () {
    test('should cast correctly an int value', () {
      final value = Numeric(value: '20', precision: 2, scale: 0);
      final expected = VarChar('20', length: 2);
      final operation = value.toVarChar();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a zero value', () {
      final value = Numeric(value: '0', precision: 1, scale: 0);
      final expected = VarChar('0', length: 1);
      final operation = value.toVarChar();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a negative int value', () {
      final value = Numeric(value: '-20', precision: 2, scale: 0);
      final expected = VarChar('-20', length: 3);
      final operation = value.toVarChar();
      expect(operation.identicalTo(expected), true);
    });
  });

  group('toText() method', () {
    test('should cast correctly an int value', () {
      final value = Numeric(value: '20', precision: 2, scale: 0);
      final expected = Text('20');
      final operation = value.toText();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a zero value', () {
      final value = Numeric(value: '0', precision: 1, scale: 0);
      final expected = Text('0');
      final operation = value.toText();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a negative int value', () {
      final value = Numeric(value: '-20', precision: 2, scale: 0);
      final expected = Text('-20');
      final operation = value.toText();
      expect(operation.identicalTo(expected), true);
    });
  });

  group('toMostPreciseInt() method', () {
    test('should return an Integer if it is in range', () {
      final value = Numeric(value: '20', precision: 2, scale: 0);
      final expected = SmallInteger(20);
      final operation = value.toMostPreciseInt();
      expect(operation.identicalTo(expected), true);
    });

    test('should return an BigInteger if it is in range', () {
      final value = Numeric(value: '2147483647123', precision: 13, scale: 0);
      final expected = BigInteger(2147483647123);
      final operation = value.toMostPreciseInt();
      expect(operation.identicalTo(expected), true);
    });

    test('should return a Numeric if it is out of range of all integer types',
        () {
      final value = Numeric(
        value: '9223372036854775806123',
        precision: 22,
        scale: 0,
      );
      final expected = Numeric(
        value: '9223372036854775806123',
        precision: 22,
        scale: 0,
      );
      final operation = value.toMostPreciseInt();
      expect(operation.identicalTo(expected), true);
    });
  });

  group('toMostPreciseFloat() method', () {
    test('should return a Real if it is in range', () {
      final value = Numeric(value: '20', precision: 2, scale: 0);
      final expected = Real(20);
      final operation = value.toMostPreciseFloat();
      expect(operation.identicalTo(expected), true);
    });

    test('should return an DoublePrecision if it is in range', () {
      final value = Numeric(value: '3.40282347e+50', precision: 51, scale: 0);
      final expected = DoublePrecision(3.40282347e+50);
      final operation = value.toMostPreciseFloat();
      expect(operation.identicalTo(expected), true);
    });

    test('should return a Numeric if it is out of range of all integer types',
        () {
      final value = Numeric(value: '3.40282347e+400', precision: 401, scale: 0);
      final expected = Numeric(value: '3.40282347e+400');
      final operation = value.toMostPreciseFloat();
      expect(operation.identicalTo(expected), true);
    });
  });
}
