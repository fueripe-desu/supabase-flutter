import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/character_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/floating_point_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
  group('toString() method', () {
    test('should cast correctly a value with negative scale', () {
      final value = Decimal(value: '1234', precision: 4, scale: -3);
      expect(value.toString(), '1000');
    });

    test('should cast correctly a negative value with negative scale', () {
      final value = Decimal(value: '-1234', precision: 4, scale: -3);
      expect(value.toString(), '-1000');
    });
  });

  group('toDetailedString() method', () {
    test('should cast correctly a value with negative scale', () {
      final value = Decimal(value: '1234', precision: 4, scale: -3);
      expect(
        value.toDetailedString() == 'Precision: 4, Scale: -3, Value: 1000',
        true,
      );
    });

    test('should cast correctly a negative value with negative scale', () {
      final value = Decimal(value: '-1234', precision: 4, scale: -3);
      expect(
        value.toDetailedString() == 'Precision: 4, Scale: -3, Value: -1000',
        true,
      );
    });
  });

  group('toPrimitiveInt() method', () {
    test('should cast correctly an int value', () {
      final value = Decimal(value: '24', precision: 2, scale: -1);
      expect(value.toPrimitiveInt(), 20);
      expect(value.toPrimitiveInt(), isA<int>());
    });

    test('should cast correctly a zero value', () {
      final value = Decimal(value: '14', precision: 2, scale: -3);
      expect(value.toPrimitiveInt(), 0);
      expect(value.toPrimitiveInt(), isA<int>());
    });

    test('should cast correctly a negative int value', () {
      final value = Decimal(value: '-24', precision: 2, scale: -1);
      expect(value.toPrimitiveInt(), -20);
      expect(value.toPrimitiveInt(), isA<int>());
    });
  });

  group('toPrimitiveDouble() method', () {
    test('should cast correctly an int value', () {
      final value = Decimal(value: '24', precision: 2, scale: -1);
      expect(value.toPrimitiveDouble(), 20.0);
      expect(value.toPrimitiveDouble(), isA<double>());
    });

    test('should cast correctly a zero value', () {
      final value = Decimal(value: '14', precision: 2, scale: -3);
      expect(value.toPrimitiveDouble(), 0.0);
      expect(value.toPrimitiveDouble(), isA<double>());
    });

    test('should cast correctly a negative int value', () {
      final value = Decimal(value: '-24', precision: 2, scale: -1);
      expect(value.toPrimitiveDouble(), -20.0);
      expect(value.toPrimitiveDouble(), isA<double>());
    });
  });

  group('toBigInteger() method', () {
    test('should cast correctly an int value', () {
      final value = Decimal(value: '24', precision: 2, scale: -1);
      final expected = BigInteger(20);
      final operation = value.toBigInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a zero value', () {
      final value = Decimal(value: '14', precision: 2, scale: -3);
      final expected = BigInteger(0);
      final operation = value.toBigInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a negative int value', () {
      final value = Decimal(value: '-20', precision: 2, scale: 0);
      final expected = BigInteger(-20);
      final operation = value.toBigInteger();
      expect(operation.identicalTo(expected), true);
    });
  });

  group('toInteger() method', () {
    test('should cast correctly an int value', () {
      final value = Decimal(value: '24', precision: 2, scale: -1);
      final expected = Integer(20);
      final operation = value.toInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a zero value', () {
      final value = Decimal(value: '14', precision: 2, scale: -3);
      final expected = Integer(0);
      final operation = value.toInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a negative int value', () {
      final value = Decimal(value: '-24', precision: 2, scale: -1);
      final expected = Integer(-20);
      final operation = value.toInteger();
      expect(operation.identicalTo(expected), true);
    });
  });

  group('toSmallInteger() method', () {
    test('should cast correctly an int value', () {
      final value = Decimal(value: '24', precision: 2, scale: -1);
      final expected = SmallInteger(20);
      final operation = value.toSmallInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a zero value', () {
      final value = Decimal(value: '14', precision: 2, scale: -3);
      final expected = SmallInteger(0);
      final operation = value.toSmallInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a negative int value', () {
      final value = Decimal(value: '-24', precision: 2, scale: -1);
      final expected = SmallInteger(-20);
      final operation = value.toSmallInteger();
      expect(operation.identicalTo(expected), true);
    });
  });

  group('toBigSerial() method', () {
    test('should cast correctly an int value', () {
      final value = Decimal(value: '24', precision: 2, scale: -1);
      final expected = BigSerial(20);
      final operation = value.toBigSerial();
      expect(operation.identicalTo(expected), true);
    });

    test('should throw a RangeError if casting zero value', () {
      final value = Decimal(value: '14', precision: 2, scale: -3);
      expect(() => value.toBigSerial(), throwsRangeError);
    });

    test('should throw a RangeError if casting negative value', () {
      final value = Decimal(value: '-14', precision: 2, scale: -1);
      expect(() => value.toBigSerial(), throwsRangeError);
    });
  });

  group('toSerial() method', () {
    test('should cast correctly an int value', () {
      final value = Decimal(value: '24', precision: 2, scale: -1);
      final expected = Serial(20);
      final operation = value.toSerial();
      expect(operation.identicalTo(expected), true);
    });

    test('should throw a RangeError if casting zero value', () {
      final value = Decimal(value: '14', precision: 2, scale: -3);
      expect(() => value.toSerial(), throwsRangeError);
    });

    test('should throw a RangeError if casting negative value', () {
      final value = Decimal(value: '-24', precision: 2, scale: -1);
      expect(() => value.toSerial(), throwsRangeError);
    });
  });

  group('toSmallSerial() method', () {
    test('should cast correctly an int value', () {
      final value = Decimal(value: '24', precision: 2, scale: -1);
      final expected = SmallSerial(20);
      final operation = value.toSmallSerial();
      expect(operation.identicalTo(expected), true);
    });

    test('should throw a RangeError if casting zero value', () {
      final value = Decimal(value: '14', precision: 2, scale: -3);
      expect(() => value.toSmallSerial(), throwsRangeError);
    });

    test('should throw a RangeError if casting negative value', () {
      final value = Decimal(value: '-24', precision: 2, scale: -1);
      expect(() => value.toSmallSerial(), throwsRangeError);
    });
  });

  group('toReal() method', () {
    test('should cast correctly an int value', () {
      final value = Decimal(value: '24', precision: 2, scale: -1);
      final expected = Real(20);
      final operation = value.toReal();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a zero value', () {
      final value = Decimal(value: '14', precision: 2, scale: -3);
      final expected = Real(0);
      final operation = value.toReal();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a negative int value', () {
      final value = Decimal(value: '-24', precision: 2, scale: -1);
      final expected = Real(-20);
      final operation = value.toReal();
      expect(operation.identicalTo(expected), true);
    });
  });

  group('toDoublePrecision() method', () {
    test('should cast correctly an int value', () {
      final value = Decimal(value: '24', precision: 2, scale: -1);
      final expected = DoublePrecision(20);
      final operation = value.toDoublePrecision();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a zero value', () {
      final value = Decimal(value: '14', precision: 2, scale: -3);
      final expected = DoublePrecision(0);
      final operation = value.toDoublePrecision();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a negative int value', () {
      final value = Decimal(value: '-24', precision: 2, scale: -1);
      final expected = DoublePrecision(-20);
      final operation = value.toDoublePrecision();
      expect(operation.identicalTo(expected), true);
    });
  });

  group('toNumeric() method', () {
    test('should cast correctly an int value', () {
      final value = Decimal(value: '24', precision: 2, scale: -1);
      final expected = Numeric(value: '20', precision: 2, scale: 0);
      final operation = value.toNumeric();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a zero value', () {
      final value = Decimal(value: '14', precision: 2, scale: -3);
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value.toNumeric();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a negative int value', () {
      final value = Decimal(value: '-24', precision: 2, scale: -1);
      final expected = Numeric(value: '-20', precision: 2, scale: 0);
      final operation = value.toNumeric();
      expect(operation.identicalTo(expected), true);
    });
  });

  group('toDecimal() method', () {
    test('should cast correctly an int value', () {
      final value = Decimal(value: '24', precision: 2, scale: -1);
      final expected = Decimal(value: '20', precision: 2, scale: 0);
      final operation = value.toDecimal();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a zero value', () {
      final value = Decimal(value: '14', precision: 2, scale: -3);
      final expected = Decimal(value: '0', precision: 1, scale: 0);
      final operation = value.toDecimal();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a negative int value', () {
      final value = Decimal(value: '-24', precision: 2, scale: -1);
      final expected = Decimal(value: '-20', precision: 2, scale: 0);
      final operation = value.toDecimal();
      expect(operation.identicalTo(expected), true);
    });
  });

  group('toChar() method', () {
    test('should cast correctly an int value', () {
      final value = Decimal(value: '24', precision: 2, scale: -1);
      final expected = Char('20', length: 2);
      final operation = value.toChar();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a zero value', () {
      final value = Decimal(value: '14', precision: 2, scale: -3);
      final expected = Char('0', length: 1);
      final operation = value.toChar();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a negative int value', () {
      final value = Decimal(value: '-24', precision: 2, scale: -1);
      final expected = Char('-20', length: 3);
      final operation = value.toChar();
      expect(operation.identicalTo(expected), true);
    });
  });

  group('toVarChar() method', () {
    test('should cast correctly an int value', () {
      final value = Decimal(value: '24', precision: 2, scale: -1);
      final expected = VarChar('20', length: 2);
      final operation = value.toVarChar();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a zero value', () {
      final value = Decimal(value: '14', precision: 2, scale: -3);
      final expected = VarChar('0', length: 1);
      final operation = value.toVarChar();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a negative int value', () {
      final value = Decimal(value: '-24', precision: 2, scale: -1);
      final expected = VarChar('-20', length: 3);
      final operation = value.toVarChar();
      expect(operation.identicalTo(expected), true);
    });
  });

  group('toText() method', () {
    test('should cast correctly an int value', () {
      final value = Decimal(value: '24', precision: 2, scale: -1);
      final expected = Text('20');
      final operation = value.toText();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a zero value', () {
      final value = Decimal(value: '14', precision: 2, scale: -3);
      final expected = Text('0');
      final operation = value.toText();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a negative int value', () {
      final value = Decimal(value: '-24', precision: 2, scale: -1);
      final expected = Text('-20');
      final operation = value.toText();
      expect(operation.identicalTo(expected), true);
    });
  });
}
