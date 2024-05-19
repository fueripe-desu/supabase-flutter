import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/character_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/floating_point_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
  group('string comparison (greater)', () {
    test('should return false when comparing to string primitive', () {
      final value1 = VarChar('apple', length: 5);
      const value2 = 'ant';
      final operation = value1 < value2;
      expect(operation, false);
    });

    test('should return false when comparing to Char', () {
      final value1 = VarChar('apple', length: 5);
      final value2 = Char('ant', length: 3);
      final operation = value1 < value2;
      expect(operation, false);
    });

    test('should return false when comparing to VarChar', () {
      final value1 = VarChar('apple', length: 5);
      final value2 = VarChar('ant', length: 3);
      final operation = value1 < value2;
      expect(operation, false);
    });

    test('should return false when comparing to Text', () {
      final value1 = VarChar('apple', length: 5);
      final value2 = Text('ant');
      final operation = value1 < value2;
      expect(operation, false);
    });

    test('should return false when comparing to BigInteger', () {
      final value1 = VarChar('20', length: 2);
      final value2 = BigInteger(10);
      final operation = value1 < value2;
      expect(operation, false);
    });

    test('should return false when comparing to Integer', () {
      final value1 = VarChar('20', length: 2);
      final value2 = Integer(10);
      final operation = value1 < value2;
      expect(operation, false);
    });

    test('should return false when comparing to SmallInteger', () {
      final value1 = VarChar('20', length: 2);
      final value2 = SmallInteger(10);
      final operation = value1 < value2;
      expect(operation, false);
    });

    test('should return false when comparing to BigSerial', () {
      final value1 = VarChar('20', length: 2);
      final value2 = BigSerial(10);
      final operation = value1 < value2;
      expect(operation, false);
    });

    test('should return false when comparing to Serial', () {
      final value1 = VarChar('20', length: 2);
      final value2 = Serial(10);
      final operation = value1 < value2;
      expect(operation, false);
    });

    test('should return false when comparing to SmallSerial', () {
      final value1 = VarChar('20', length: 2);
      final value2 = SmallSerial(10);
      final operation = value1 < value2;
      expect(operation, false);
    });

    test('should return false when comparing to int', () {
      final value1 = VarChar('20', length: 2);
      const value2 = 10;
      final operation = value1 < value2;
      expect(operation, false);
    });

    test('should return false when comparing to integer-valued double', () {
      final value1 = VarChar('20.0', length: 4);
      const value2 = 10.0;
      final operation = value1 < value2;
      expect(operation, false);
    });

    test('should return false when comparing to fractional double', () {
      final value1 = VarChar('20', length: 2);
      const value2 = 10.3;
      final operation = value1 < value2;
      expect(operation, false);
    });

    test('should return false when comparing to integer-valued Real', () {
      final value1 = VarChar('20.0', length: 4);
      final value2 = Real(10);
      final operation = value1 < value2;
      expect(operation, false);
    });

    test('should return false when comparing to fractional Real', () {
      final value1 = VarChar('20', length: 2);
      final value2 = Real(10.3);
      final operation = value1 < value2;
      expect(operation, false);
    });

    test('should return false when comparing to integer-valued DoublePrecision',
        () {
      final value1 = VarChar('20.0', length: 4);
      final value2 = DoublePrecision(10);
      final operation = value1 < value2;
      expect(operation, false);
    });

    test('should return false when comparing to fractional DoublePrecision',
        () {
      final value1 = VarChar('20', length: 2);
      final value2 = DoublePrecision(10.3);
      final operation = value1 < value2;
      expect(operation, false);
    });

    test('should return false when comparing to int Numeric', () {
      final value1 = VarChar('20', length: 2);
      final value2 = Numeric(value: '10', precision: 2, scale: 0);
      final operation = value1 < value2;
      expect(operation, false);
    });

    test('should return false when comparing to unconstrained int Numeric', () {
      final value1 = VarChar('20', length: 2);
      final value2 = Numeric(value: '10');
      final operation = value1 < value2;
      expect(operation, false);
    });

    test('should return false when comparing to float Numeric', () {
      final value1 = VarChar('20', length: 2);
      final value2 = Numeric(value: '10.3', precision: 3, scale: 1);
      final operation = value1 < value2;
      expect(operation, false);
    });

    test('should return false when comparing to unconstrained float Numeric',
        () {
      final value1 = VarChar('20', length: 2);
      final value2 = Numeric(value: '10.3');
      final operation = value1 < value2;
      expect(operation, false);
    });

    test('should return false when comparing to int Decimal', () {
      final value1 = VarChar('20', length: 2);
      final value2 = Decimal(value: '10', precision: 2, scale: 0);
      final operation = value1 < value2;
      expect(operation, false);
    });

    test('should return false when comparing to unconstrained int Decimal', () {
      final value1 = VarChar('20', length: 2);
      final value2 = Decimal(value: '10');
      final operation = value1 < value2;
      expect(operation, false);
    });

    test('should return false when comparing to float Decimal', () {
      final value1 = VarChar('20', length: 2);
      final value2 = Decimal(value: '10.3', precision: 3, scale: 1);
      final operation = value1 < value2;
      expect(operation, false);
    });

    test('should return false when comparing to unconstrained float Decimal',
        () {
      final value1 = VarChar('20', length: 2);
      final value2 = Decimal(value: '10.3');
      final operation = value1 < value2;
      expect(operation, false);
    });
  });

  group('string comparison (less)', () {
    test('should return true when comparing to string primitive', () {
      final value1 = VarChar('cat', length: 3);
      const value2 = 'dog';
      final operation = value1 < value2;
      expect(operation, true);
    });

    test('should return true when comparing to Char', () {
      final value1 = VarChar('cat', length: 3);
      final value2 = Char('dog', length: 3);
      final operation = value1 < value2;
      expect(operation, true);
    });

    test('should return true when comparing to VarChar', () {
      final value1 = VarChar('cat', length: 3);
      final value2 = VarChar('dog', length: 3);
      final operation = value1 < value2;
      expect(operation, true);
    });

    test('should return true when comparing to Text', () {
      final value1 = VarChar('cat', length: 3);
      final value2 = Text('dog');
      final operation = value1 < value2;
      expect(operation, true);
    });

    test('should return true when comparing to BigInteger', () {
      final value1 = VarChar('20', length: 2);
      final value2 = BigInteger(30);
      final operation = value1 < value2;
      expect(operation, true);
    });

    test('should return true when comparing to Integer', () {
      final value1 = VarChar('20', length: 2);
      final value2 = Integer(30);
      final operation = value1 < value2;
      expect(operation, true);
    });

    test('should return true when comparing to SmallInteger', () {
      final value1 = VarChar('20', length: 2);
      final value2 = SmallInteger(30);
      final operation = value1 < value2;
      expect(operation, true);
    });

    test('should return true when comparing to BigSerial', () {
      final value1 = VarChar('20', length: 2);
      final value2 = BigSerial(30);
      final operation = value1 < value2;
      expect(operation, true);
    });

    test('should return true when comparing to Serial', () {
      final value1 = VarChar('20', length: 2);
      final value2 = Serial(30);
      final operation = value1 < value2;
      expect(operation, true);
    });

    test('should return true when comparing to SmallSerial', () {
      final value1 = VarChar('20', length: 2);
      final value2 = SmallSerial(30);
      final operation = value1 < value2;
      expect(operation, true);
    });

    test('should return true when comparing to int', () {
      final value1 = VarChar('20', length: 2);
      const value2 = 30;
      final operation = value1 < value2;
      expect(operation, true);
    });

    test('should return true when comparing to integer-valued double', () {
      final value1 = VarChar('20.0', length: 4);
      const value2 = 30.0;
      final operation = value1 < value2;
      expect(operation, true);
    });

    test('should return true when comparing to fractional double', () {
      final value1 = VarChar('20', length: 2);
      const value2 = 30.0;
      final operation = value1 < value2;
      expect(operation, true);
    });

    test('should return true when comparing to integer-valued Real', () {
      final value1 = VarChar('20.0', length: 4);
      final value2 = Real(30);
      final operation = value1 < value2;
      expect(operation, true);
    });

    test('should return true when comparing to fractional Real', () {
      final value1 = VarChar('20', length: 2);
      final value2 = Real(30.3);
      final operation = value1 < value2;
      expect(operation, true);
    });

    test('should return true when comparing to integer-valued DoublePrecision',
        () {
      final value1 = VarChar('20.0', length: 4);
      final value2 = DoublePrecision(30);
      final operation = value1 < value2;
      expect(operation, true);
    });

    test('should return true when comparing to fractional DoublePrecision', () {
      final value1 = VarChar('20', length: 2);
      final value2 = DoublePrecision(30.3);
      final operation = value1 < value2;
      expect(operation, true);
    });

    test('should return true when comparing to int Numeric', () {
      final value1 = VarChar('20', length: 2);
      final value2 = Numeric(value: '30', precision: 2, scale: 0);
      final operation = value1 < value2;
      expect(operation, true);
    });

    test('should return true when comparing to unconstrained int Numeric', () {
      final value1 = VarChar('20', length: 2);
      final value2 = Numeric(value: '30');
      final operation = value1 < value2;
      expect(operation, true);
    });

    test('should return true when comparing to float Numeric', () {
      final value1 = VarChar('20', length: 2);
      final value2 = Numeric(value: '30.3', precision: 3, scale: 1);
      final operation = value1 < value2;
      expect(operation, true);
    });

    test('should return true when comparing to unconstrained float Numeric',
        () {
      final value1 = VarChar('20', length: 2);
      final value2 = Numeric(value: '30.3');
      final operation = value1 < value2;
      expect(operation, true);
    });

    test('should return true when comparing to int Decimal', () {
      final value1 = VarChar('20', length: 2);
      final value2 = Decimal(value: '30', precision: 2, scale: 0);
      final operation = value1 < value2;
      expect(operation, true);
    });

    test('should return true when comparing to unconstrained int Decimal', () {
      final value1 = VarChar('20', length: 2);
      final value2 = Decimal(value: '30');
      final operation = value1 < value2;
      expect(operation, true);
    });

    test('should return true when comparing to float Decimal', () {
      final value1 = VarChar('20', length: 2);
      final value2 = Decimal(value: '30.3', precision: 3, scale: 1);
      final operation = value1 < value2;
      expect(operation, true);
    });

    test('should return true when comparing to unconstrained float Decimal',
        () {
      final value1 = VarChar('20', length: 2);
      final value2 = Decimal(value: '30.3');
      final operation = value1 < value2;
      expect(operation, true);
    });
  });

  group('string comparison (equal)', () {
    test('should return false when comparing to string primitive', () {
      final value1 = VarChar('hello', length: 5);
      const value2 = 'hello';
      final operation = value1 < value2;
      expect(operation, false);
    });

    test('should return false when comparing to Char', () {
      final value1 = VarChar('hello', length: 5);
      final value2 = Char('hello', length: 5);
      final operation = value1 < value2;
      expect(operation, false);
    });

    test('should return false when comparing to VarChar', () {
      final value1 = VarChar('hello', length: 5);
      final value2 = VarChar('hello', length: 5);
      final operation = value1 < value2;
      expect(operation, false);
    });

    test('should return false when comparing to Text', () {
      final value1 = VarChar('hello', length: 5);
      final value2 = Text('hello');
      final operation = value1 < value2;
      expect(operation, false);
    });

    test('should return false when comparing to BigInteger', () {
      final value1 = VarChar('20', length: 2);
      final value2 = BigInteger(20);
      final operation = value1 < value2;
      expect(operation, false);
    });

    test('should return false when comparing to Integer', () {
      final value1 = VarChar('20', length: 2);
      final value2 = Integer(20);
      final operation = value1 < value2;
      expect(operation, false);
    });

    test('should return false when comparing to SmallInteger', () {
      final value1 = VarChar('20', length: 2);
      final value2 = SmallInteger(20);
      final operation = value1 < value2;
      expect(operation, false);
    });

    test('should return false when comparing to BigSerial', () {
      final value1 = VarChar('20', length: 2);
      final value2 = BigSerial(20);
      final operation = value1 < value2;
      expect(operation, false);
    });

    test('should return false when comparing to Serial', () {
      final value1 = VarChar('20', length: 2);
      final value2 = Serial(20);
      final operation = value1 < value2;
      expect(operation, false);
    });

    test('should return false when comparing to SmallSerial', () {
      final value1 = VarChar('20', length: 2);
      final value2 = SmallSerial(20);
      final operation = value1 < value2;
      expect(operation, false);
    });

    test('should return false when comparing to int', () {
      final value1 = VarChar('20', length: 2);
      const value2 = 20;
      final operation = value1 < value2;
      expect(operation, false);
    });

    test('should return false when comparing to integer-valued double', () {
      final value1 = VarChar('20.0', length: 4);
      const value2 = 20.0;
      final operation = value1 < value2;
      expect(operation, false);
    });

    test('should return false when comparing to integer-valued Real', () {
      final value1 = VarChar('20.0', length: 4);
      final value2 = Real(20);
      final operation = value1 < value2;
      expect(operation, false);
    });

    test('should return false when comparing to integer-valued DoublePrecision',
        () {
      final value1 = VarChar('20.0', length: 4);
      final value2 = DoublePrecision(20);
      final operation = value1 < value2;
      expect(operation, false);
    });

    test('should return false when comparing to int Numeric', () {
      final value1 = VarChar('20', length: 2);
      final value2 = Numeric(value: '20', precision: 2, scale: 0);
      final operation = value1 < value2;
      expect(operation, false);
    });

    test('should return false when comparing to unconstrained int Numeric', () {
      final value1 = VarChar('20', length: 2);
      final value2 = Numeric(value: '20');
      final operation = value1 < value2;
      expect(operation, false);
    });

    test('should return false when comparing to int Decimal', () {
      final value1 = VarChar('20', length: 2);
      final value2 = Decimal(value: '20', precision: 2, scale: 0);
      final operation = value1 < value2;
      expect(operation, false);
    });

    test('should return false when comparing to unconstrained int Decimal', () {
      final value1 = VarChar('20', length: 2);
      final value2 = Decimal(value: '20');
      final operation = value1 < value2;
      expect(operation, false);
    });
  });
}
