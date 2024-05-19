import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/character_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/floating_point_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/primitive_data_types_extension.dart';

void main() {
  group('positive values', () {
    test('should cast to int primitive', () {
      const value = '22';
      const expected = 22;
      final operation = value.toPrimitiveInt();
      expect(operation, expected);
      expect(operation, isA<int>());
    });

    test('should cast to double primitive', () {
      const value = '22';
      const expected = 22.0;
      final operation = value.toPrimitiveDouble();
      expect(operation, expected);
      expect(operation, isA<double>());
    });

    test('should cast to SmallInteger', () {
      const value = '22';
      final expected = SmallInteger(22);
      final operation = value.toSmallInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast to Integer', () {
      const value = '22';
      final expected = Integer(22);
      final operation = value.toInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast to BigInteger', () {
      const value = '22';
      final expected = BigInteger(22);
      final operation = value.toBigInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast to SmallSerial', () {
      const value = '22';
      final expected = SmallSerial(22);
      final operation = value.toSmallSerial();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast to Serial', () {
      const value = '22';
      final expected = Serial(22);
      final operation = value.toSerial();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast to BigSerial', () {
      const value = '22';
      final expected = BigSerial(22);
      final operation = value.toBigSerial();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast to Real', () {
      const value = '22';
      final expected = Real(22);
      final operation = value.toReal();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast to DoublePrecision', () {
      const value = '22';
      final expected = DoublePrecision(22);
      final operation = value.toDoublePrecision();
      expect(operation.identicalTo(expected), true);
    });

    test('should be able to cast to Numeric', () {
      const value = '22';
      final expected = Numeric(value: '22', precision: 2, scale: 0);
      final operation = value.toNumeric();
      expect(operation.identicalTo(expected), true);
    });

    test('should be able to cast to Decimal', () {
      const value = '22';
      final expected = Decimal(value: '22', precision: 2, scale: 0);
      final operation = value.toDecimal();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast to Char', () {
      const value = '22';
      final expected = Char('22', length: 2);
      final operation = value.toChar();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast to VarChar', () {
      const value = '22';
      final expected = VarChar('22', length: 2);
      final operation = value.toVarChar();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast to Text', () {
      const value = '22';
      final expected = Text('22');
      final operation = value.toText();
      expect(operation.identicalTo(expected), true);
    });
  });

  group('zero values', () {
    test('should cast to int primitive', () {
      const value = '0';
      const expected = 0;
      final operation = value.toPrimitiveInt();
      expect(operation, expected);
      expect(operation, isA<int>());
    });

    test('should cast to double primitive', () {
      const value = '0';
      const expected = 0.0;
      final operation = value.toPrimitiveDouble();
      expect(operation, expected);
      expect(operation, isA<double>());
    });

    test('should cast to SmallInteger', () {
      const value = '0';
      final expected = SmallInteger(0);
      final operation = value.toSmallInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast to Integer', () {
      const value = '0';
      final expected = Integer(0);
      final operation = value.toInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast to BigInteger', () {
      const value = '0';
      final expected = BigInteger(0);
      final operation = value.toBigInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast to Real', () {
      const value = '0';
      final expected = Real(0);
      final operation = value.toReal();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast to DoublePrecision', () {
      const value = '0';
      final expected = DoublePrecision(0);
      final operation = value.toDoublePrecision();
      expect(operation.identicalTo(expected), true);
    });

    test('should be able to cast to Numeric', () {
      const value = '0';
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value.toNumeric();
      expect(operation.identicalTo(expected), true);
    });

    test('should be able to cast to Decimal', () {
      const value = '0';
      final expected = Decimal(value: '0', precision: 1, scale: 0);
      final operation = value.toDecimal();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast to Char', () {
      const value = '0';
      final expected = Char('0', length: 1);
      final operation = value.toChar();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast to VarChar', () {
      const value = '0';
      final expected = VarChar('0', length: 1);
      final operation = value.toVarChar();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast to Text', () {
      const value = '0';
      final expected = Text('0');
      final operation = value.toText();
      expect(operation.identicalTo(expected), true);
    });
  });

  group('negative values', () {
    test('should cast to int primitive', () {
      const value = '-22';
      const expected = -22;
      final operation = value.toPrimitiveInt();
      expect(operation, expected);
      expect(operation, isA<int>());
    });

    test('should cast to double primitive', () {
      const value = '-22';
      const expected = -22.0;
      final operation = value.toPrimitiveDouble();
      expect(operation, expected);
      expect(operation, isA<double>());
    });

    test('should cast to SmallInteger', () {
      const value = '-22';
      final expected = SmallInteger(-22);
      final operation = value.toSmallInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast to Integer', () {
      const value = '-22';
      final expected = Integer(-22);
      final operation = value.toInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast to BigInteger', () {
      const value = '-22';
      final expected = BigInteger(-22);
      final operation = value.toBigInteger();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast to Real', () {
      const value = '-22';
      final expected = Real(-22);
      final operation = value.toReal();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast to DoublePrecision', () {
      const value = '-22';
      final expected = DoublePrecision(-22);
      final operation = value.toDoublePrecision();
      expect(operation.identicalTo(expected), true);
    });

    test('should be able to cast to Numeric', () {
      const value = '-22';
      final expected = Numeric(value: '-22', precision: 2, scale: 0);
      final operation = value.toNumeric();
      expect(operation.identicalTo(expected), true);
    });

    test('should be able to cast to Decimal', () {
      const value = '-22';
      final expected = Decimal(value: '-22', precision: 2, scale: 0);
      final operation = value.toDecimal();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast to Char', () {
      const value = '-22';
      final expected = Char('-22', length: 3);
      final operation = value.toChar();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast to VarChar', () {
      const value = '-22';
      final expected = VarChar('-22', length: 3);
      final operation = value.toVarChar();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast to Text', () {
      const value = '-22';
      final expected = Text('-22');
      final operation = value.toText();
      expect(operation.identicalTo(expected), true);
    });
  });

  group('non-numerical values', () {
    test('should cast to int primitive', () {
      const value = 'sample';
      expect(() => value.toPrimitiveInt(), throwsArgumentError);
    });

    test('should cast to double primitive', () {
      const value = 'sample';
      expect(() => value.toPrimitiveDouble(), throwsArgumentError);
    });

    test('should cast to SmallInteger', () {
      const value = 'sample';
      expect(() => value.toSmallInteger(), throwsArgumentError);
    });

    test('should cast to Integer', () {
      const value = 'sample';
      expect(() => value.toInteger(), throwsArgumentError);
    });

    test('should cast to BigInteger', () {
      const value = 'sample';
      expect(() => value.toBigInteger(), throwsArgumentError);
    });

    test('should cast to SmallSerial', () {
      const value = 'sample';
      expect(() => value.toSmallSerial(), throwsArgumentError);
    });

    test('should cast to Serial', () {
      const value = 'sample';
      expect(() => value.toSerial(), throwsArgumentError);
    });

    test('should cast to BigSerial', () {
      const value = 'sample';
      expect(() => value.toBigSerial(), throwsArgumentError);
    });

    test('should cast to Real', () {
      const value = 'sample';
      expect(() => value.toReal(), throwsArgumentError);
    });

    test('should cast to DoublePrecision', () {
      const value = 'sample';
      expect(() => value.toDoublePrecision(), throwsArgumentError);
    });

    test('should be able to cast to Numeric', () {
      const value = 'sample';
      expect(() => value.toNumeric(), throwsArgumentError);
    });

    test('should be able to cast to Decimal', () {
      const value = 'sample';
      expect(() => value.toDecimal(), throwsArgumentError);
    });

    test('should cast to Char', () {
      const value = 'sample';
      final expected = Char('sample', length: 6);
      final operation = value.toChar();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast to VarChar', () {
      const value = 'sample';
      final expected = VarChar('sample', length: 6);
      final operation = value.toVarChar();
      expect(operation.identicalTo(expected), true);
    });

    test('should cast to Text', () {
      const value = 'sample';
      final expected = Text('sample');
      final operation = value.toText();
      expect(operation.identicalTo(expected), true);
    });
  });
}
