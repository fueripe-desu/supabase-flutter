import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/character_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/floating_point_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
  group('toString() method', () {
    test('should cast positive values correctly', () {
      final value = SmallInteger(22);
      expect(value.toString(), '22');
    });

    test('should cast zero values correctly', () {
      final value = SmallInteger(0);
      expect(value.toString(), '0');
    });

    test('should cast negative values correctly', () {
      final value = SmallInteger(-10);
      expect(value.toString(), '-10');
    });
  });

  group('toDetailedString() method', () {
    test('should cast positive values correctly', () {
      final value = SmallInteger(22);
      expect(value.toDetailedString(), '22');
    });

    test('should cast zero values correctly', () {
      final value = SmallInteger(0);
      expect(value.toDetailedString(), '0');
    });

    test('should cast negative values correctly', () {
      final value = SmallInteger(-10);
      expect(value.toDetailedString(), '-10');
    });
  });

  group('toPrimitiveDouble() method', () {
    test('should cast positive values correctly', () {
      final value = SmallInteger(22);
      expect(value.toPrimitiveDouble(), 22.0);
    });

    test('should cast zero values correctly', () {
      final value = SmallInteger(0);
      expect(value.toPrimitiveDouble(), 0.0);
    });

    test('should cast negative values correctly', () {
      final value = SmallInteger(-10);
      expect(value.toPrimitiveDouble(), -10.0);
    });
  });

  group('toPrimitiveInt() method', () {
    test('should cast positive values correctly', () {
      final value = SmallInteger(22);
      expect(value.toPrimitiveInt(), 22);
    });

    test('should cast zero values correctly', () {
      final value = SmallInteger(0);
      expect(value.toPrimitiveInt(), 0);
    });

    test('should cast negative values correctly', () {
      final value = SmallInteger(-10);
      expect(value.toPrimitiveInt(), -10);
    });
  });

  group('toSmallInteger() method', () {
    test('should cast positive values correctly', () {
      final value = SmallInteger(22);
      final expected = SmallInteger(22);
      final operation = value.toSmallInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast zero values correctly', () {
      final value = SmallInteger(0);
      final expected = SmallInteger(0);
      final operation = value.toSmallInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast negative values correctly', () {
      final value = SmallInteger(-10);
      final expected = SmallInteger(-10);
      final operation = value.toSmallInteger();
      expect(operation.identicalTo(expected), true);
    });
  });

  group('toInteger() method', () {
    test('should cast positive values correctly', () {
      final value = SmallInteger(22);
      final expected = Integer(22);
      final operation = value.toInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast zero values correctly', () {
      final value = SmallInteger(0);
      final expected = Integer(0);
      final operation = value.toInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast negative values correctly', () {
      final value = SmallInteger(-10);
      final expected = Integer(-10);
      final operation = value.toInteger();
      expect(operation.identicalTo(expected), true);
    });
  });

  group('toBigInteger() method', () {
    test('should cast positive values correctly', () {
      final value = SmallInteger(22);
      final expected = BigInteger(22);
      final operation = value.toBigInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast zero values correctly', () {
      final value = SmallInteger(0);
      final expected = BigInteger(0);
      final operation = value.toBigInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast negative values correctly', () {
      final value = SmallInteger(-10);
      final expected = BigInteger(-10);
      final operation = value.toBigInteger();
      expect(operation.identicalTo(expected), true);
    });
  });

  group('toSmallSerial() method', () {
    test('should cast positive values correctly', () {
      final value = SmallInteger(22);
      final expected = SmallSerial(22);
      final operation = value.toSmallSerial();
      expect(operation.identicalTo(expected), true);
    });
  });

  group('toSerial() method', () {
    test('should cast positive values correctly', () {
      final value = SmallInteger(22);
      final expected = Serial(22);
      final operation = value.toSerial();
      expect(operation.identicalTo(expected), true);
    });
  });

  group('toBigSerial() method', () {
    test('should cast positive values correctly', () {
      final value = SmallInteger(22);
      final expected = BigSerial(22);
      final operation = value.toBigSerial();
      expect(operation.identicalTo(expected), true);
    });
  });

  group('toReal() method', () {
    test('should cast positive values correctly', () {
      final value = SmallInteger(22);
      final expected = Real(22);
      final operation = value.toReal();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast zero values correctly', () {
      final value = SmallInteger(0);
      final expected = Real(0);
      final operation = value.toReal();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast negative values correctly', () {
      final value = SmallInteger(-10);
      final expected = Real(-10);
      final operation = value.toReal();
      expect(operation.identicalTo(expected), true);
    });
  });

  group('toDoublePrecision() method', () {
    test('should cast positive values correctly', () {
      final value = SmallInteger(22);
      final expected = DoublePrecision(22);
      final operation = value.toDoublePrecision();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast zero values correctly', () {
      final value = SmallInteger(0);
      final expected = DoublePrecision(0);
      final operation = value.toDoublePrecision();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast negative values correctly', () {
      final value = SmallInteger(-10);
      final expected = DoublePrecision(-10);
      final operation = value.toDoublePrecision();
      expect(operation.identicalTo(expected), true);
    });
  });

  group('toNumeric() method', () {
    test('should cast positive values correctly', () {
      final value = SmallInteger(22);
      final expected = Numeric(value: '22', precision: 2, scale: 0);
      final operation = value.toNumeric();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast zero values correctly', () {
      final value = SmallInteger(0);
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value.toNumeric();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast negative values correctly', () {
      final value = SmallInteger(-10);
      final expected = Numeric(value: '-10', precision: 2, scale: 0);
      final operation = value.toNumeric();
      expect(operation.identicalTo(expected), true);
    });
  });

  group('toDecimal() method', () {
    test('should cast positive values correctly', () {
      final value = SmallInteger(22);
      final expected = Decimal(value: '22', precision: 2, scale: 0);
      final operation = value.toDecimal();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast zero values correctly', () {
      final value = SmallInteger(0);
      final expected = Decimal(value: '0', precision: 1, scale: 0);
      final operation = value.toDecimal();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast negative values correctly', () {
      final value = SmallInteger(-10);
      final expected = Decimal(value: '-10', precision: 2, scale: 0);
      final operation = value.toDecimal();
      expect(operation.identicalTo(expected), true);
    });
  });

  group('toChar() method', () {
    test('should cast positive values correctly', () {
      final value = SmallInteger(22);
      final expected = Char('22', length: 2);
      final operation = value.toChar();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast zero values correctly', () {
      final value = SmallInteger(0);
      final expected = Char('0', length: 1);
      final operation = value.toChar();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast negative values correctly', () {
      final value = SmallInteger(-10);
      final expected = Char('-10', length: 3);
      final operation = value.toChar();
      expect(operation.identicalTo(expected), true);
    });
  });

  group('toVarChar() method', () {
    test('should cast positive values correctly', () {
      final value = SmallInteger(22);
      final expected = VarChar('22', length: 2);
      final operation = value.toVarChar();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast zero values correctly', () {
      final value = SmallInteger(0);
      final expected = VarChar('0', length: 1);
      final operation = value.toVarChar();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast negative values correctly', () {
      final value = SmallInteger(-10);
      final expected = VarChar('-10', length: 3);
      final operation = value.toVarChar();
      expect(operation.identicalTo(expected), true);
    });
  });

  group('toText() method', () {
    test('should cast positive values correctly', () {
      final value = SmallInteger(22);
      final expected = Text('22');
      final operation = value.toText();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast zero values correctly', () {
      final value = SmallInteger(0);
      final expected = Text('0');
      final operation = value.toText();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast negative values correctly', () {
      final value = SmallInteger(-10);
      final expected = Text('-10');
      final operation = value.toText();
      expect(operation.identicalTo(expected), true);
    });
  });

  group('overflow and underflow errors', () {
    test('should throw RangeError if value underflows SmallSerial', () {
      final value = SmallInteger(SmallInteger.minValue);
      expect(() => value.toSmallSerial(), throwsRangeError);
    });

    test('should throw RangeError if value underflows Serial', () {
      final value = SmallInteger(SmallInteger.minValue);
      expect(() => value.toSerial(), throwsRangeError);
    });

    test('should throw RangeError if value underflows BigSerial', () {
      final value = SmallInteger(SmallInteger.minValue);
      expect(() => value.toBigSerial(), throwsRangeError);
    });
  });
}
