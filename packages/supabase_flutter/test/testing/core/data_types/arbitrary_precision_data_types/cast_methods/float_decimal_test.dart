import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/character_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/floating_point_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  group('toString() method', () {
    test('should cast correctly a floating point value', () {
      final value = Decimal(value: '3.14', precision: 3, scale: 2);
      expect(value.toString() == '3.14', true);
    });

    test('should cast correctly a positive zero floating point value', () {
      final value = Decimal(value: '0.0', precision: 2, scale: 1);
      expect(value.toString() == '0.0', true);
    });

    test('should cast correctly a negative zero floating point value', () {
      final value = Decimal(value: '-0.0', precision: 2, scale: 1);
      expect(value.toString() == '0.0', true);
    });

    test('should cast correctly a negative floating point value', () {
      final value = Decimal(value: '-3.14', precision: 3, scale: 2);
      expect(value.toString() == '-3.14', true);
    });

    test('should cast correctly if scale is greater than the actual value', () {
      final value = Decimal(value: '3.14', precision: 5, scale: 4);
      expect(value.toString() == '3.1400', true);
    });

    test(
        'should cast correctly if scale is greater than the actual value and value is negative',
        () {
      final value = Decimal(value: '-3.14', precision: 5, scale: 4);
      expect(value.toString() == '-3.1400', true);
    });

    test(
        'should cast correctly if value is integer but scale is greater than 0',
        () {
      final value = Decimal(value: '3', precision: 3, scale: 2);
      expect(value.toString() == '3.00', true);
    });

    test(
        'should cast correctly if value is a negative integer but scale is greater than 0',
        () {
      final value = Decimal(value: '-3', precision: 3, scale: 2);
      expect(value.toString() == '-3.00', true);
    });

    test(
        'should cast correctly if precision is greater than the actual float value',
        () {
      final value = Decimal(value: '3.14', precision: 5, scale: 2);
      expect(value.toString() == '3.14', true);
    });

    test(
        'should cast correctly if precision is greater than the actual negative float value',
        () {
      final value = Decimal(value: '-3.14', precision: 5, scale: 2);
      expect(value.toString() == '-3.14', true);
    });
  });

  group('toDetailedString() method', () {
    test('should cast correctly a floating point value', () {
      final value = Decimal(value: '3.14', precision: 3, scale: 2);
      expect(
        value.toDetailedString() == 'Precision: 3, Scale: 2, Value: 3.14',
        true,
      );
    });

    test('should cast correctly a positive zero floating point value', () {
      final value = Decimal(value: '0.0', precision: 2, scale: 1);
      expect(
        value.toDetailedString() == 'Precision: 2, Scale: 1, Value: 0.0',
        true,
      );
    });

    test('should cast correctly a negative zero floating point value', () {
      final value = Decimal(value: '-0.0', precision: 2, scale: 1);
      expect(
        value.toDetailedString() == 'Precision: 2, Scale: 1, Value: 0.0',
        true,
      );
    });

    test('should cast correctly a negative floating point value', () {
      final value = Decimal(value: '-3.14', precision: 3, scale: 2);
      expect(value.toDetailedString() == 'Precision: 3, Scale: 2, Value: -3.14',
          true);
    });

    test('should cast correctly if scale is greater than the actual value', () {
      final value = Decimal(value: '3.14', precision: 5, scale: 4);
      expect(
        value.toDetailedString() == 'Precision: 5, Scale: 4, Value: 3.1400',
        true,
      );
    });

    test(
        'should cast correctly if scale is greater than the actual value and value is negative',
        () {
      final value = Decimal(value: '-3.14', precision: 5, scale: 4);
      expect(
        value.toDetailedString() == 'Precision: 5, Scale: 4, Value: -3.1400',
        true,
      );
    });

    test(
        'should cast correctly if value is integer but scale is greater than 0',
        () {
      final value = Decimal(value: '3', precision: 3, scale: 2);
      expect(
        value.toDetailedString() == 'Precision: 3, Scale: 2, Value: 3.00',
        true,
      );
    });

    test(
        'should cast correctly if value is a negative integer but scale is greater than 0',
        () {
      final value = Decimal(value: '-3', precision: 3, scale: 2);
      expect(
        value.toDetailedString() == 'Precision: 3, Scale: 2, Value: -3.00',
        true,
      );
    });

    test(
        'should cast correctly if precision is greater than the actual float value',
        () {
      final value = Decimal(value: '3.14', precision: 5, scale: 2);
      expect(
        value.toDetailedString() == 'Precision: 5, Scale: 2, Value: 3.14',
        true,
      );
    });

    test(
        'should cast correctly if precision is greater than the actual negative float value',
        () {
      final value = Decimal(value: '-3.14', precision: 5, scale: 2);
      expect(
        value.toDetailedString() == 'Precision: 5, Scale: 2, Value: -3.14',
        true,
      );
    });
  });

  group('toPrimitiveInt() method', () {
    test('should cast correctly an double value', () {
      final value = Decimal(value: '3.14', precision: 3, scale: 2);
      expect(value.toPrimitiveInt(), 3);
      expect(value.toPrimitiveInt(), isA<int>());
    });

    test('should cast correctly a zero value', () {
      final value = Decimal(value: '0.0', precision: 2, scale: 1);
      expect(value.toPrimitiveInt(), 0);
      expect(value.toPrimitiveInt(), isA<int>());
    });

    test('should cast correctly a negative double value', () {
      final value = Decimal(value: '-3.14', precision: 3, scale: 2);
      expect(value.toPrimitiveInt(), -3);
      expect(value.toPrimitiveInt(), isA<int>());
    });

    test('should throw a RangeError if value overflows', () {
      final value = Decimal(
        value: '1e400',
        precision: 402,
        scale: 1,
      );
      expect(() => value.toPrimitiveInt(), throwsRangeError);
    });

    test('should throw a RangeError if value underflows', () {
      final value = Decimal(
        value: '-1e400',
        precision: 402,
        scale: 1,
      );
      expect(() => value.toPrimitiveInt(), throwsRangeError);
    });
  });

  group('toPrimitiveDouble() method', () {
    test('should cast correctly an double value', () {
      final value = Decimal(value: '3.14', precision: 3, scale: 2);
      expect(value.toPrimitiveDouble(), 3.14);
      expect(value.toPrimitiveDouble(), isA<double>());
    });

    test('should cast correctly a zero value', () {
      final value = Decimal(value: '0.0', precision: 2, scale: 1);
      expect(value.toPrimitiveDouble(), 0.0);
      expect(value.toPrimitiveDouble(), isA<double>());
    });

    test('should cast correctly a negative double value', () {
      final value = Decimal(value: '-3.14', precision: 3, scale: 2);
      expect(value.toPrimitiveDouble(), -3.14);
      expect(value.toPrimitiveDouble(), isA<double>());
    });

    test('should throw a RangeError if value overflows', () {
      final value = Decimal(
        value: '1e400',
        precision: 402,
        scale: 1,
      );
      expect(() => value.toPrimitiveDouble(), throwsRangeError);
    });

    test('should throw a RangeError if value underflows', () {
      final value = Decimal(
        value: '-1e400',
        precision: 402,
        scale: 1,
      );
      expect(() => value.toPrimitiveDouble(), throwsRangeError);
    });
  });

  group('toBigInteger() method', () {
    test('should cast correctly an double value', () {
      final value = Decimal(value: '3.14', precision: 3, scale: 2);
      final expected = BigInteger(3);
      final operation = value.toBigInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a zero value', () {
      final value = Decimal(value: '0.0', precision: 2, scale: 1);
      final expected = BigInteger(0);
      final operation = value.toBigInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a negative double value', () {
      final value = Decimal(value: '-3.14', precision: 3, scale: 2);
      final expected = BigInteger(-3);
      final operation = value.toBigInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should throw a RangeError if value overflows', () {
      final value = Decimal(
        value: '1e400',
        precision: 402,
        scale: 1,
      );
      expect(() => value.toBigInteger(), throwsRangeError);
    });

    test('should throw a RangeError if value underflows', () {
      final value = Decimal(
        value: '-1e400',
        precision: 402,
        scale: 1,
      );
      expect(() => value.toBigInteger(), throwsRangeError);
    });
  });

  group('toInteger() method', () {
    test('should cast correctly an double value', () {
      final value = Decimal(value: '3.14', precision: 3, scale: 2);
      final expected = Integer(3);
      final operation = value.toInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a zero value', () {
      final value = Decimal(value: '0.0', precision: 2, scale: 1);
      final expected = Integer(0);
      final operation = value.toInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a negative double value', () {
      final value = Decimal(value: '-3.14', precision: 3, scale: 2);
      final expected = Integer(-3);
      final operation = value.toInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should throw a RangeError if value overflows', () {
      final value = Decimal(
        value: '1e400',
        precision: 402,
        scale: 1,
      );
      expect(() => value.toInteger(), throwsRangeError);
    });

    test('should throw a RangeError if value underflows', () {
      final value = Decimal(
        value: '-1e400',
        precision: 402,
        scale: 1,
      );
      expect(() => value.toInteger(), throwsRangeError);
    });
  });

  group('toSmallInteger() method', () {
    test('should cast correctly an double value', () {
      final value = Decimal(value: '3.14', precision: 3, scale: 2);
      final expected = SmallInteger(3);
      final operation = value.toSmallInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a zero value', () {
      final value = Decimal(value: '0.0', precision: 2, scale: 1);
      final expected = SmallInteger(0);
      final operation = value.toSmallInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a negative double value', () {
      final value = Decimal(value: '-3.14', precision: 3, scale: 2);
      final expected = SmallInteger(-3);
      final operation = value.toSmallInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should throw a RangeError if value overflows', () {
      final value = Decimal(
        value: '1e400',
        precision: 402,
        scale: 1,
      );
      expect(() => value.toSmallInteger(), throwsRangeError);
    });

    test('should throw a RangeError if value underflows', () {
      final value = Decimal(
        value: '-1e400',
        precision: 402,
        scale: 1,
      );
      expect(() => value.toSmallInteger(), throwsRangeError);
    });
  });

  group('toBigSerial() method', () {
    test('should cast correctly an double value', () {
      final value = Decimal(value: '3.14', precision: 3, scale: 2);
      final expected = BigSerial(3);
      final operation = value.toBigSerial();
      expect(operation.identicalTo(expected), true);
    });

    test('should throw a RangeError if casting zero value', () {
      final value = Decimal(value: '0.0', precision: 2, scale: 1);
      expect(() => value.toBigSerial(), throwsRangeError);
    });

    test('should throw a RangeError if casting negative value', () {
      final value = Decimal(value: '-3.14', precision: 3, scale: 2);
      expect(() => value.toBigSerial(), throwsRangeError);
    });
  });

  group('toSerial() method', () {
    test('should cast correctly an double value', () {
      final value = Decimal(value: '3.14', precision: 3, scale: 2);
      final expected = Serial(3);
      final operation = value.toSerial();
      expect(operation.identicalTo(expected), true);
    });

    test('should throw a RangeError if casting zero value', () {
      final value = Decimal(value: '0.0', precision: 2, scale: 1);
      expect(() => value.toSerial(), throwsRangeError);
    });

    test('should throw a RangeError if casting negative value', () {
      final value = Decimal(value: '-3.14', precision: 3, scale: 2);
      expect(() => value.toSerial(), throwsRangeError);
    });
  });

  group('toSmallSerial() method', () {
    test('should cast correctly an double value', () {
      final value = Decimal(value: '3.14', precision: 3, scale: 2);
      final expected = SmallSerial(3);
      final operation = value.toSmallSerial();
      expect(operation.identicalTo(expected), true);
    });

    test('should throw a RangeError if casting zero value', () {
      final value = Decimal(value: '0.0', precision: 2, scale: 1);
      expect(() => value.toSmallSerial(), throwsRangeError);
    });

    test('should throw a RangeError if casting negative value', () {
      final value = Decimal(value: '-3.14', precision: 3, scale: 2);
      expect(() => value.toSmallSerial(), throwsRangeError);
    });
  });

  group('toReal() method', () {
    test('should cast correctly an double value', () {
      final value = Decimal(value: '3.14', precision: 3, scale: 2);
      final expected = Real(3.14);
      final operation = value.toReal();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a zero value', () {
      final value = Decimal(value: '0.0', precision: 2, scale: 1);
      final expected = Real(0);
      final operation = value.toReal();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a negative double value', () {
      final value = Decimal(value: '-3.14', precision: 3, scale: 2);
      final expected = Real(-3.14);
      final operation = value.toReal();
      expect(operation.identicalTo(expected), true);
    });

    test('should throw a RangeError if value overflows', () {
      final value = Decimal(
        value: '1e400',
        precision: 402,
        scale: 1,
      );
      expect(() => value.toReal(), throwsRangeError);
    });

    test('should throw a RangeError if value underflows', () {
      final value = Decimal(
        value: '-1e400',
        precision: 402,
        scale: 1,
      );
      expect(() => value.toReal(), throwsRangeError);
    });
  });

  group('toDoublePrecision() method', () {
    test('should cast correctly an double value', () {
      final value = Decimal(value: '3.14', precision: 3, scale: 2);
      final expected = DoublePrecision(3.14);
      final operation = value.toDoublePrecision();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a zero value', () {
      final value = Decimal(value: '0.0', precision: 2, scale: 1);
      final expected = DoublePrecision(0);
      final operation = value.toDoublePrecision();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a negative double value', () {
      final value = Decimal(value: '-3.14', precision: 3, scale: 2);
      final expected = DoublePrecision(-3.14);
      final operation = value.toDoublePrecision();
      expect(operation.identicalTo(expected), true);
    });

    test('should throw a RangeError if value overflows', () {
      final value = Decimal(
        value: '1e400',
        precision: 402,
        scale: 1,
      );
      expect(() => value.toDoublePrecision(), throwsRangeError);
    });

    test('should throw a RangeError if value underflows', () {
      final value = Decimal(
        value: '-1e400',
        precision: 402,
        scale: 1,
      );
      expect(() => value.toDoublePrecision(), throwsRangeError);
    });
  });

  group('toNumeric() method', () {
    test('should cast correctly an double value', () {
      final value = Decimal(value: '3.14', precision: 3, scale: 2);
      final expected = Numeric(value: '3.14', precision: 3, scale: 2);
      final operation = value.toNumeric();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a zero value', () {
      final value = Decimal(value: '0.0', precision: 2, scale: 1);
      final expected = Numeric(value: '0.0', precision: 2, scale: 1);
      final operation = value.toNumeric();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a negative double value', () {
      final value = Decimal(value: '-3.14', precision: 3, scale: 2);
      final expected = Numeric(value: '-3.14', precision: 3, scale: 2);
      final operation = value.toNumeric();
      expect(operation.identicalTo(expected), true);
    });
  });

  group('toDecimal() method', () {
    test('should cast correctly an double value', () {
      final value = Decimal(value: '3.14', precision: 3, scale: 2);
      final expected = Decimal(value: '3.14', precision: 3, scale: 2);
      final operation = value.toDecimal();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a zero value', () {
      final value = Decimal(value: '0.0', precision: 2, scale: 1);
      final expected = Decimal(value: '0.0', precision: 2, scale: 1);
      final operation = value.toDecimal();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a negative double value', () {
      final value = Decimal(value: '-3.14', precision: 3, scale: 2);
      final expected = Decimal(value: '-3.14', precision: 3, scale: 2);
      final operation = value.toDecimal();
      expect(operation.identicalTo(expected), true);
    });
  });

  group('toChar() method', () {
    test('should cast correctly an double value', () {
      final value = Decimal(value: '3.14', precision: 3, scale: 2);
      final expected = Char('3.14', length: 4);
      final operation = value.toChar();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a zero value', () {
      final value = Decimal(value: '0.0', precision: 2, scale: 1);
      final expected = Char('0.0', length: 3);
      final operation = value.toChar();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a negative double value', () {
      final value = Decimal(value: '-3.14', precision: 3, scale: 2);
      final expected = Char('-3.14', length: 5);
      final operation = value.toChar();
      expect(operation.identicalTo(expected), true);
    });
  });

  group('toVarChar() method', () {
    test('should cast correctly an double value', () {
      final value = Decimal(value: '3.14', precision: 3, scale: 2);
      final expected = VarChar('3.14', length: 4);
      final operation = value.toVarChar();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a zero value', () {
      final value = Decimal(value: '0.0', precision: 2, scale: 1);
      final expected = VarChar('0.0', length: 3);
      final operation = value.toVarChar();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a negative double value', () {
      final value = Decimal(value: '-3.14', precision: 3, scale: 2);
      final expected = VarChar('-3.14', length: 5);
      final operation = value.toVarChar();
      expect(operation.identicalTo(expected), true);
    });
  });

  group('toText() method', () {
    test('should cast correctly an double value', () {
      final value = Decimal(value: '3.14', precision: 3, scale: 2);
      final expected = Text('3.14');
      final operation = value.toText();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a zero value', () {
      final value = Decimal(value: '0.0', precision: 2, scale: 1);
      final expected = Text('0.0');
      final operation = value.toText();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a negative double value', () {
      final value = Decimal(value: '-3.14', precision: 3, scale: 2);
      final expected = Text('-3.14');
      final operation = value.toText();
      expect(operation.identicalTo(expected), true);
    });
  });

  group('toMostPreciseInt() method', () {
    test('should return an Integer if it is in range', () {
      final value = Decimal(value: '20.3', precision: 3, scale: 1);
      final expected = SmallInteger(20);
      final operation = value.toMostPreciseInt();
      expect(operation.identicalTo(expected), true);
    });

    test('should return an BigInteger if it is in range', () {
      final value = Decimal(value: '2147483647123.4', precision: 14, scale: 1);
      final expected = BigInteger(2147483647123);
      final operation = value.toMostPreciseInt();
      expect(operation.identicalTo(expected), true);
    });

    test('should return a Numeric if it is out of range of all integer types',
        () {
      final value = Decimal(
        value: '9223372036854775806123.3',
        precision: 23,
        scale: 1,
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
      final value = Decimal(value: '20.5', precision: 3, scale: 1);
      final expected = Real(20.5);
      final operation = value.toMostPreciseFloat();
      expect(operation.identicalTo(expected), true);
    });

    test('should return an DoublePrecision if it is in range', () {
      final value = Decimal(value: '3.40282347e+50', precision: 51, scale: 0);
      final expected = DoublePrecision(3.40282347e+50);
      final operation = value.toMostPreciseFloat();
      expect(operation.identicalTo(expected), true);
    });

    test('should return a Numeric if it is out of range of all integer types',
        () {
      final value = Decimal(value: '3.40282347e+400', precision: 401, scale: 0);
      final expected = Numeric(value: '3.40282347e+400');
      final operation = value.toMostPreciseFloat();
      expect(operation.identicalTo(expected), true);
    });
  });
}
