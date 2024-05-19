import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/character_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/floating_point_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
  group('toString() method', () {
    test('should correctly cast value', () {
      final value = VarChar('Hello', length: 5);
      const expected = 'Hello';
      final operation = value.toString();
      expect(operation, expected);
      expect(operation, isA<String>());
    });
  });

  group('toDetailedString() method', () {
    test('should correctly cast value', () {
      final value = VarChar('Hello', length: 5);
      const expected = 'Value: \'Hello\', Length: 5';
      final operation = value.toDetailedString();
      expect(operation, expected);
      expect(operation, isA<String>());
    });
  });

  group('toPrimitiveInt() method', () {
    test('should correctly cast positive values', () {
      final value = VarChar('20', length: 2);
      const expected = 20;
      final operation = value.toPrimitiveInt();
      expect(operation, expected);
      expect(operation, isA<int>());
    });

    test('should correctly cast zero values', () {
      final value = VarChar('0', length: 1);
      const expected = 0;
      final operation = value.toPrimitiveInt();
      expect(operation, expected);
      expect(operation, isA<int>());
    });

    test('should correctly cast negative values', () {
      final value = VarChar('-20', length: 3);
      const expected = -20;
      final operation = value.toPrimitiveInt();
      expect(operation, expected);
      expect(operation, isA<int>());
    });

    test(
        'should throw ArgumentError when casting positive floating-point values',
        () {
      final value = VarChar('3.14', length: 4);
      expect(() => value.toPrimitiveInt(), throwsArgumentError);
    });

    test(
        'should throw ArgumentError when casting negative floating-point values',
        () {
      final value = VarChar('-3.14', length: 5);
      expect(() => value.toPrimitiveInt(), throwsArgumentError);
    });

    test('should throw ArgumentError when casting non-numerical values', () {
      final value = VarChar('sample', length: 6);
      expect(() => value.toPrimitiveInt(), throwsArgumentError);
    });
  });

  group('toPrimitiveDouble() method', () {
    test('should correctly cast positive values', () {
      final value = VarChar('20.4', length: 4);
      const expected = 20.4;
      final operation = value.toPrimitiveDouble();
      expect(operation, expected);
      expect(operation, isA<double>());
    });

    test('should correctly cast zero values', () {
      final value = VarChar('0.0', length: 3);
      const expected = 0.0;
      final operation = value.toPrimitiveDouble();
      expect(operation, expected);
      expect(operation, isA<double>());
    });

    test('should correctly cast negative values', () {
      final value = VarChar('-20.4', length: 5);
      const expected = -20.4;
      final operation = value.toPrimitiveDouble();
      expect(operation, expected);
      expect(operation, isA<double>());
    });

    test('should correctly cast positive int values', () {
      final value = VarChar('14', length: 2);
      const expected = 14.0;
      final operation = value.toPrimitiveDouble();
      expect(operation, expected);
      expect(operation, isA<double>());
    });

    test('should correctly cast negative int values', () {
      final value = VarChar('-14', length: 3);
      const expected = -14.0;
      final operation = value.toPrimitiveDouble();
      expect(operation, expected);
      expect(operation, isA<double>());
    });

    test('should throw ArgumentError when casting non-numerical values', () {
      final value = VarChar('sample', length: 6);
      expect(() => value.toPrimitiveDouble(), throwsArgumentError);
    });
  });

  group('toBigInteger() method', () {
    test('should correctly cast positive values', () {
      final value = VarChar('20', length: 2);
      final expected = BigInteger(20);
      final operation = value.toBigInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly cast zero values', () {
      final value = VarChar('0', length: 1);
      final expected = BigInteger(0);
      final operation = value.toBigInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly cast negative values', () {
      final value = VarChar('-20', length: 3);
      final expected = BigInteger(-20);
      final operation = value.toBigInteger();
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should throw ArgumentError when casting positive floating-point values',
        () {
      final value = VarChar('3.14', length: 4);
      expect(() => value.toBigInteger(), throwsArgumentError);
    });

    test(
        'should throw ArgumentError when casting negative floating-point values',
        () {
      final value = VarChar('-3.14', length: 5);
      expect(() => value.toBigInteger(), throwsArgumentError);
    });

    test('should throw ArgumentError when casting non-numerical values', () {
      final value = VarChar('sample', length: 6);
      expect(() => value.toBigInteger(), throwsArgumentError);
    });
  });

  group('toInteger() method', () {
    test('should correctly cast positive values', () {
      final value = VarChar('20', length: 2);
      final expected = Integer(20);
      final operation = value.toInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly cast zero values', () {
      final value = VarChar('0', length: 1);
      final expected = Integer(0);
      final operation = value.toInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly cast negative values', () {
      final value = VarChar('-20', length: 3);
      final expected = Integer(-20);
      final operation = value.toInteger();
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should throw ArgumentError when casting positive floating-point values',
        () {
      final value = VarChar('3.14', length: 4);
      expect(() => value.toInteger(), throwsArgumentError);
    });

    test(
        'should throw ArgumentError when casting negative floating-point values',
        () {
      final value = VarChar('-3.14', length: 5);
      expect(() => value.toInteger(), throwsArgumentError);
    });

    test('should throw ArgumentError when casting non-numerical values', () {
      final value = VarChar('sample', length: 6);
      expect(() => value.toInteger(), throwsArgumentError);
    });
  });

  group('toSmallInteger() method', () {
    test('should correctly cast positive values', () {
      final value = VarChar('20', length: 2);
      final expected = SmallInteger(20);
      final operation = value.toSmallInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly cast zero values', () {
      final value = VarChar('0', length: 1);
      final expected = SmallInteger(0);
      final operation = value.toSmallInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly cast negative values', () {
      final value = VarChar('-20', length: 3);
      final expected = SmallInteger(-20);
      final operation = value.toSmallInteger();
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should throw ArgumentError when casting positive floating-point values',
        () {
      final value = VarChar('3.14', length: 4);
      expect(() => value.toSmallInteger(), throwsArgumentError);
    });

    test(
        'should throw ArgumentError when casting negative floating-point values',
        () {
      final value = VarChar('-3.14', length: 5);
      expect(() => value.toSmallInteger(), throwsArgumentError);
    });

    test('should throw ArgumentError when casting non-numerical values', () {
      final value = VarChar('sample', length: 6);
      expect(() => value.toSmallInteger(), throwsArgumentError);
    });
  });

  group('toBigSerial() method', () {
    test('should correctly cast positive values', () {
      final value = VarChar('20', length: 2);
      final expected = BigSerial(20);
      final operation = value.toBigSerial();
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should throw ArgumentError when casting positive floating-point values',
        () {
      final value = VarChar('3.14', length: 4);
      expect(() => value.toBigSerial(), throwsArgumentError);
    });

    test(
        'should throw ArgumentError when casting negative floating-point values',
        () {
      final value = VarChar('-3.14', length: 5);
      expect(() => value.toBigSerial(), throwsArgumentError);
    });

    test('should throw ArgumentError when casting non-numerical values', () {
      final value = VarChar('sample', length: 6);
      expect(() => value.toBigSerial(), throwsArgumentError);
    });
  });

  group('toSerial() method', () {
    test('should correctly cast positive values', () {
      final value = VarChar('20', length: 2);
      final expected = Serial(20);
      final operation = value.toSerial();
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should throw ArgumentError when casting positive floating-point values',
        () {
      final value = VarChar('3.14', length: 4);
      expect(() => value.toSerial(), throwsArgumentError);
    });

    test(
        'should throw ArgumentError when casting negative floating-point values',
        () {
      final value = VarChar('-3.14', length: 5);
      expect(() => value.toSerial(), throwsArgumentError);
    });

    test('should throw ArgumentError when casting non-numerical values', () {
      final value = VarChar('sample', length: 6);
      expect(() => value.toSerial(), throwsArgumentError);
    });
  });

  group('toSmallSerial() method', () {
    test('should correctly cast positive values', () {
      final value = VarChar('20', length: 2);
      final expected = SmallSerial(20);
      final operation = value.toSmallSerial();
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should throw ArgumentError when casting positive floating-point values',
        () {
      final value = VarChar('3.14', length: 4);
      expect(() => value.toSmallSerial(), throwsArgumentError);
    });

    test(
        'should throw ArgumentError when casting negative floating-point values',
        () {
      final value = VarChar('-3.14', length: 5);
      expect(() => value.toSmallSerial(), throwsArgumentError);
    });

    test('should throw ArgumentError when casting non-numerical values', () {
      final value = VarChar('sample', length: 6);
      expect(() => value.toSmallSerial(), throwsArgumentError);
    });
  });

  group('toReal() method', () {
    test('should correctly cast positive values', () {
      final value = VarChar('20.4', length: 4);
      final expected = Real(20.4);
      final operation = value.toReal();
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly cast zero values', () {
      final value = VarChar('0.0', length: 3);
      final expected = Real(0.0);
      final operation = value.toReal();
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly cast negative values', () {
      final value = VarChar('-20.4', length: 5);
      final expected = Real(-20.4);
      final operation = value.toReal();
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly cast positive int values', () {
      final value = VarChar('14', length: 2);
      final expected = Real(14.0);
      final operation = value.toReal();
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly cast negative int values', () {
      final value = VarChar('-14', length: 3);
      final expected = Real(-14.0);
      final operation = value.toReal();
      expect(operation.identicalTo(expected), true);
    });

    test('should throw ArgumentError when casting non-numerical values', () {
      final value = VarChar('sample', length: 6);
      expect(() => value.toReal(), throwsArgumentError);
    });
  });

  group('toDoublePrecision() method', () {
    test('should correctly cast positive values', () {
      final value = VarChar('20.4', length: 4);
      final expected = DoublePrecision(20.4);
      final operation = value.toDoublePrecision();
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly cast zero values', () {
      final value = VarChar('0.0', length: 3);
      final expected = DoublePrecision(0.0);
      final operation = value.toDoublePrecision();
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly cast negative values', () {
      final value = VarChar('-20.4', length: 5);
      final expected = DoublePrecision(-20.4);
      final operation = value.toDoublePrecision();
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly cast positive int values', () {
      final value = VarChar('14', length: 2);
      final expected = DoublePrecision(14.0);
      final operation = value.toDoublePrecision();
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly cast negative int values', () {
      final value = VarChar('-14', length: 3);
      final expected = DoublePrecision(-14.0);
      final operation = value.toDoublePrecision();
      expect(operation.identicalTo(expected), true);
    });

    test('should throw ArgumentError when casting non-numerical values', () {
      final value = VarChar('sample', length: 6);
      expect(() => value.toDoublePrecision(), throwsArgumentError);
    });
  });

  group('toNumeric() method', () {
    test('should correctly cast positive floating-point values', () {
      final value = VarChar('20.4', length: 4);
      final expected = Numeric(value: '20.4', precision: 3, scale: 1);
      final operation = value.toNumeric();
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly cast floating-point zero values', () {
      final value = VarChar('0.0', length: 3);
      final expected = Numeric(value: '0.0', precision: 2, scale: 1);
      final operation = value.toNumeric();
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly cast integer zero values', () {
      final value = VarChar('0', length: 1);
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value.toNumeric();
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly cast floating-point negative values', () {
      final value = VarChar('-20.4', length: 5);
      final expected = Numeric(value: '-20.4', precision: 3, scale: 1);
      final operation = value.toNumeric();
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly cast positive int values', () {
      final value = VarChar('14', length: 2);
      final expected = Numeric(value: '14', precision: 2, scale: 0);
      final operation = value.toNumeric();
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly cast negative int values', () {
      final value = VarChar('-14', length: 3);
      final expected = Numeric(value: '-14', precision: 2, scale: 0);
      final operation = value.toNumeric();
      expect(operation.identicalTo(expected), true);
    });

    test('should throw ArgumentError when casting non-numerical values', () {
      final value = VarChar('sample', length: 6);
      expect(() => value.toNumeric(), throwsArgumentError);
    });
  });

  group('toDecimal() method', () {
    test('should correctly cast positive floating-point values', () {
      final value = VarChar('20.4', length: 4);
      final expected = Decimal(value: '20.4', precision: 3, scale: 1);
      final operation = value.toDecimal();
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly cast floating-point zero values', () {
      final value = VarChar('0.0', length: 3);
      final expected = Decimal(value: '0.0', precision: 2, scale: 1);
      final operation = value.toDecimal();
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly cast integer zero values', () {
      final value = VarChar('0', length: 1);
      final expected = Decimal(value: '0', precision: 1, scale: 0);
      final operation = value.toDecimal();
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly cast floating-point negative values', () {
      final value = VarChar('-20.4', length: 5);
      final expected = Decimal(value: '-20.4', precision: 3, scale: 1);
      final operation = value.toDecimal();
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly cast positive int values', () {
      final value = VarChar('14', length: 2);
      final expected = Decimal(value: '14', precision: 2, scale: 0);
      final operation = value.toDecimal();
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly cast negative int values', () {
      final value = VarChar('-14', length: 3);
      final expected = Decimal(value: '-14', precision: 2, scale: 0);
      final operation = value.toDecimal();
      expect(operation.identicalTo(expected), true);
    });

    test('should throw ArgumentError when casting non-numerical values', () {
      final value = VarChar('sample', length: 6);
      expect(() => value.toDecimal(), throwsArgumentError);
    });
  });

  group('toChar() method', () {
    test('should correctly cast text values', () {
      final value = VarChar('sample string', length: 13);
      final expected = Char('sample string', length: 13);
      final operation = value.toChar();
      expect(operation.identicalTo(expected), true);
    });
  });

  group('toVarChar() method', () {
    test('should correctly cast text values', () {
      final value = VarChar('sample string', length: 13);
      final expected = VarChar('sample string', length: 13);
      final operation = value.toVarChar();
      expect(operation.identicalTo(expected), true);
    });
  });

  group('toText() method', () {
    test('should correctly cast text values', () {
      final value = VarChar('sample string', length: 13);
      final expected = Text('sample string');
      final operation = value.toText();
      expect(operation.identicalTo(expected), true);
    });
  });
}
