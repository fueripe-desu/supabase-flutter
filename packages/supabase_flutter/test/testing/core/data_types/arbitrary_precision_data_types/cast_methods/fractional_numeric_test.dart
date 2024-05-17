import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/character_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/floating_point_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
  group('toString() method', () {
    test('should cast correctly a positive fractional value', () {
      final value = Numeric(value: '0.35', precision: 2, scale: 2);
      expect(value.toString() == '0.35', true);
    });

    test('should cast correctly a negative fractional value', () {
      final value = Numeric(value: '-0.35', precision: 2, scale: 2);
      expect(value.toString() == '-0.35', true);
    });
  });

  group('toDetailedString() method', () {
    test('should cast correctly a positive fractional value', () {
      final value = Numeric(value: '0.35', precision: 2, scale: 2);
      expect(
        value.toDetailedString() == 'Precision: 2, Scale: 2, Value: 0.35',
        true,
      );
    });

    test('should cast correctly a negative fractional value', () {
      final value = Numeric(value: '-0.35', precision: 2, scale: 2);
      expect(
        value.toDetailedString() == 'Precision: 2, Scale: 2, Value: -0.35',
        true,
      );
    });
  });

  group('toPrimitiveInt() method', () {
    test('should cast correctly an double value', () {
      final value = Numeric(value: '0.35', precision: 2, scale: 2);
      expect(value.toPrimitiveInt(), 0);
      expect(value.toPrimitiveInt(), isA<int>());
    });

    test('should cast correctly a zero value', () {
      final value = Numeric(value: '0.0', precision: 1, scale: 1);
      expect(value.toPrimitiveInt(), 0);
      expect(value.toPrimitiveInt(), isA<int>());
    });

    test('should cast correctly a negative double value', () {
      final value = Numeric(value: '-0.35', precision: 2, scale: 2);
      expect(value.toPrimitiveInt(), 0);
      expect(value.toPrimitiveInt(), isA<int>());
    });
  });

  group('toPrimitiveDouble() method', () {
    test('should cast correctly an double value', () {
      final value = Numeric(value: '0.35', precision: 2, scale: 2);
      expect(value.toPrimitiveDouble(), 0.35);
      expect(value.toPrimitiveDouble(), isA<double>());
    });

    test('should cast correctly a zero value', () {
      final value = Numeric(value: '0.0', precision: 1, scale: 1);
      expect(value.toPrimitiveDouble(), 0.0);
      expect(value.toPrimitiveDouble(), isA<double>());
    });

    test('should cast correctly a negative double value', () {
      final value = Numeric(value: '-0.35', precision: 2, scale: 2);
      expect(value.toPrimitiveDouble(), -0.35);
      expect(value.toPrimitiveDouble(), isA<double>());
    });
  });

  group('toBigInteger() method', () {
    test('should cast correctly an double value', () {
      final value = Numeric(value: '0.35', precision: 2, scale: 2);
      final expected = BigInteger(0);
      final operation = value.toBigInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a zero value', () {
      final value = Numeric(value: '0.0', precision: 1, scale: 1);
      final expected = BigInteger(0);
      final operation = value.toBigInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a negative double value', () {
      final value = Numeric(value: '-0.35', precision: 2, scale: 2);
      final expected = BigInteger(0);
      final operation = value.toBigInteger();
      expect(operation.identicalTo(expected), true);
    });
  });

  group('toInteger() method', () {
    test('should cast correctly an double value', () {
      final value = Numeric(value: '0.35', precision: 2, scale: 2);
      final expected = Integer(0);
      final operation = value.toInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a zero value', () {
      final value = Numeric(value: '0.0', precision: 1, scale: 1);
      final expected = Integer(0);
      final operation = value.toInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a negative double value', () {
      final value = Numeric(value: '-0.35', precision: 2, scale: 2);
      final expected = Integer(0);
      final operation = value.toInteger();
      expect(operation.identicalTo(expected), true);
    });
  });

  group('toSmallInteger() method', () {
    test('should cast correctly an double value', () {
      final value = Numeric(value: '0.35', precision: 2, scale: 2);
      final expected = SmallInteger(0);
      final operation = value.toSmallInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a zero value', () {
      final value = Numeric(value: '0.0', precision: 1, scale: 1);
      final expected = SmallInteger(0);
      final operation = value.toSmallInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a negative double value', () {
      final value = Numeric(value: '-0.35', precision: 2, scale: 2);
      final expected = SmallInteger(0);
      final operation = value.toSmallInteger();
      expect(operation.identicalTo(expected), true);
    });
  });

  group('toBigSerial() method', () {
    test('should throw a RangeError if casting positive value', () {
      final value = Numeric(value: '0.35', precision: 2, scale: 2);
      expect(() => value.toBigSerial(), throwsRangeError);
    });

    test('should throw a RangeError if casting zero value', () {
      final value = Numeric(value: '0.0', precision: 1, scale: 1);
      expect(() => value.toBigSerial(), throwsRangeError);
    });

    test('should throw a RangeError if casting negative value', () {
      final value = Numeric(value: '-0.35', precision: 2, scale: 2);
      expect(() => value.toBigSerial(), throwsRangeError);
    });
  });

  group('toSerial() method', () {
    test('should throw a RangeError if casting positive value', () {
      final value = Numeric(value: '0.35', precision: 2, scale: 2);
      expect(() => value.toSerial(), throwsRangeError);
    });

    test('should throw a RangeError if casting zero value', () {
      final value = Numeric(value: '0.0', precision: 1, scale: 1);
      expect(() => value.toSerial(), throwsRangeError);
    });

    test('should throw a RangeError if casting negative value', () {
      final value = Numeric(value: '-0.35', precision: 2, scale: 2);
      expect(() => value.toSerial(), throwsRangeError);
    });
  });

  group('toSmallSerial() method', () {
    test('should throw a RangeError if casting positive value', () {
      final value = Numeric(value: '0.35', precision: 2, scale: 2);
      expect(() => value.toSmallSerial(), throwsRangeError);
    });

    test('should throw a RangeError if casting zero value', () {
      final value = Numeric(value: '0.0', precision: 1, scale: 1);
      expect(() => value.toSmallSerial(), throwsRangeError);
    });

    test('should throw a RangeError if casting negative value', () {
      final value = Numeric(value: '-0.35', precision: 2, scale: 2);
      expect(() => value.toSmallSerial(), throwsRangeError);
    });
  });

  group('toReal() method', () {
    test('should cast correctly an double value', () {
      final value = Numeric(value: '0.35', precision: 2, scale: 2);
      final expected = Real(0.35);
      final operation = value.toReal();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a zero value', () {
      final value = Numeric(value: '0.0', precision: 1, scale: 1);
      final expected = Real(0);
      final operation = value.toReal();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a negative double value', () {
      final value = Numeric(value: '-0.35', precision: 2, scale: 2);
      final expected = Real(-0.35);
      final operation = value.toReal();
      expect(operation.identicalTo(expected), true);
    });
  });

  group('toDoublePrecision() method', () {
    test('should cast correctly an double value', () {
      final value = Numeric(value: '0.35', precision: 2, scale: 2);
      final expected = DoublePrecision(0.35);
      final operation = value.toDoublePrecision();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a zero value', () {
      final value = Numeric(value: '0.0', precision: 1, scale: 1);
      final expected = DoublePrecision(0);
      final operation = value.toDoublePrecision();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a negative double value', () {
      final value = Numeric(value: '-0.35', precision: 2, scale: 2);
      final expected = DoublePrecision(-0.35);
      final operation = value.toDoublePrecision();
      expect(operation.identicalTo(expected), true);
    });
  });

  group('toNumeric() method', () {
    test('should cast correctly an double value', () {
      final value = Numeric(value: '0.35', precision: 2, scale: 2);
      final expected = Numeric(value: '0.35', precision: 2, scale: 2);
      final operation = value.toNumeric();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a zero value', () {
      final value = Numeric(value: '0.0', precision: 1, scale: 1);
      final expected = Numeric(value: '0.0', precision: 1, scale: 1);
      final operation = value.toNumeric();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a negative double value', () {
      final value = Numeric(value: '-0.35', precision: 2, scale: 2);
      final expected = Numeric(value: '-0.35', precision: 2, scale: 2);
      final operation = value.toNumeric();
      expect(operation.identicalTo(expected), true);
    });
  });

  group('toDecimal() method', () {
    test('should cast correctly an double value', () {
      final value = Numeric(value: '0.35', precision: 2, scale: 2);
      final expected = Decimal(value: '0.35', precision: 2, scale: 2);
      final operation = value.toDecimal();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a zero value', () {
      final value = Numeric(value: '0.0', precision: 1, scale: 1);
      final expected = Decimal(value: '0.0', precision: 1, scale: 1);
      final operation = value.toDecimal();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a negative double value', () {
      final value = Numeric(value: '-0.35', precision: 2, scale: 2);
      final expected = Decimal(value: '-0.35', precision: 2, scale: 2);
      final operation = value.toDecimal();
      expect(operation.identicalTo(expected), true);
    });
  });

  group('toChar() method', () {
    test('should cast correctly an double value', () {
      final value = Numeric(value: '0.35', precision: 2, scale: 2);
      final expected = Char('0.35', length: 4);
      final operation = value.toChar();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a zero value', () {
      final value = Numeric(value: '0.0', precision: 1, scale: 1);
      final expected = Char('0.0', length: 3);
      final operation = value.toChar();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a negative double value', () {
      final value = Numeric(value: '-0.35', precision: 2, scale: 2);
      final expected = Char('-0.35', length: 5);
      final operation = value.toChar();
      expect(operation.identicalTo(expected), true);
    });
  });

  group('toVarChar() method', () {
    test('should cast correctly an double value', () {
      final value = Numeric(value: '0.35', precision: 2, scale: 2);
      final expected = VarChar('0.35', length: 4);
      final operation = value.toVarChar();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a zero value', () {
      final value = Numeric(value: '0.0', precision: 1, scale: 1);
      final expected = VarChar('0.0', length: 3);
      final operation = value.toVarChar();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a negative double value', () {
      final value = Numeric(value: '-0.35', precision: 2, scale: 2);
      final expected = VarChar('-0.35', length: 5);
      final operation = value.toVarChar();
      expect(operation.identicalTo(expected), true);
    });
  });

  group('toText() method', () {
    test('should cast correctly an double value', () {
      final value = Numeric(value: '0.35', precision: 2, scale: 2);
      final expected = Text('0.35');
      final operation = value.toText();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a zero value', () {
      final value = Numeric(value: '0.0', precision: 1, scale: 1);
      final expected = Text('0.0');
      final operation = value.toText();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast correctly a negative double value', () {
      final value = Numeric(value: '-0.35', precision: 2, scale: 2);
      final expected = Text('-0.35');
      final operation = value.toText();
      expect(operation.identicalTo(expected), true);
    });
  });
}
