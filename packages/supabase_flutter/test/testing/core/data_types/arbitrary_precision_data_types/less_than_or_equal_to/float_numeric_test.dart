import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/floating_point_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
  group('positive comparison (greater)', () {
    test('should return false when comparing to BigInteger', () {
      final value1 = Numeric(value: '20.3', precision: 3, scale: 1);
      final value2 = BigInteger(20);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to Integer', () {
      final value1 = Numeric(value: '20.3', precision: 3, scale: 1);
      final value2 = Integer(20);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to SmallInteger', () {
      final value1 = Numeric(value: '20.3', precision: 3, scale: 1);
      final value2 = SmallInteger(20);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to BigSerial', () {
      final value1 = Numeric(value: '20.3', precision: 3, scale: 1);
      final value2 = BigSerial(20);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to Serial', () {
      final value1 = Numeric(value: '20.3', precision: 3, scale: 1);
      final value2 = Serial(20);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to SmallSerial', () {
      final value1 = Numeric(value: '20.3', precision: 3, scale: 1);
      final value2 = SmallSerial(20);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to int', () {
      final value1 = Numeric(value: '20.3', precision: 3, scale: 1);
      const value2 = 20;
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to integer-valued double', () {
      final value1 = Numeric(value: '20.3', precision: 3, scale: 1);
      const value2 = 20.0;
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to fractional double', () {
      final value1 = Numeric(value: '20.5', precision: 3, scale: 1);
      const value2 = 20.3;
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to integer-valued Real', () {
      final value1 = Numeric(value: '20.3', precision: 3, scale: 1);
      final value2 = Real(20);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to fractional Real', () {
      final value1 = Numeric(value: '20.5', precision: 3, scale: 1);
      final value2 = Real(20.3);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to integer-valued DoublePrecision',
        () {
      final value1 = Numeric(value: '20.3', precision: 3, scale: 1);
      final value2 = DoublePrecision(20);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to fractional DoublePrecision',
        () {
      final value1 = Numeric(value: '20.5', precision: 3, scale: 1);
      final value2 = DoublePrecision(20.3);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to int Numeric', () {
      final value1 = Numeric(value: '20.3', precision: 3, scale: 1);
      final value2 = Numeric(value: '20', precision: 2, scale: 0);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to unconstrained int Numeric', () {
      final value1 = Numeric(value: '20.3', precision: 3, scale: 1);
      final value2 = Numeric(value: '20');
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to float Numeric', () {
      final value1 = Numeric(value: '20.5', precision: 3, scale: 1);
      final value2 = Numeric(value: '20.3', precision: 3, scale: 1);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to unconstrained float Numeric',
        () {
      final value1 = Numeric(value: '20.5', precision: 3, scale: 1);
      final value2 = Numeric(value: '20.3');
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to fractional Numeric', () {
      final value1 = Numeric(value: '0.58', precision: 3, scale: 2);
      final value2 = Numeric(value: '0.35', precision: 2, scale: 2);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to int Decimal', () {
      final value1 = Numeric(value: '20.3', precision: 3, scale: 1);
      final value2 = Decimal(value: '20', precision: 2, scale: 0);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to unconstrained int Decimal', () {
      final value1 = Numeric(value: '20.3', precision: 3, scale: 1);
      final value2 = Decimal(value: '20');
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to float Decimal', () {
      final value1 = Numeric(value: '20.5', precision: 3, scale: 1);
      final value2 = Decimal(value: '20.3', precision: 3, scale: 1);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to unconstrained float Decimal',
        () {
      final value1 = Numeric(value: '20.5', precision: 3, scale: 1);
      final value2 = Decimal(value: '20.3');
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to fractional Decimal', () {
      final value1 = Numeric(value: '0.58', precision: 3, scale: 2);
      final value2 = Decimal(value: '0.35', precision: 2, scale: 2);
      final operation = value1 <= value2;
      expect(operation, false);
    });
  });

  group('positive comparison (less)', () {
    test('should return true when comparing to BigInteger', () {
      final value1 = Numeric(value: '19.9', precision: 3, scale: 1);
      final value2 = BigInteger(20);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to Integer', () {
      final value1 = Numeric(value: '19.9', precision: 3, scale: 1);
      final value2 = Integer(20);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to SmallInteger', () {
      final value1 = Numeric(value: '19.9', precision: 3, scale: 1);
      final value2 = SmallInteger(20);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to BigSerial', () {
      final value1 = Numeric(value: '19.9', precision: 3, scale: 1);
      final value2 = BigSerial(20);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to Serial', () {
      final value1 = Numeric(value: '19.9', precision: 3, scale: 1);
      final value2 = Serial(20);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to SmallSerial', () {
      final value1 = Numeric(value: '19.9', precision: 3, scale: 1);
      final value2 = SmallSerial(20);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to int', () {
      final value1 = Numeric(value: '19.9', precision: 3, scale: 1);
      const value2 = 20;
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to integer-valued double', () {
      final value1 = Numeric(value: '19.9', precision: 3, scale: 1);
      const value2 = 20.0;
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to fractional double', () {
      final value1 = Numeric(value: '20.5', precision: 3, scale: 1);
      const value2 = 20.6;
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to integer-valued Real', () {
      final value1 = Numeric(value: '19.9', precision: 3, scale: 1);
      final value2 = Real(20.0);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to fractional Real', () {
      final value1 = Numeric(value: '20.5', precision: 3, scale: 1);
      final value2 = Real(20.6);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to integer-valued DoublePrecision',
        () {
      final value1 = Numeric(value: '19.9', precision: 3, scale: 1);
      final value2 = DoublePrecision(20.0);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to fractional DoublePrecision', () {
      final value1 = Numeric(value: '20.5', precision: 3, scale: 1);
      final value2 = DoublePrecision(20.6);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to int Numeric', () {
      final value1 = Numeric(value: '19.9', precision: 3, scale: 1);
      final value2 = Numeric(value: '20', precision: 2, scale: 0);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to unconstrained int Numeric', () {
      final value1 = Numeric(value: '19.9', precision: 3, scale: 1);
      final value2 = Numeric(value: '20');
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to float Numeric', () {
      final value1 = Numeric(value: '20.5', precision: 3, scale: 1);
      final value2 = Numeric(value: '20.6', precision: 3, scale: 1);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to unconstrained float Numeric',
        () {
      final value1 = Numeric(value: '20.5', precision: 3, scale: 1);
      final value2 = Numeric(value: '20.6');
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to fractional Numeric', () {
      final value1 = Numeric(value: '0.19', precision: 3, scale: 2);
      final value2 = Numeric(value: '0.35', precision: 2, scale: 2);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to int Decimal', () {
      final value1 = Numeric(value: '19.9', precision: 3, scale: 1);
      final value2 = Decimal(value: '20', precision: 2, scale: 0);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to unconstrained int Decimal', () {
      final value1 = Numeric(value: '19.9', precision: 3, scale: 1);
      final value2 = Decimal(value: '20');
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to float Decimal', () {
      final value1 = Numeric(value: '20.5', precision: 3, scale: 1);
      final value2 = Decimal(value: '20.6', precision: 3, scale: 1);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to unconstrained float Decimal',
        () {
      final value1 = Numeric(value: '20.5', precision: 3, scale: 1);
      final value2 = Decimal(value: '20.6');
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to fractional Decimal', () {
      final value1 = Numeric(value: '0.19', precision: 3, scale: 2);
      final value2 = Decimal(value: '0.35', precision: 2, scale: 2);
      final operation = value1 <= value2;
      expect(operation, true);
    });
  });

  group('positive comparison (equal)', () {
    test('should return true when comparing to fractional double', () {
      final value1 = Numeric(value: '20.5', precision: 3, scale: 1);
      const value2 = 20.5;
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to fractional Real', () {
      final value1 = Numeric(value: '20.5', precision: 3, scale: 1);
      final value2 = Real(20.5);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to fractional DoublePrecision', () {
      final value1 = Numeric(value: '20.5', precision: 3, scale: 1);
      final value2 = DoublePrecision(20.5);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to float Numeric', () {
      final value1 = Numeric(value: '20.5', precision: 3, scale: 1);
      final value2 = Numeric(value: '20.5', precision: 3, scale: 1);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to unconstrained float Numeric',
        () {
      final value1 = Numeric(value: '20.5', precision: 3, scale: 1);
      final value2 = Numeric(value: '20.5');
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to fractional Numeric', () {
      final value1 = Numeric(value: '0.35', precision: 3, scale: 2);
      final value2 = Numeric(value: '0.35', precision: 2, scale: 2);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to float Decimal', () {
      final value1 = Numeric(value: '20.5', precision: 3, scale: 1);
      final value2 = Decimal(value: '20.5', precision: 3, scale: 1);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to unconstrained float Decimal',
        () {
      final value1 = Numeric(value: '20.5', precision: 3, scale: 1);
      final value2 = Decimal(value: '20.5');
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to fractional Decimal', () {
      final value1 = Numeric(value: '0.35', precision: 3, scale: 2);
      final value2 = Decimal(value: '0.35', precision: 2, scale: 2);
      final operation = value1 <= value2;
      expect(operation, true);
    });
  });

  group('negative comparison (greater)', () {
    test('should return false when comparing to BigInteger', () {
      final value1 = Numeric(value: '-19.6', precision: 3, scale: 1);
      final value2 = BigInteger(-20);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to Integer', () {
      final value1 = Numeric(value: '-19.6', precision: 3, scale: 1);
      final value2 = Integer(-20);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to SmallInteger', () {
      final value1 = Numeric(value: '-19.6', precision: 3, scale: 1);
      final value2 = SmallInteger(-20);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to int', () {
      final value1 = Numeric(value: '-19.6', precision: 3, scale: 1);
      const value2 = -20;
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to integer-valued double', () {
      final value1 = Numeric(value: '-19.6', precision: 3, scale: 1);
      const value2 = -20.0;
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to fractional double', () {
      final value1 = Numeric(value: '-20.1', precision: 3, scale: 1);
      const value2 = -20.3;
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to integer-valued Real', () {
      final value1 = Numeric(value: '-19.6', precision: 3, scale: 1);
      final value2 = Real(-20);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to fractional Real', () {
      final value1 = Numeric(value: '-20.1', precision: 3, scale: 1);
      final value2 = Real(-20.3);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to integer-valued DoublePrecision',
        () {
      final value1 = Numeric(value: '-19.6', precision: 3, scale: 1);
      final value2 = DoublePrecision(-20);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to fractional DoublePrecision',
        () {
      final value1 = Numeric(value: '-20.1', precision: 3, scale: 1);
      final value2 = DoublePrecision(-20.3);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to int Numeric', () {
      final value1 = Numeric(value: '-19.6', precision: 3, scale: 1);
      final value2 = Numeric(value: '-20', precision: 2, scale: 0);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to unconstrained int Numeric', () {
      final value1 = Numeric(value: '-19.6', precision: 3, scale: 1);
      final value2 = Numeric(value: '-20');
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to float Numeric', () {
      final value1 = Numeric(value: '-20.1', precision: 3, scale: 1);
      final value2 = Numeric(value: '-20.3', precision: 3, scale: 1);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to unconstrained float Numeric',
        () {
      final value1 = Numeric(value: '-20.1', precision: 3, scale: 1);
      final value2 = Numeric(value: '-20.3');
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to fractional Numeric', () {
      final value1 = Numeric(value: '-0.12', precision: 3, scale: 2);
      final value2 = Numeric(value: '-0.35', precision: 2, scale: 2);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to int Decimal', () {
      final value1 = Numeric(value: '-19.6', precision: 3, scale: 1);
      final value2 = Decimal(value: '-20', precision: 2, scale: 0);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to unconstrained int Decimal', () {
      final value1 = Numeric(value: '-19.6', precision: 3, scale: 1);
      final value2 = Decimal(value: '-20');
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to float Decimal', () {
      final value1 = Numeric(value: '-20.1', precision: 3, scale: 1);
      final value2 = Decimal(value: '-20.3', precision: 3, scale: 1);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to unconstrained float Decimal',
        () {
      final value1 = Numeric(value: '-20.1', precision: 3, scale: 1);
      final value2 = Decimal(value: '-20.3');
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to fractional Decimal', () {
      final value1 = Numeric(value: '-0.12', precision: 3, scale: 1);
      final value2 = Decimal(value: '-0.35', precision: 2, scale: 2);
      final operation = value1 <= value2;
      expect(operation, false);
    });
  });

  group('negative comparison (less)', () {
    test('should return true when comparing to BigInteger', () {
      final value1 = Numeric(value: '-20.3', precision: 3, scale: 1);
      final value2 = BigInteger(-20);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to Integer', () {
      final value1 = Numeric(value: '-20.3', precision: 3, scale: 1);
      final value2 = Integer(-20);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to SmallInteger', () {
      final value1 = Numeric(value: '-20.3', precision: 3, scale: 1);
      final value2 = SmallInteger(-20);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to int', () {
      final value1 = Numeric(value: '-20.3', precision: 3, scale: 1);
      const value2 = -20;
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to integer-valued double', () {
      final value1 = Numeric(value: '-20.3', precision: 3, scale: 1);
      const value2 = -20.0;
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to fractional double', () {
      final value1 = Numeric(value: '-20.5', precision: 3, scale: 1);
      const value2 = -20.3;
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to integer-valued Real', () {
      final value1 = Numeric(value: '-20.3', precision: 3, scale: 1);
      final value2 = Real(-20);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to fractional Real', () {
      final value1 = Numeric(value: '-20.5', precision: 3, scale: 1);
      final value2 = Real(-20.3);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to integer-valued DoublePrecision',
        () {
      final value1 = Numeric(value: '-20.3', precision: 3, scale: 1);
      final value2 = DoublePrecision(-20);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to fractional DoublePrecision', () {
      final value1 = Numeric(value: '-20.5', precision: 3, scale: 1);
      final value2 = DoublePrecision(-20.3);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to int Numeric', () {
      final value1 = Numeric(value: '-20.3', precision: 3, scale: 1);
      final value2 = Numeric(value: '-20', precision: 2, scale: 0);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to unconstrained int Numeric', () {
      final value1 = Numeric(value: '-20.3', precision: 3, scale: 1);
      final value2 = Numeric(value: '-20');
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to float Numeric', () {
      final value1 = Numeric(value: '-20.5', precision: 3, scale: 1);
      final value2 = Numeric(value: '-20.3', precision: 3, scale: 1);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to unconstrained float Numeric',
        () {
      final value1 = Numeric(value: '-20.5', precision: 3, scale: 1);
      final value2 = Numeric(value: '-20.3');
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to fractional Numeric', () {
      final value1 = Numeric(value: '-0.58', precision: 3, scale: 2);
      final value2 = Numeric(value: '-0.35', precision: 2, scale: 2);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to int Decimal', () {
      final value1 = Numeric(value: '-20.3', precision: 3, scale: 1);
      final value2 = Decimal(value: '-20', precision: 2, scale: 0);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to unconstrained int Decimal', () {
      final value1 = Numeric(value: '-20.3', precision: 3, scale: 1);
      final value2 = Decimal(value: '-20');
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to float Decimal', () {
      final value1 = Numeric(value: '-20.5', precision: 3, scale: 1);
      final value2 = Decimal(value: '-20.3', precision: 3, scale: 1);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to unconstrained float Decimal',
        () {
      final value1 = Numeric(value: '-20.5', precision: 3, scale: 1);
      final value2 = Decimal(value: '-20.3');
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to fractional Decimal', () {
      final value1 = Numeric(value: '-0.58', precision: 3, scale: 2);
      final value2 = Decimal(value: '-0.35', precision: 2, scale: 2);
      final operation = value1 <= value2;
      expect(operation, true);
    });
  });

  group('negative comparison (equal)', () {
    test('should return true when comparing to fractional double', () {
      final value1 = Numeric(value: '-20.5', precision: 3, scale: 1);
      const value2 = -20.5;
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to fractional Real', () {
      final value1 = Numeric(value: '-20.5', precision: 3, scale: 1);
      final value2 = Real(-20.5);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to fractional DoublePrecision', () {
      final value1 = Numeric(value: '-20.5', precision: 3, scale: 1);
      final value2 = DoublePrecision(-20.5);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to float Numeric', () {
      final value1 = Numeric(value: '-20.5', precision: 3, scale: 1);
      final value2 = Numeric(value: '-20.5', precision: 3, scale: 1);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to unconstrained float Numeric',
        () {
      final value1 = Numeric(value: '-20.5', precision: 3, scale: 1);
      final value2 = Numeric(value: '-20.5');
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to fractional Numeric', () {
      final value1 = Numeric(value: '-0.35', precision: 3, scale: 2);
      final value2 = Numeric(value: '-0.35', precision: 2, scale: 2);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to float Decimal', () {
      final value1 = Numeric(value: '-20.5', precision: 3, scale: 1);
      final value2 = Decimal(value: '-20.5', precision: 3, scale: 1);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to unconstrained float Decimal',
        () {
      final value1 = Numeric(value: '-20.5', precision: 3, scale: 1);
      final value2 = Decimal(value: '-20.5');
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to fractional Decimal', () {
      final value1 = Numeric(value: '-0.35', precision: 3, scale: 2);
      final value2 = Decimal(value: '-0.35', precision: 2, scale: 2);
      final operation = value1 <= value2;
      expect(operation, true);
    });
  });

  group('mixed sign comparison (positive + negative)', () {
    test('should return false when comparing to BigInteger', () {
      final value1 = Numeric(value: '20.3', precision: 3, scale: 1);
      final value2 = BigInteger(-20);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to Integer', () {
      final value1 = Numeric(value: '20.3', precision: 3, scale: 1);
      final value2 = Integer(-20);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to SmallInteger', () {
      final value1 = Numeric(value: '20.3', precision: 3, scale: 1);
      final value2 = SmallInteger(-20);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to int', () {
      final value1 = Numeric(value: '20.3', precision: 3, scale: 1);
      const value2 = -20;
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to integer-valued double', () {
      final value1 = Numeric(value: '20.3', precision: 3, scale: 1);
      const value2 = -20.0;
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to fractional double', () {
      final value1 = Numeric(value: '20.5', precision: 3, scale: 1);
      const value2 = -20.3;
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to integer-valued Real', () {
      final value1 = Numeric(value: '20.3', precision: 3, scale: 1);
      final value2 = Real(-20);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to fractional Real', () {
      final value1 = Numeric(value: '20.5', precision: 3, scale: 1);
      final value2 = Real(-20.3);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to integer-valued DoublePrecision',
        () {
      final value1 = Numeric(value: '20.3', precision: 3, scale: 1);
      final value2 = DoublePrecision(-20);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to fractional DoublePrecision',
        () {
      final value1 = Numeric(value: '20.5', precision: 3, scale: 1);
      final value2 = DoublePrecision(-20.3);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to int Numeric', () {
      final value1 = Numeric(value: '20.3', precision: 3, scale: 1);
      final value2 = Numeric(value: '-20', precision: 2, scale: 0);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to unconstrained int Numeric', () {
      final value1 = Numeric(value: '20.3', precision: 3, scale: 1);
      final value2 = Numeric(value: '-20');
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to float Numeric', () {
      final value1 = Numeric(value: '20.5', precision: 3, scale: 1);
      final value2 = Numeric(value: '-20.3', precision: 3, scale: 1);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to unconstrained float Numeric',
        () {
      final value1 = Numeric(value: '20.5', precision: 3, scale: 1);
      final value2 = Numeric(value: '-20.3');
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to fractional Numeric', () {
      final value1 = Numeric(value: '0.58', precision: 3, scale: 2);
      final value2 = Numeric(value: '-0.35', precision: 2, scale: 2);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to int Decimal', () {
      final value1 = Numeric(value: '20.3', precision: 3, scale: 1);
      final value2 = Decimal(value: '-20', precision: 2, scale: 0);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to unconstrained int Decimal', () {
      final value1 = Numeric(value: '20.3', precision: 3, scale: 1);
      final value2 = Decimal(value: '-20');
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to float Decimal', () {
      final value1 = Numeric(value: '20.5', precision: 3, scale: 1);
      final value2 = Decimal(value: '-20.3', precision: 3, scale: 1);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to unconstrained float Decimal',
        () {
      final value1 = Numeric(value: '20.5', precision: 3, scale: 1);
      final value2 = Decimal(value: '-20.3');
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to fractional Decimal', () {
      final value1 = Numeric(value: '0.58', precision: 3, scale: 1);
      final value2 = Decimal(value: '-0.35', precision: 2, scale: 2);
      final operation = value1 <= value2;
      expect(operation, false);
    });
  });

  group('mixed sign comparison (negative + positive)', () {
    test('should return true when comparing to BigInteger', () {
      final value1 = Numeric(value: '-20.3', precision: 3, scale: 1);
      final value2 = BigInteger(20);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to Integer', () {
      final value1 = Numeric(value: '-20.3', precision: 3, scale: 1);
      final value2 = Integer(20);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to SmallInteger', () {
      final value1 = Numeric(value: '-20.3', precision: 3, scale: 1);
      final value2 = SmallInteger(20);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to BigSerial', () {
      final value1 = Numeric(value: '-20.3', precision: 3, scale: 1);
      final value2 = BigSerial(20);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to Serial', () {
      final value1 = Numeric(value: '-20.3', precision: 3, scale: 1);
      final value2 = Serial(20);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to SmallSerial', () {
      final value1 = Numeric(value: '-20.3', precision: 3, scale: 1);
      final value2 = SmallSerial(20);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to int', () {
      final value1 = Numeric(value: '-20.3', precision: 3, scale: 1);
      const value2 = 20;
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to integer-valued double', () {
      final value1 = Numeric(value: '-20.3', precision: 3, scale: 1);
      const value2 = 20.0;
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to fractional double', () {
      final value1 = Numeric(value: '-20.5', precision: 3, scale: 1);
      const value2 = 20.3;
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to integer-valued Real', () {
      final value1 = Numeric(value: '-20.3', precision: 3, scale: 1);
      final value2 = Real(20);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to fractional Real', () {
      final value1 = Numeric(value: '-20.5', precision: 3, scale: 1);
      final value2 = Real(20.3);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to integer-valued DoublePrecision',
        () {
      final value1 = Numeric(value: '-20.3', precision: 3, scale: 1);
      final value2 = DoublePrecision(20);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to fractional DoublePrecision', () {
      final value1 = Numeric(value: '-20.5', precision: 3, scale: 1);
      final value2 = DoublePrecision(20.3);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to int Numeric', () {
      final value1 = Numeric(value: '-20.3', precision: 3, scale: 1);
      final value2 = Numeric(value: '20', precision: 2, scale: 0);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to unconstrained int Numeric', () {
      final value1 = Numeric(value: '-20.3', precision: 3, scale: 1);
      final value2 = Numeric(value: '20');
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to float Numeric', () {
      final value1 = Numeric(value: '-20.5', precision: 3, scale: 1);
      final value2 = Numeric(value: '20.3', precision: 3, scale: 1);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to unconstrained float Numeric',
        () {
      final value1 = Numeric(value: '-20.5', precision: 3, scale: 1);
      final value2 = Numeric(value: '20.3');
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to fractional Numeric', () {
      final value1 = Numeric(value: '-0.58', precision: 3, scale: 2);
      final value2 = Numeric(value: '0.35', precision: 2, scale: 2);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to int Decimal', () {
      final value1 = Numeric(value: '-20.3', precision: 3, scale: 1);
      final value2 = Decimal(value: '20', precision: 2, scale: 0);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to unconstrained int Decimal', () {
      final value1 = Numeric(value: '-20.3', precision: 3, scale: 1);
      final value2 = Decimal(value: '20');
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to float Decimal', () {
      final value1 = Numeric(value: '-20.5', precision: 3, scale: 1);
      final value2 = Decimal(value: '20.3', precision: 3, scale: 1);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to unconstrained float Decimal',
        () {
      final value1 = Numeric(value: '-20.5', precision: 3, scale: 1);
      final value2 = Decimal(value: '20.3');
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to fractional Decimal', () {
      final value1 = Numeric(value: '-0.58', precision: 3, scale: 2);
      final value2 = Decimal(value: '0.35', precision: 2, scale: 2);
      final operation = value1 <= value2;
      expect(operation, true);
    });
  });

  group('zero comparison (greater)', () {
    test('should return false when comparing to BigInteger', () {
      final value1 = Numeric(value: '0.1', precision: 2, scale: 1);
      final value2 = BigInteger(0);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to Integer', () {
      final value1 = Numeric(value: '0.1', precision: 2, scale: 1);
      final value2 = Integer(0);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to SmallInteger', () {
      final value1 = Numeric(value: '0.1', precision: 2, scale: 1);
      final value2 = SmallInteger(0);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to int', () {
      final value1 = Numeric(value: '0.1', precision: 2, scale: 1);
      const value2 = 0;
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to integer-valued double', () {
      final value1 = Numeric(value: '0.1', precision: 2, scale: 1);
      const value2 = 0.0;
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to integer-valued Real', () {
      final value1 = Numeric(value: '0.1', precision: 2, scale: 1);
      final value2 = Real(0);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to integer-valued DoublePrecision',
        () {
      final value1 = Numeric(value: '0.1', precision: 2, scale: 1);
      final value2 = DoublePrecision(0);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to int Numeric', () {
      final value1 = Numeric(value: '0.1', precision: 2, scale: 1);
      final value2 = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to unconstrained int Numeric', () {
      final value1 = Numeric(value: '0.1', precision: 2, scale: 1);
      final value2 = Numeric(value: '0');
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to float Numeric', () {
      final value1 = Numeric(value: '0.1', precision: 2, scale: 1);
      final value2 = Numeric(value: '0.0', precision: 2, scale: 1);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to unconstrained float Numeric',
        () {
      final value1 = Numeric(value: '0.1', precision: 2, scale: 1);
      final value2 = Numeric(value: '0.0');
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to int Decimal', () {
      final value1 = Numeric(value: '0.1', precision: 2, scale: 1);
      final value2 = Decimal(value: '0', precision: 1, scale: 0);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to unconstrained int Decimal', () {
      final value1 = Numeric(value: '0.1', precision: 2, scale: 1);
      final value2 = Decimal(value: '0');
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to float Decimal', () {
      final value1 = Numeric(value: '0.1', precision: 2, scale: 1);
      final value2 = Decimal(value: '0.0', precision: 2, scale: 1);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to unconstrained float Decimal',
        () {
      final value1 = Numeric(value: '0.1', precision: 2, scale: 1);
      final value2 = Decimal(value: '0.0');
      final operation = value1 <= value2;
      expect(operation, false);
    });
  });

  group('zero comparison (less)', () {
    test('should return true when comparing to BigInteger', () {
      final value1 = Numeric(value: '-0.1', precision: 2, scale: 1);
      final value2 = BigInteger(0);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to Integer', () {
      final value1 = Numeric(value: '-0.1', precision: 2, scale: 1);
      final value2 = Integer(0);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to SmallInteger', () {
      final value1 = Numeric(value: '-0.1', precision: 2, scale: 1);
      final value2 = SmallInteger(0);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to int', () {
      final value1 = Numeric(value: '-0.1', precision: 2, scale: 1);
      const value2 = 0;
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to integer-valued double', () {
      final value1 = Numeric(value: '-0.1', precision: 2, scale: 1);
      const value2 = 0.0;
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to integer-valued Real', () {
      final value1 = Numeric(value: '-0.1', precision: 2, scale: 1);
      final value2 = Real(0);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to integer-valued DoublePrecision',
        () {
      final value1 = Numeric(value: '-0.1', precision: 2, scale: 1);
      final value2 = DoublePrecision(0);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to int Numeric', () {
      final value1 = Numeric(value: '-0.1', precision: 2, scale: 1);
      final value2 = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to unconstrained int Numeric', () {
      final value1 = Numeric(value: '-0.1', precision: 2, scale: 1);
      final value2 = Numeric(value: '0');
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to float Numeric', () {
      final value1 = Numeric(value: '-0.1', precision: 2, scale: 1);
      final value2 = Numeric(value: '0.0', precision: 2, scale: 1);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to unconstrained float Numeric',
        () {
      final value1 = Numeric(value: '-0.1', precision: 2, scale: 1);
      final value2 = Numeric(value: '0.0');
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to int Decimal', () {
      final value1 = Numeric(value: '-0.1', precision: 2, scale: 1);
      final value2 = Decimal(value: '0', precision: 1, scale: 0);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to unconstrained int Decimal', () {
      final value1 = Numeric(value: '-0.1', precision: 2, scale: 1);
      final value2 = Decimal(value: '0');
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to float Decimal', () {
      final value1 = Numeric(value: '-0.1', precision: 2, scale: 1);
      final value2 = Decimal(value: '0.0', precision: 2, scale: 1);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to unconstrained float Decimal',
        () {
      final value1 = Numeric(value: '-0.1', precision: 2, scale: 1);
      final value2 = Decimal(value: '0.0');
      final operation = value1 <= value2;
      expect(operation, true);
    });
  });

  group('large double comparison (greater)', () {
    test('should return false when comparing to integer-valued double', () {
      final value1 = Numeric(value: '1.3e20', precision: 21, scale: 0);
      const value2 = 1e10;
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to fractional double', () {
      final value1 = Numeric(value: '1.3e20', precision: 21, scale: 0);
      const value2 = 1.6e10;
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to integer-valued Real', () {
      final value1 = Numeric(value: '1.3e20', precision: 21, scale: 0);
      final value2 = Real(1e10);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to fractional Real', () {
      final value1 = Numeric(value: '1.3e20', precision: 21, scale: 0);
      final value2 = Real(1.6e10);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to integer-valued DoublePrecision',
        () {
      final value1 = Numeric(value: '1.3e20', precision: 21, scale: 0);
      final value2 = DoublePrecision(1e10);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to fractional DoublePrecision',
        () {
      final value1 = Numeric(value: '1.3e20', precision: 21, scale: 0);
      final value2 = DoublePrecision(1.6e10);
      final operation = value1 <= value2;
      expect(operation, false);
    });
  });

  group('large double comparison (less)', () {
    test('should return true when comparing to integer-valued double', () {
      final value1 = Numeric(value: '1.3e20', precision: 21, scale: 0);
      const value2 = 1e30;
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to fractional double', () {
      final value1 = Numeric(value: '1.3e20', precision: 21, scale: 0);
      const value2 = 1.6e30;
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to integer-valued Real', () {
      final value1 = Numeric(value: '1.3e20', precision: 21, scale: 0);
      final value2 = Real(1e30);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to fractional Real', () {
      final value1 = Numeric(value: '1.3e20', precision: 21, scale: 0);
      final value2 = Real(1.6e30);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to integer-valued DoublePrecision',
        () {
      final value1 = Numeric(value: '1.3e20', precision: 21, scale: 0);
      final value2 = DoublePrecision(1e30);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to fractional DoublePrecision', () {
      final value1 = Numeric(value: '1.3e20', precision: 21, scale: 0);
      final value2 = DoublePrecision(1.6e30);
      final operation = value1 <= value2;
      expect(operation, true);
    });
  });

  group('large double comparison (equal)', () {
    test('should return true when comparing to fractional double', () {
      final value1 = Numeric(value: '1.6e20', precision: 21, scale: 0);
      const value2 = 1.6e20;
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to fractional Real', () {
      final value1 = Numeric(value: '1.6e20', precision: 21, scale: 0);
      final value2 = Real(1.6e20);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to fractional DoublePrecision', () {
      final value1 = Numeric(value: '1.6e20', precision: 21, scale: 0);
      final value2 = DoublePrecision(1.6e20);
      final operation = value1 <= value2;
      expect(operation, true);
    });
  });

  group('positive close proximity comparison (greater)', () {
    test('should return false when comparing to BigInteger', () {
      final value1 = Numeric(value: '20.00001', precision: 7, scale: 5);
      final value2 = BigInteger(20);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to Integer', () {
      final value1 = Numeric(value: '20.00001', precision: 7, scale: 5);
      final value2 = Integer(20);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to SmallInteger', () {
      final value1 = Numeric(value: '20.00001', precision: 7, scale: 5);
      final value2 = SmallInteger(20);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to BigSerial', () {
      final value1 = Numeric(value: '20.00001', precision: 7, scale: 5);
      final value2 = BigSerial(20);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to Serial', () {
      final value1 = Numeric(value: '20.00001', precision: 7, scale: 5);
      final value2 = Serial(20);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to SmallSerial', () {
      final value1 = Numeric(value: '20.00001', precision: 7, scale: 5);
      final value2 = SmallSerial(20);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to int', () {
      final value1 = Numeric(value: '20.00001', precision: 7, scale: 5);
      const value2 = 20;
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to integer-valued double', () {
      final value1 = Numeric(value: '20.00001', precision: 7, scale: 5);
      const value2 = 20.0;
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to fractional double', () {
      final value1 = Numeric(value: '20.30001', precision: 7, scale: 5);
      const value2 = 20.3;
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to integer-valued Real', () {
      final value1 = Numeric(value: '20.00001', precision: 7, scale: 5);
      final value2 = Real(20);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to fractional Real', () {
      final value1 = Numeric(value: '20.30001', precision: 7, scale: 5);
      final value2 = Real(20.3);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to integer-valued DoublePrecision',
        () {
      final value1 = Numeric(value: '20.00001', precision: 7, scale: 5);
      final value2 = DoublePrecision(20);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to fractional DoublePrecision',
        () {
      final value1 = Numeric(value: '20.30001', precision: 7, scale: 5);
      final value2 = DoublePrecision(20.3);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to int Numeric', () {
      final value1 = Numeric(value: '20.00001', precision: 7, scale: 5);
      final value2 = Numeric(value: '20', precision: 2, scale: 0);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to unconstrained int Numeric', () {
      final value1 = Numeric(value: '20.00001', precision: 7, scale: 5);
      final value2 = Numeric(value: '20');
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to float Numeric', () {
      final value1 = Numeric(value: '20.30001', precision: 7, scale: 5);
      final value2 = Numeric(value: '20.3', precision: 3, scale: 1);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to unconstrained float Numeric',
        () {
      final value1 = Numeric(value: '20.30001', precision: 7, scale: 5);
      final value2 = Numeric(value: '20.3');
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to fractional Numeric', () {
      final value1 = Numeric(value: '0.35001', precision: 6, scale: 5);
      final value2 = Numeric(value: '0.35', precision: 2, scale: 2);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to int Decimal', () {
      final value1 = Numeric(value: '20.00001', precision: 7, scale: 5);
      final value2 = Decimal(value: '20', precision: 2, scale: 0);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to unconstrained int Decimal', () {
      final value1 = Numeric(value: '20.00001', precision: 7, scale: 5);
      final value2 = Decimal(value: '20');
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to float Decimal', () {
      final value1 = Numeric(value: '20.30001', precision: 7, scale: 5);
      final value2 = Decimal(value: '20.3', precision: 3, scale: 1);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to unconstrained float Decimal',
        () {
      final value1 = Numeric(value: '20.30001', precision: 7, scale: 5);
      final value2 = Decimal(value: '20.3');
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to fractional Decimal', () {
      final value1 = Numeric(value: '0.35001', precision: 6, scale: 5);
      final value2 = Decimal(value: '0.35', precision: 2, scale: 2);
      final operation = value1 <= value2;
      expect(operation, false);
    });
  });

  group('positive close proximity comparison (less)', () {
    test('should return true when comparing to BigInteger', () {
      final value1 = Numeric(value: '19.99999', precision: 7, scale: 5);
      final value2 = BigInteger(20);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to Integer', () {
      final value1 = Numeric(value: '19.99999', precision: 7, scale: 5);
      final value2 = Integer(20);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to SmallInteger', () {
      final value1 = Numeric(value: '19.99999', precision: 7, scale: 5);
      final value2 = SmallInteger(20);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to BigSerial', () {
      final value1 = Numeric(value: '19.99999', precision: 7, scale: 5);
      final value2 = BigSerial(20);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to Serial', () {
      final value1 = Numeric(value: '19.99999', precision: 7, scale: 5);
      final value2 = Serial(20);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to SmallSerial', () {
      final value1 = Numeric(value: '19.99999', precision: 7, scale: 5);
      final value2 = SmallSerial(20);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to int', () {
      final value1 = Numeric(value: '19.99999', precision: 7, scale: 5);
      const value2 = 20;
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to integer-valued double', () {
      final value1 = Numeric(value: '19.99999', precision: 7, scale: 5);
      const value2 = 20.0;
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to fractional double', () {
      final value1 = Numeric(value: '20.59999', precision: 7, scale: 5);
      const value2 = 20.6;
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to integer-valued Real', () {
      final value1 = Numeric(value: '19.99999', precision: 7, scale: 5);
      final value2 = Real(20.0);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to fractional Real', () {
      final value1 = Numeric(value: '20.59999', precision: 7, scale: 5);
      final value2 = Real(20.6);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to integer-valued DoublePrecision',
        () {
      final value1 = Numeric(value: '19.99999', precision: 7, scale: 5);
      final value2 = DoublePrecision(20.0);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to fractional DoublePrecision', () {
      final value1 = Numeric(value: '20.59999', precision: 7, scale: 5);
      final value2 = DoublePrecision(20.6);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to int Numeric', () {
      final value1 = Numeric(value: '19.99999', precision: 7, scale: 5);
      final value2 = Numeric(value: '20', precision: 2, scale: 0);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to unconstrained int Numeric', () {
      final value1 = Numeric(value: '19.99999', precision: 7, scale: 5);
      final value2 = Numeric(value: '20');
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to float Numeric', () {
      final value1 = Numeric(value: '20.59999', precision: 7, scale: 5);
      final value2 = Numeric(value: '20.6', precision: 3, scale: 1);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to unconstrained float Numeric',
        () {
      final value1 = Numeric(value: '20.59999', precision: 7, scale: 5);
      final value2 = Numeric(value: '20.6');
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to fractional Numeric', () {
      final value1 = Numeric(value: '0.34999', precision: 6, scale: 5);
      final value2 = Numeric(value: '0.35', precision: 2, scale: 2);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to int Decimal', () {
      final value1 = Numeric(value: '19.99999', precision: 7, scale: 5);
      final value2 = Decimal(value: '20', precision: 2, scale: 0);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to unconstrained int Decimal', () {
      final value1 = Numeric(value: '19.99999', precision: 7, scale: 5);
      final value2 = Decimal(value: '20');
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to float Decimal', () {
      final value1 = Numeric(value: '20.59999', precision: 7, scale: 5);
      final value2 = Decimal(value: '20.6', precision: 3, scale: 1);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to unconstrained float Decimal',
        () {
      final value1 = Numeric(value: '20.59999', precision: 7, scale: 5);
      final value2 = Decimal(value: '20.6');
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to fractional Decimal', () {
      final value1 = Numeric(value: '0.34999', precision: 6, scale: 5);
      final value2 = Decimal(value: '0.35', precision: 2, scale: 2);
      final operation = value1 <= value2;
      expect(operation, true);
    });
  });

  group('positive close proximity comparison (equal)', () {
    test('should return true when comparing to fractional double', () {
      final value1 = Numeric(value: '20.59999', precision: 7, scale: 5);
      const value2 = 20.59999;
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to fractional Real', () {
      final value1 = Numeric(value: '20.59999', precision: 7, scale: 5);
      final value2 = Real(20.59999);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to fractional DoublePrecision', () {
      final value1 = Numeric(value: '20.59999', precision: 7, scale: 5);
      final value2 = DoublePrecision(20.59999);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to float Numeric', () {
      final value1 = Numeric(value: '20.59999', precision: 7, scale: 5);
      final value2 = Numeric(value: '20.59999', precision: 7, scale: 5);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to unconstrained float Numeric',
        () {
      final value1 = Numeric(value: '20.59999', precision: 7, scale: 5);
      final value2 = Numeric(value: '20.59999');
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to fractional Numeric', () {
      final value1 = Numeric(value: '0.34999', precision: 6, scale: 5);
      final value2 = Numeric(value: '0.34999', precision: 5, scale: 5);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to float Decimal', () {
      final value1 = Numeric(value: '20.59999', precision: 7, scale: 5);
      final value2 = Decimal(value: '20.59999', precision: 7, scale: 5);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to unconstrained float Decimal',
        () {
      final value1 = Numeric(value: '20.59999', precision: 7, scale: 5);
      final value2 = Decimal(value: '20.59999');
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to fractional Decimal', () {
      final value1 = Numeric(value: '0.34999', precision: 6, scale: 5);
      final value2 = Decimal(value: '0.34999', precision: 5, scale: 5);
      final operation = value1 <= value2;
      expect(operation, true);
    });
  });

  group('negative close proximity comparison (greater)', () {
    test('should return false when comparing to BigInteger', () {
      final value1 = Numeric(value: '-19.99999', precision: 7, scale: 5);
      final value2 = BigInteger(-20);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to Integer', () {
      final value1 = Numeric(value: '-19.99999', precision: 7, scale: 5);
      final value2 = Integer(-20);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to SmallInteger', () {
      final value1 = Numeric(value: '-19.99999', precision: 7, scale: 5);
      final value2 = SmallInteger(-20);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to int', () {
      final value1 = Numeric(value: '-19.99999', precision: 7, scale: 5);
      const value2 = -20;
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to integer-valued double', () {
      final value1 = Numeric(value: '-19.99999', precision: 7, scale: 5);
      const value2 = -20.0;
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to fractional double', () {
      final value1 = Numeric(value: '-20.59999', precision: 7, scale: 5);
      const value2 = -20.6;
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to integer-valued Real', () {
      final value1 = Numeric(value: '-9.99999', precision: 6, scale: 5);
      final value2 = Real(-20.0);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to fractional Real', () {
      final value1 = Numeric(value: '-20.59999', precision: 7, scale: 5);
      final value2 = Real(-20.6);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to integer-valued DoublePrecision',
        () {
      final value1 = Numeric(value: '-19.99999', precision: 7, scale: 5);
      final value2 = DoublePrecision(-20.0);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to fractional DoublePrecision',
        () {
      final value1 = Numeric(value: '-20.59999', precision: 7, scale: 5);
      final value2 = DoublePrecision(-20.6);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to int Numeric', () {
      final value1 = Numeric(value: '-19.99999', precision: 7, scale: 5);
      final value2 = Numeric(value: '-20', precision: 2, scale: 0);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to unconstrained int Numeric', () {
      final value1 = Numeric(value: '-19.99999', precision: 7, scale: 5);
      final value2 = Numeric(value: '-20');
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to float Numeric', () {
      final value1 = Numeric(value: '-20.59999', precision: 7, scale: 5);
      final value2 = Numeric(value: '-20.6', precision: 3, scale: 1);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to unconstrained float Numeric',
        () {
      final value1 = Numeric(value: '-20.59999', precision: 7, scale: 5);
      final value2 = Numeric(value: '-20.6');
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to fractional Numeric', () {
      final value1 = Numeric(value: '-0.34999', precision: 6, scale: 5);
      final value2 = Numeric(value: '-0.35', precision: 2, scale: 2);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to int Decimal', () {
      final value1 = Numeric(value: '-19.99999', precision: 7, scale: 5);
      final value2 = Decimal(value: '-20', precision: 2, scale: 0);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to unconstrained int Decimal', () {
      final value1 = Numeric(value: '-19.99999', precision: 7, scale: 5);
      final value2 = Decimal(value: '-20');
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to float Decimal', () {
      final value1 = Numeric(value: '-20.59999', precision: 7, scale: 5);
      final value2 = Decimal(value: '-20.6', precision: 3, scale: 1);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to unconstrained float Decimal',
        () {
      final value1 = Numeric(value: '-20.59999', precision: 7, scale: 5);
      final value2 = Decimal(value: '-20.6');
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to fractional Decimal', () {
      final value1 = Numeric(value: '-0.34999', precision: 6, scale: 5);
      final value2 = Decimal(value: '-0.35', precision: 2, scale: 2);
      final operation = value1 <= value2;
      expect(operation, false);
    });
  });

  group('negative close proximity comparison (less)', () {
    test('should return true when comparing to BigInteger', () {
      final value1 = Numeric(value: '-20.00001', precision: 7, scale: 5);
      final value2 = BigInteger(-20);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to Integer', () {
      final value1 = Numeric(value: '-20.00001', precision: 7, scale: 5);
      final value2 = Integer(-20);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to SmallInteger', () {
      final value1 = Numeric(value: '-20.00001', precision: 7, scale: 5);
      final value2 = SmallInteger(-20);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to int', () {
      final value1 = Numeric(value: '-20.00001', precision: 7, scale: 5);
      const value2 = -20;
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to integer-valued double', () {
      final value1 = Numeric(value: '-20.00001', precision: 7, scale: 5);
      const value2 = -20.0;
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to fractional double', () {
      final value1 = Numeric(value: '-20.30001', precision: 7, scale: 5);
      const value2 = -20.3;
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to integer-valued Real', () {
      final value1 = Numeric(value: '-20.00001', precision: 7, scale: 5);
      final value2 = Real(-20);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to fractional Real', () {
      final value1 = Numeric(value: '-20.30001', precision: 7, scale: 5);
      final value2 = Real(-20.3);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to integer-valued DoublePrecision',
        () {
      final value1 = Numeric(value: '-20.00001', precision: 7, scale: 5);
      final value2 = DoublePrecision(-20);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to fractional DoublePrecision', () {
      final value1 = Numeric(value: '-20.30001', precision: 7, scale: 5);
      final value2 = DoublePrecision(-20.3);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to int Numeric', () {
      final value1 = Numeric(value: '-20.00001', precision: 7, scale: 5);
      final value2 = Numeric(value: '-20', precision: 2, scale: 0);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to unconstrained int Numeric', () {
      final value1 = Numeric(value: '-20.00001', precision: 7, scale: 5);
      final value2 = Numeric(value: '-20');
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to float Numeric', () {
      final value1 = Numeric(value: '-20.30001', precision: 7, scale: 5);
      final value2 = Numeric(value: '-20.3', precision: 3, scale: 1);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to unconstrained float Numeric',
        () {
      final value1 = Numeric(value: '-20.30001', precision: 7, scale: 5);
      final value2 = Numeric(value: '-20.3');
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to fractional Numeric', () {
      final value1 = Numeric(value: '-0.35001', precision: 6, scale: 5);
      final value2 = Numeric(value: '-0.35', precision: 2, scale: 2);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to int Decimal', () {
      final value1 = Numeric(value: '-20.00001', precision: 7, scale: 5);
      final value2 = Decimal(value: '-20', precision: 2, scale: 0);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to unconstrained int Decimal', () {
      final value1 = Numeric(value: '-20.00001', precision: 7, scale: 5);
      final value2 = Decimal(value: '-20');
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to float Decimal', () {
      final value1 = Numeric(value: '-20.30001', precision: 7, scale: 5);
      final value2 = Decimal(value: '-20.3', precision: 3, scale: 1);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to unconstrained float Decimal',
        () {
      final value1 = Numeric(value: '-20.30001', precision: 7, scale: 5);
      final value2 = Decimal(value: '-20.3');
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to fractional Decimal', () {
      final value1 = Numeric(value: '-0.35001', precision: 6, scale: 5);
      final value2 = Decimal(value: '-0.35', precision: 2, scale: 2);
      final operation = value1 <= value2;
      expect(operation, true);
    });
  });

  group('negative close proximity comparison (equal)', () {
    test('should return true when comparing to fractional double', () {
      final value1 = Numeric(value: '-20.59999', precision: 7, scale: 5);
      const value2 = -20.59999;
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to fractional Real', () {
      final value1 = Numeric(value: '-20.59999', precision: 7, scale: 5);
      final value2 = Real(-20.59999);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to fractional DoublePrecision', () {
      final value1 = Numeric(value: '-20.59999', precision: 7, scale: 5);
      final value2 = DoublePrecision(-20.59999);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to float Numeric', () {
      final value1 = Numeric(value: '-20.59999', precision: 7, scale: 5);
      final value2 = Numeric(value: '-20.59999', precision: 7, scale: 5);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to unconstrained float Numeric',
        () {
      final value1 = Numeric(value: '-20.59999', precision: 7, scale: 5);
      final value2 = Numeric(value: '-20.59999');
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to fractional Numeric', () {
      final value1 = Numeric(value: '-0.34999', precision: 6, scale: 5);
      final value2 = Numeric(value: '-0.34999', precision: 5, scale: 5);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to float Decimal', () {
      final value1 = Numeric(value: '-20.59999', precision: 7, scale: 5);
      final value2 = Decimal(value: '-20.59999', precision: 7, scale: 5);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to unconstrained float Decimal',
        () {
      final value1 = Numeric(value: '-20.59999', precision: 7, scale: 5);
      final value2 = Decimal(value: '-20.59999');
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to fractional Decimal', () {
      final value1 = Numeric(value: '-0.34999', precision: 6, scale: 5);
      final value2 = Decimal(value: '-0.34999', precision: 5, scale: 5);
      final operation = value1 <= value2;
      expect(operation, true);
    });
  });

  group('zero cases', () {
    test(
        'should return true when comparing positive zero to negative Decimal zero',
        () {
      final value1 = Numeric(value: '0.0', precision: 2, scale: 1);
      final value2 = Decimal(value: '-0.0', precision: 2, scale: 1);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test(
        'should return true when comparing positive zero to negative Numeric zero',
        () {
      final value1 = Numeric(value: '0.0', precision: 2, scale: 1);
      final value2 = Numeric(value: '-0.0', precision: 2, scale: 1);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test(
        'should return true when comparing negative zero to positive Decimal zero',
        () {
      final value1 = Numeric(value: '-0.0', precision: 2, scale: 1);
      final value2 = Decimal(value: '0.0', precision: 2, scale: 1);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test(
        'should return true when comparing negative zero to positive Numeric zero',
        () {
      final value1 = Numeric(value: '-0.0', precision: 2, scale: 1);
      final value2 = Numeric(value: '0.0', precision: 2, scale: 1);
      final operation = value1 <= value2;
      expect(operation, true);
    });
  });

  group('general errors', () {
    test('should throw ArgumentError if value is NaN', () {
      final value1 = Numeric(value: '0', precision: 1, scale: 0);
      const value2 = double.nan;
      expect(() => value1 <= value2, throwsArgumentError);
    });

    test('should throw ArgumentError if value is infinity', () {
      final value1 = Numeric(value: '0', precision: 1, scale: 0);
      const value2 = double.infinity;
      expect(() => value1 <= value2, throwsArgumentError);
    });

    test('should throw ArgumentError if value is negative infinity', () {
      final value1 = Numeric(value: '0', precision: 1, scale: 0);
      const value2 = double.negativeInfinity;
      expect(() => value1 <= value2, throwsArgumentError);
    });

    test('should throw ArgumentError if value is unsupported', () {
      final value1 = Numeric(value: '0', precision: 1, scale: 0);
      final value2 = DateTime(2022);
      expect(() => value1 <= value2, throwsArgumentError);
    });
  });
}
