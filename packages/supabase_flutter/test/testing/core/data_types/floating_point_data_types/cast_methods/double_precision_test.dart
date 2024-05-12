import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/character_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/floating_point_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
  group('toString() method', () {
    test('should cast integer-valued positive values correctly', () {
      final value = DoublePrecision(20);
      final operation = value.toString();
      expect(operation, '20.0');
    });

    test('should cast fractional positive values correctly', () {
      final value = DoublePrecision(20.5);
      final operation = value.toString();
      expect(operation, '20.5');
    });

    test('should cast integer-valued zero values correctly', () {
      final value = DoublePrecision(0);
      final operation = value.toString();
      expect(operation, '0.0');
    });

    test('should cast fractional zero values correctly', () {
      final value = DoublePrecision(0.0);
      final operation = value.toString();
      expect(operation, '0.0');
    });

    test('should cast integer-valued negative values correctly', () {
      final value = DoublePrecision(-20);
      final operation = value.toString();
      expect(operation, '-20.0');
    });

    test('should cast fractional negative values correctly', () {
      final value = DoublePrecision(-20.5);
      final operation = value.toString();
      expect(operation, '-20.5');
    });
  });

  group('toDetailedString() method', () {
    test('should cast integer-valued positive values correctly', () {
      final value = DoublePrecision(20);
      final operation = value.toDetailedString();
      expect(operation, '20.0');
    });

    test('should cast fractional positive values correctly', () {
      final value = DoublePrecision(20.5);
      final operation = value.toDetailedString();
      expect(operation, '20.5');
    });

    test('should cast integer-valued zero values correctly', () {
      final value = DoublePrecision(0);
      final operation = value.toDetailedString();
      expect(operation, '0.0');
    });

    test('should cast fractional zero values correctly', () {
      final value = DoublePrecision(0.0);
      final operation = value.toDetailedString();
      expect(operation, '0.0');
    });

    test('should cast integer-valued negative values correctly', () {
      final value = DoublePrecision(-20);
      final operation = value.toDetailedString();
      expect(operation, '-20.0');
    });

    test('should cast fractional negative values correctly', () {
      final value = DoublePrecision(-20.5);
      final operation = value.toDetailedString();
      expect(operation, '-20.5');
    });
  });

  group('toPrimitiveInt() method', () {
    test('should cast integer-valued positive values correctly', () {
      final value = DoublePrecision(20);
      final operation = value.toPrimitiveInt();
      expect(operation, 20);
    });

    test('should cast fractional positive values correctly', () {
      final value = DoublePrecision(20.5);
      final operation = value.toPrimitiveInt();
      expect(operation, 20);
    });

    test('should cast integer-valued zero values correctly', () {
      final value = DoublePrecision(0);
      final operation = value.toPrimitiveInt();
      expect(operation, 0);
    });

    test('should cast fractional zero values correctly', () {
      final value = DoublePrecision(0.0);
      final operation = value.toPrimitiveInt();
      expect(operation, 0);
    });

    test('should cast integer-valued negative values correctly', () {
      final value = DoublePrecision(-20);
      final operation = value.toPrimitiveInt();
      expect(operation, -20);
    });

    test('should cast fractional negative values correctly', () {
      final value = DoublePrecision(-20.5);
      final operation = value.toPrimitiveInt();
      expect(operation, -20);
    });
  });

  group('toPrimitiveDouble() method', () {
    test('should cast integer-valued positive values correctly', () {
      final value = DoublePrecision(20);
      final operation = value.toPrimitiveDouble();
      expect(operation, 20.0);
    });

    test('should cast fractional positive values correctly', () {
      final value = DoublePrecision(20.5);
      final operation = value.toPrimitiveDouble();
      expect(operation, 20.5);
    });

    test('should cast integer-valued zero values correctly', () {
      final value = DoublePrecision(0);
      final operation = value.toPrimitiveDouble();
      expect(operation, 0.0);
    });

    test('should cast fractional zero values correctly', () {
      final value = DoublePrecision(0.0);
      final operation = value.toPrimitiveDouble();
      expect(operation, 0.0);
    });

    test('should cast integer-valued negative values correctly', () {
      final value = DoublePrecision(-20);
      final operation = value.toPrimitiveDouble();
      expect(operation, -20.0);
    });

    test('should cast fractional negative values correctly', () {
      final value = DoublePrecision(-20.5);
      final operation = value.toPrimitiveDouble();
      expect(operation, -20.5);
    });
  });

  group('toSmallInteger() method', () {
    test('should cast integer-valued positive values correctly', () {
      final value = DoublePrecision(20);
      final expected = SmallInteger(20);
      final operation = value.toSmallInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast fractional positive values correctly', () {
      final value = DoublePrecision(20.5);
      final expected = SmallInteger(20);
      final operation = value.toSmallInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast integer-valued zero values correctly', () {
      final value = DoublePrecision(0);
      final expected = SmallInteger(0);
      final operation = value.toSmallInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast fractional zero values correctly', () {
      final value = DoublePrecision(0.0);
      final expected = SmallInteger(0);
      final operation = value.toSmallInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast integer-valued negative values correctly', () {
      final value = DoublePrecision(-20);
      final expected = SmallInteger(-20);
      final operation = value.toSmallInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast fractional negative values correctly', () {
      final value = DoublePrecision(-20.5);
      final expected = SmallInteger(-20);
      final operation = value.toSmallInteger();
      expect(operation.identicalTo(expected), true);
    });
  });

  group('toInteger() method', () {
    test('should cast integer-valued positive values correctly', () {
      final value = DoublePrecision(20);
      final expected = Integer(20);
      final operation = value.toInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast fractional positive values correctly', () {
      final value = DoublePrecision(20.5);
      final expected = Integer(20);
      final operation = value.toInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast integer-valued zero values correctly', () {
      final value = DoublePrecision(0);
      final expected = Integer(0);
      final operation = value.toInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast fractional zero values correctly', () {
      final value = DoublePrecision(0.0);
      final expected = Integer(0);
      final operation = value.toInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast integer-valued negative values correctly', () {
      final value = DoublePrecision(-20);
      final expected = Integer(-20);
      final operation = value.toInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast fractional negative values correctly', () {
      final value = DoublePrecision(-20.5);
      final expected = Integer(-20);
      final operation = value.toInteger();
      expect(operation.identicalTo(expected), true);
    });
  });

  group('toBigInteger() method', () {
    test('should cast integer-valued positive values correctly', () {
      final value = DoublePrecision(20);
      final expected = BigInteger(20);
      final operation = value.toBigInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast fractional positive values correctly', () {
      final value = DoublePrecision(20.5);
      final expected = BigInteger(20);
      final operation = value.toBigInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast integer-valued zero values correctly', () {
      final value = DoublePrecision(0);
      final expected = BigInteger(0);
      final operation = value.toBigInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast fractional zero values correctly', () {
      final value = DoublePrecision(0.0);
      final expected = BigInteger(0);
      final operation = value.toBigInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast integer-valued negative values correctly', () {
      final value = DoublePrecision(-20);
      final expected = BigInteger(-20);
      final operation = value.toBigInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast fractional negative values correctly', () {
      final value = DoublePrecision(-20.5);
      final expected = BigInteger(-20);
      final operation = value.toBigInteger();
      expect(operation.identicalTo(expected), true);
    });
  });

  group('toSmallSerial() method', () {
    test('should cast integer-valued positive values correctly', () {
      final value = DoublePrecision(20);
      final expected = SmallSerial(20);
      final operation = value.toSmallSerial();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast fractional positive values correctly', () {
      final value = DoublePrecision(20.5);
      final expected = SmallSerial(20);
      final operation = value.toSmallSerial();
      expect(operation.identicalTo(expected), true);
    });
  });

  group('toSerial() method', () {
    test('should cast integer-valued positive values correctly', () {
      final value = DoublePrecision(20);
      final expected = Serial(20);
      final operation = value.toSerial();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast fractional positive values correctly', () {
      final value = DoublePrecision(20.5);
      final expected = Serial(20);
      final operation = value.toSerial();
      expect(operation.identicalTo(expected), true);
    });
  });

  group('toBigSerial() method', () {
    test('should cast integer-valued positive values correctly', () {
      final value = DoublePrecision(20);
      final expected = BigSerial(20);
      final operation = value.toBigSerial();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast fractional positive values correctly', () {
      final value = DoublePrecision(20.5);
      final expected = BigSerial(20);
      final operation = value.toBigSerial();
      expect(operation.identicalTo(expected), true);
    });
  });

  group('toReal() method', () {
    test('should cast integer-valued positive values correctly', () {
      final value = DoublePrecision(20);
      final expected = Real(20);
      final operation = value.toReal();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast fractional positive values correctly', () {
      final value = DoublePrecision(20.5);
      final expected = Real(20.5);
      final operation = value.toReal();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast integer-valued zero values correctly', () {
      final value = DoublePrecision(0);
      final expected = Real(0);
      final operation = value.toReal();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast fractional zero values correctly', () {
      final value = DoublePrecision(0.0);
      final expected = Real(0);
      final operation = value.toReal();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast integer-valued negative values correctly', () {
      final value = DoublePrecision(-20);
      final expected = Real(-20);
      final operation = value.toReal();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast fractional negative values correctly', () {
      final value = DoublePrecision(-20.5);
      final expected = Real(-20.5);
      final operation = value.toReal();
      expect(operation.identicalTo(expected), true);
    });
  });

  group('toDoublePrecision() method', () {
    test('should cast integer-valued positive values correctly', () {
      final value = DoublePrecision(20);
      final expected = DoublePrecision(20);
      final operation = value.toDoublePrecision();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast fractional positive values correctly', () {
      final value = DoublePrecision(20.5);
      final expected = DoublePrecision(20.5);
      final operation = value.toDoublePrecision();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast integer-valued zero values correctly', () {
      final value = DoublePrecision(0);
      final expected = DoublePrecision(0);
      final operation = value.toDoublePrecision();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast fractional zero values correctly', () {
      final value = DoublePrecision(0.0);
      final expected = DoublePrecision(0);
      final operation = value.toDoublePrecision();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast integer-valued negative values correctly', () {
      final value = DoublePrecision(-20);
      final expected = DoublePrecision(-20);
      final operation = value.toDoublePrecision();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast fractional negative values correctly', () {
      final value = DoublePrecision(-20.5);
      final expected = DoublePrecision(-20.5);
      final operation = value.toDoublePrecision();
      expect(operation.identicalTo(expected), true);
    });
  });

  group('toNumeric() method', () {
    test('should cast integer-valued positive values correctly', () {
      final value = DoublePrecision(20);
      final expected = Numeric(value: '20.0', precision: 3, scale: 1);
      final operation = value.toNumeric();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast fractional positive values correctly', () {
      final value = DoublePrecision(20.5);
      final expected = Numeric(value: '20.5', precision: 3, scale: 1);
      final operation = value.toNumeric();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast integer-valued zero values correctly', () {
      final value = DoublePrecision(0);
      final expected = Numeric(value: '0.0', precision: 2, scale: 1);
      final operation = value.toNumeric();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast fractional zero values correctly', () {
      final value = DoublePrecision(0.0);
      final expected = Numeric(value: '0.0', precision: 2, scale: 1);
      final operation = value.toNumeric();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast integer-valued negative values correctly', () {
      final value = DoublePrecision(-20);
      final expected = Numeric(value: '-20.0', precision: 3, scale: 1);
      final operation = value.toNumeric();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast fractional negative values correctly', () {
      final value = DoublePrecision(-20.5);
      final expected = Numeric(value: '-20.5', precision: 3, scale: 1);
      final operation = value.toNumeric();
      expect(operation.identicalTo(expected), true);
    });
  });

  group('toDecimal() method', () {
    test('should cast integer-valued positive values correctly', () {
      final value = DoublePrecision(20);
      final expected = Decimal(value: '20.0', precision: 3, scale: 1);
      final operation = value.toDecimal();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast fractional positive values correctly', () {
      final value = DoublePrecision(20.5);
      final expected = Decimal(value: '20.5', precision: 3, scale: 1);
      final operation = value.toDecimal();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast integer-valued zero values correctly', () {
      final value = DoublePrecision(0);
      final expected = Decimal(value: '0.0', precision: 2, scale: 1);
      final operation = value.toDecimal();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast fractional zero values correctly', () {
      final value = DoublePrecision(0.0);
      final expected = Decimal(value: '0.0', precision: 2, scale: 1);
      final operation = value.toDecimal();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast integer-valued negative values correctly', () {
      final value = DoublePrecision(-20);
      final expected = Decimal(value: '-20.0', precision: 3, scale: 1);
      final operation = value.toDecimal();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast fractional negative values correctly', () {
      final value = DoublePrecision(-20.5);
      final expected = Decimal(value: '-20.5', precision: 3, scale: 1);
      final operation = value.toDecimal();
      expect(operation.identicalTo(expected), true);
    });
  });

  group('toChar() method', () {
    test('should cast integer-valued positive values correctly', () {
      final value = DoublePrecision(20);
      final expected = Char('20.0', length: 4);
      final operation = value.toChar();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast fractional positive values correctly', () {
      final value = DoublePrecision(20.5);
      final expected = Char('20.5', length: 4);
      final operation = value.toChar();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast integer-valued zero values correctly', () {
      final value = DoublePrecision(0);
      final expected = Char('0.0', length: 3);
      final operation = value.toChar();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast fractional zero values correctly', () {
      final value = DoublePrecision(0.0);
      final expected = Char('0.0', length: 3);
      final operation = value.toChar();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast integer-valued negative values correctly', () {
      final value = DoublePrecision(-20);
      final expected = Char('-20.0', length: 5);
      final operation = value.toChar();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast fractional negative values correctly', () {
      final value = DoublePrecision(-20.5);
      final expected = Char('-20.5', length: 5);
      final operation = value.toChar();
      expect(operation.identicalTo(expected), true);
    });
  });

  group('toVarChar() method', () {
    test('should cast integer-valued positive values correctly', () {
      final value = DoublePrecision(20);
      final expected = VarChar('20.0', length: 4);
      final operation = value.toVarChar();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast fractional positive values correctly', () {
      final value = DoublePrecision(20.5);
      final expected = VarChar('20.5', length: 4);
      final operation = value.toVarChar();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast integer-valued zero values correctly', () {
      final value = DoublePrecision(0);
      final expected = VarChar('0.0', length: 3);
      final operation = value.toVarChar();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast fractional zero values correctly', () {
      final value = DoublePrecision(0.0);
      final expected = VarChar('0.0', length: 3);
      final operation = value.toVarChar();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast integer-valued negative values correctly', () {
      final value = DoublePrecision(-20);
      final expected = VarChar('-20.0', length: 5);
      final operation = value.toVarChar();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast fractional negative values correctly', () {
      final value = DoublePrecision(-20.5);
      final expected = VarChar('-20.5', length: 5);
      final operation = value.toVarChar();
      expect(operation.identicalTo(expected), true);
    });
  });

  group('toText() method', () {
    test('should cast integer-valued positive values correctly', () {
      final value = DoublePrecision(20);
      final expected = Text('20.0');
      final operation = value.toText();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast fractional positive values correctly', () {
      final value = DoublePrecision(20.5);
      final expected = Text('20.5');
      final operation = value.toText();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast integer-valued zero values correctly', () {
      final value = DoublePrecision(0);
      final expected = Text('0.0');
      final operation = value.toText();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast fractional zero values correctly', () {
      final value = DoublePrecision(0.0);
      final expected = Text('0.0');
      final operation = value.toText();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast integer-valued negative values correctly', () {
      final value = DoublePrecision(-20);
      final expected = Text('-20.0');
      final operation = value.toText();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast fractional negative values correctly', () {
      final value = DoublePrecision(-20.5);
      final expected = Text('-20.5');
      final operation = value.toText();
      expect(operation.identicalTo(expected), true);
    });
  });
}
