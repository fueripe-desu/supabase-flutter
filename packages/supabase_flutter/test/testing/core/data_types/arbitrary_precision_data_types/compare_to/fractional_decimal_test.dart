// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/floating_point_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
  group('positive comparison (greater)', () {
    test('should return 1 when comparing to fractional double', () {
      final value1 = Decimal(value: '0.7', precision: 1, scale: 1);
      const value2 = 0.3;
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to fractional Real', () {
      final value1 = Decimal(value: '0.7', precision: 1, scale: 1);
      final value2 = Real(0.3);
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to fractional DoublePrecision', () {
      final value1 = Decimal(value: '0.7', precision: 1, scale: 1);
      final value2 = DoublePrecision(0.3);
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to float Numeric', () {
      final value1 = Decimal(value: '0.7', precision: 1, scale: 1);
      final value2 = Numeric(value: '0.3', precision: 2, scale: 1);
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to unconstrained float Numeric', () {
      final value1 = Decimal(value: '0.7', precision: 1, scale: 1);
      final value2 = Numeric(value: '0.3');
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to fractional Numeric', () {
      final value1 = Decimal(value: '0.7', precision: 1, scale: 1);
      final value2 = Numeric(value: '0.3', precision: 1, scale: 1);
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to float Decimal', () {
      final value1 = Decimal(value: '0.7', precision: 1, scale: 1);
      final value2 = Decimal(value: '0.3', precision: 2, scale: 1);
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to unconstrained float Decimal', () {
      final value1 = Decimal(value: '0.7', precision: 1, scale: 1);
      final value2 = Decimal(value: '0.3');
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to fractional Decimal', () {
      final value1 = Decimal(value: '0.7', precision: 1, scale: 1);
      final value2 = Decimal(value: '0.3', precision: 1, scale: 1);
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });
  });

  group('positive comparison (less)', () {
    test('should return -1 when comparing to BigInteger', () {
      final value1 = Decimal(value: '0.1', precision: 1, scale: 1);
      final value2 = BigInteger(20);
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to Integer', () {
      final value1 = Decimal(value: '0.1', precision: 1, scale: 1);
      final value2 = Integer(20);
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to SmallInteger', () {
      final value1 = Decimal(value: '0.1', precision: 1, scale: 1);
      final value2 = SmallInteger(20);
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to BigSerial', () {
      final value1 = Decimal(value: '0.1', precision: 1, scale: 1);
      final value2 = BigSerial(20);
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to Serial', () {
      final value1 = Decimal(value: '0.1', precision: 1, scale: 1);
      final value2 = Serial(20);
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to SmallSerial', () {
      final value1 = Decimal(value: '0.1', precision: 1, scale: 1);
      final value2 = SmallSerial(20);
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to int', () {
      final value1 = Decimal(value: '0.1', precision: 1, scale: 1);
      const value2 = 20;
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to integer-valued double', () {
      final value1 = Decimal(value: '0.1', precision: 1, scale: 1);
      const value2 = 20.0;
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to fractional double', () {
      final value1 = Decimal(value: '0.1', precision: 1, scale: 1);
      const value2 = 20.6;
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to integer-valued Real', () {
      final value1 = Decimal(value: '0.1', precision: 1, scale: 1);
      final value2 = Real(20.0);
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to fractional Real', () {
      final value1 = Decimal(value: '0.1', precision: 1, scale: 1);
      final value2 = Real(20.6);
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to integer-valued DoublePrecision',
        () {
      final value1 = Decimal(value: '0.1', precision: 1, scale: 1);
      final value2 = DoublePrecision(20.0);
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to fractional DoublePrecision', () {
      final value1 = Decimal(value: '0.1', precision: 1, scale: 1);
      final value2 = DoublePrecision(20.6);
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to int Numeric', () {
      final value1 = Decimal(value: '0.1', precision: 1, scale: 1);
      final value2 = Numeric(value: '20', precision: 2, scale: 0);
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to unconstrained int Numeric', () {
      final value1 = Decimal(value: '0.1', precision: 1, scale: 1);
      final value2 = Numeric(value: '20');
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to float Numeric', () {
      final value1 = Decimal(value: '0.1', precision: 1, scale: 1);
      final value2 = Numeric(value: '20.6', precision: 3, scale: 1);
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to unconstrained float Numeric', () {
      final value1 = Decimal(value: '0.1', precision: 1, scale: 1);
      final value2 = Numeric(value: '20.6');
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to fractional Numeric', () {
      final value1 = Decimal(value: '0.1', precision: 1, scale: 1);
      final value2 = Numeric(value: '0.35', precision: 2, scale: 2);
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to int Decimal', () {
      final value1 = Decimal(value: '0.1', precision: 1, scale: 1);
      final value2 = Decimal(value: '20', precision: 2, scale: 0);
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to unconstrained int Decimal', () {
      final value1 = Decimal(value: '0.1', precision: 1, scale: 1);
      final value2 = Decimal(value: '20');
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to float Decimal', () {
      final value1 = Decimal(value: '0.1', precision: 1, scale: 1);
      final value2 = Decimal(value: '20.6', precision: 3, scale: 1);
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to unconstrained float Decimal', () {
      final value1 = Decimal(value: '0.1', precision: 1, scale: 1);
      final value2 = Decimal(value: '20.6');
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to fractional Decimal', () {
      final value1 = Decimal(value: '0.1', precision: 1, scale: 1);
      final value2 = Decimal(value: '0.35', precision: 2, scale: 2);
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });
  });

  group('positive comparison (equal)', () {
    test('should return 0 when comparing to fractional double', () {
      final value1 = Decimal(value: '0.3', precision: 1, scale: 1);
      const value2 = 0.3;
      final operation = value1.compareTo(value2);
      expect(operation, 0);
    });

    test('should return 0 when comparing to fractional Real', () {
      final value1 = Decimal(value: '0.3', precision: 1, scale: 1);
      final value2 = Real(0.3);
      final operation = value1.compareTo(value2);
      expect(operation, 0);
    });

    test('should return 0 when comparing to fractional DoublePrecision', () {
      final value1 = Decimal(value: '0.3', precision: 1, scale: 1);
      final value2 = DoublePrecision(0.3);
      final operation = value1.compareTo(value2);
      expect(operation, 0);
    });

    test('should return 0 when comparing to float Numeric', () {
      final value1 = Decimal(value: '0.3', precision: 1, scale: 1);
      final value2 = Numeric(value: '0.3', precision: 1, scale: 1);
      final operation = value1.compareTo(value2);
      expect(operation, 0);
    });

    test('should return 0 when comparing to unconstrained float Numeric', () {
      final value1 = Decimal(value: '0.3', precision: 1, scale: 1);
      final value2 = Numeric(value: '0.3');
      final operation = value1.compareTo(value2);
      expect(operation, 0);
    });

    test('should return 0 when comparing to fractional Numeric', () {
      final value1 = Decimal(value: '0.3', precision: 1, scale: 1);
      final value2 = Numeric(value: '0.3', precision: 1, scale: 1);
      final operation = value1.compareTo(value2);
      expect(operation, 0);
    });

    test('should return 0 when comparing to float Decimal', () {
      final value1 = Decimal(value: '0.3', precision: 1, scale: 1);
      final value2 = Decimal(value: '0.3', precision: 2, scale: 1);
      final operation = value1.compareTo(value2);
      expect(operation, 0);
    });

    test('should return 0 when comparing to unconstrained float Decimal', () {
      final value1 = Decimal(value: '0.3', precision: 1, scale: 1);
      final value2 = Decimal(value: '0.3');
      final operation = value1.compareTo(value2);
      expect(operation, 0);
    });

    test('should return 0 when comparing to fractional Decimal', () {
      final value1 = Decimal(value: '0.3', precision: 1, scale: 1);
      final value2 = Decimal(value: '0.3', precision: 1, scale: 1);
      final operation = value1.compareTo(value2);
      expect(operation, 0);
    });
  });

  group('negative comparison (greater)', () {
    test('should return 1 when comparing to BigInteger', () {
      final value1 = Decimal(value: '-0.3', precision: 1, scale: 1);
      final value2 = BigInteger(-20);
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to Integer', () {
      final value1 = Decimal(value: '-0.3', precision: 1, scale: 1);
      final value2 = Integer(-20);
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to SmallInteger', () {
      final value1 = Decimal(value: '-0.3', precision: 1, scale: 1);
      final value2 = SmallInteger(-20);
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to int', () {
      final value1 = Decimal(value: '-0.3', precision: 1, scale: 1);
      const value2 = -20;
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to integer-valued double', () {
      final value1 = Decimal(value: '-0.3', precision: 1, scale: 1);
      const value2 = -20.0;
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to fractional double', () {
      final value1 = Decimal(value: '-0.3', precision: 1, scale: 1);
      const value2 = -20.3;
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to integer-valued Real', () {
      final value1 = Decimal(value: '-0.3', precision: 1, scale: 1);
      final value2 = Real(-20);
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to fractional Real', () {
      final value1 = Decimal(value: '-0.3', precision: 1, scale: 1);
      final value2 = Real(-20.3);
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to integer-valued DoublePrecision',
        () {
      final value1 = Decimal(value: '-0.3', precision: 1, scale: 1);
      final value2 = DoublePrecision(-20);
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to fractional DoublePrecision', () {
      final value1 = Decimal(value: '-0.3', precision: 1, scale: 1);
      final value2 = DoublePrecision(-20.3);
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to int Numeric', () {
      final value1 = Decimal(value: '-0.3', precision: 1, scale: 1);
      final value2 = Numeric(value: '-20', precision: 2, scale: 0);
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to unconstrained int Numeric', () {
      final value1 = Decimal(value: '-0.3', precision: 1, scale: 1);
      final value2 = Numeric(value: '-20');
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to float Numeric', () {
      final value1 = Decimal(value: '-0.3', precision: 1, scale: 1);
      final value2 = Numeric(value: '-20.3', precision: 3, scale: 1);
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to unconstrained float Numeric', () {
      final value1 = Decimal(value: '-0.3', precision: 1, scale: 1);
      final value2 = Numeric(value: '-20.3');
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to fractional Numeric', () {
      final value1 = Decimal(value: '-0.3', precision: 1, scale: 1);
      final value2 = Numeric(value: '-0.35', precision: 2, scale: 2);
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to int Decimal', () {
      final value1 = Decimal(value: '-0.3', precision: 1, scale: 1);
      final value2 = Decimal(value: '-20', precision: 2, scale: 0);
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to unconstrained int Decimal', () {
      final value1 = Decimal(value: '-0.3', precision: 1, scale: 1);
      final value2 = Decimal(value: '-20');
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to float Decimal', () {
      final value1 = Decimal(value: '-0.3', precision: 1, scale: 1);
      final value2 = Decimal(value: '-20.3', precision: 3, scale: 1);
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to unconstrained float Decimal', () {
      final value1 = Decimal(value: '-0.3', precision: 1, scale: 1);
      final value2 = Decimal(value: '-20.3');
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to fractional Decimal', () {
      final value1 = Decimal(value: '-0.3', precision: 1, scale: 1);
      final value2 = Decimal(value: '-0.35', precision: 2, scale: 2);
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });
  });

  group('negative comparison (less)', () {
    test('should return -1 when comparing to fractional double', () {
      final value1 = Decimal(value: '-0.7', precision: 1, scale: 1);
      const value2 = -0.3;
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to fractional Real', () {
      final value1 = Decimal(value: '-0.7', precision: 1, scale: 1);
      final value2 = Real(-0.3);
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to fractional DoublePrecision', () {
      final value1 = Decimal(value: '-0.7', precision: 1, scale: 1);
      final value2 = DoublePrecision(-0.3);
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to float Numeric', () {
      final value1 = Decimal(value: '-0.7', precision: 1, scale: 1);
      final value2 = Numeric(value: '-0.3', precision: 2, scale: 1);
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to unconstrained float Numeric', () {
      final value1 = Decimal(value: '-0.7', precision: 1, scale: 1);
      final value2 = Numeric(value: '-0.3');
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to fractional Numeric', () {
      final value1 = Decimal(value: '-0.7', precision: 1, scale: 1);
      final value2 = Numeric(value: '-0.3', precision: 1, scale: 1);
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to float Decimal', () {
      final value1 = Decimal(value: '-0.7', precision: 1, scale: 1);
      final value2 = Decimal(value: '-0.3', precision: 3, scale: 1);
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to unconstrained float Decimal', () {
      final value1 = Decimal(value: '-0.7', precision: 1, scale: 1);
      final value2 = Decimal(value: '-0.3');
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to fractional Decimal', () {
      final value1 = Decimal(value: '-0.7', precision: 1, scale: 1);
      final value2 = Decimal(value: '-0.3', precision: 1, scale: 1);
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });
  });

  group('negative comparison (equal)', () {
    test('should return 0 when comparing to fractional double', () {
      final value1 = Decimal(value: '-0.3', precision: 1, scale: 1);
      const value2 = -0.3;
      final operation = value1.compareTo(value2);
      expect(operation, 0);
    });

    test('should return 0 when comparing to fractional Real', () {
      final value1 = Decimal(value: '-0.3', precision: 1, scale: 1);
      final value2 = Real(-0.3);
      final operation = value1.compareTo(value2);
      expect(operation, 0);
    });

    test('should return 0 when comparing to fractional DoublePrecision', () {
      final value1 = Decimal(value: '-0.3', precision: 1, scale: 1);
      final value2 = DoublePrecision(-0.3);
      final operation = value1.compareTo(value2);
      expect(operation, 0);
    });

    test('should return 0 when comparing to float Numeric', () {
      final value1 = Decimal(value: '-0.3', precision: 1, scale: 1);
      final value2 = Numeric(value: '-0.3', precision: 2, scale: 1);
      final operation = value1.compareTo(value2);
      expect(operation, 0);
    });

    test('should return 0 when comparing to unconstrained float Numeric', () {
      final value1 = Decimal(value: '-0.3', precision: 1, scale: 1);
      final value2 = Numeric(value: '-0.3');
      final operation = value1.compareTo(value2);
      expect(operation, 0);
    });

    test('should return 0 when comparing to fractional Numeric', () {
      final value1 = Decimal(value: '-0.3', precision: 1, scale: 1);
      final value2 = Numeric(value: '-0.3', precision: 1, scale: 1);
      final operation = value1.compareTo(value2);
      expect(operation, 0);
    });

    test('should return 0 when comparing to float Decimal', () {
      final value1 = Decimal(value: '-0.3', precision: 1, scale: 1);
      final value2 = Decimal(value: '-0.3', precision: 2, scale: 1);
      final operation = value1.compareTo(value2);
      expect(operation, 0);
    });

    test('should return 0 when comparing to unconstrained float Decimal', () {
      final value1 = Decimal(value: '-0.3', precision: 1, scale: 1);
      final value2 = Decimal(value: '-0.3');
      final operation = value1.compareTo(value2);
      expect(operation, 0);
    });

    test('should return 0 when comparing to fractional Decimal', () {
      final value1 = Decimal(value: '-0.3', precision: 1, scale: 1);
      final value2 = Decimal(value: '-0.3', precision: 1, scale: 1);
      final operation = value1.compareTo(value2);
      expect(operation, 0);
    });
  });

  group('mixed sign comparison (positive + negative)', () {
    test('should return 1 when comparing to BigInteger', () {
      final value1 = Decimal(value: '0.3', precision: 1, scale: 1);
      final value2 = BigInteger(-20);
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to Integer', () {
      final value1 = Decimal(value: '0.3', precision: 1, scale: 1);
      final value2 = Integer(-20);
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to SmallInteger', () {
      final value1 = Decimal(value: '0.3', precision: 1, scale: 1);
      final value2 = SmallInteger(-20);
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to int', () {
      final value1 = Decimal(value: '0.3', precision: 1, scale: 1);
      const value2 = -20;
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to integer-valued double', () {
      final value1 = Decimal(value: '0.3', precision: 1, scale: 1);
      const value2 = -20.0;
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to fractional double', () {
      final value1 = Decimal(value: '0.3', precision: 1, scale: 1);
      const value2 = -20.3;
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to integer-valued Real', () {
      final value1 = Decimal(value: '0.3', precision: 1, scale: 1);
      final value2 = Real(-20);
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to fractional Real', () {
      final value1 = Decimal(value: '0.3', precision: 1, scale: 1);
      final value2 = Real(-20.3);
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to integer-valued DoublePrecision',
        () {
      final value1 = Decimal(value: '0.3', precision: 1, scale: 1);
      final value2 = DoublePrecision(-20);
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to fractional DoublePrecision', () {
      final value1 = Decimal(value: '0.3', precision: 1, scale: 1);
      final value2 = DoublePrecision(-20.3);
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to int Numeric', () {
      final value1 = Decimal(value: '0.3', precision: 1, scale: 1);
      final value2 = Numeric(value: '-20', precision: 2, scale: 0);
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to unconstrained int Numeric', () {
      final value1 = Decimal(value: '0.3', precision: 1, scale: 1);
      final value2 = Numeric(value: '-20');
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to float Numeric', () {
      final value1 = Decimal(value: '0.3', precision: 1, scale: 1);
      final value2 = Numeric(value: '-20.3', precision: 3, scale: 1);
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to unconstrained float Numeric', () {
      final value1 = Decimal(value: '0.3', precision: 1, scale: 1);
      final value2 = Numeric(value: '-20.3');
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to fractional Numeric', () {
      final value1 = Decimal(value: '0.3', precision: 1, scale: 1);
      final value2 = Numeric(value: '-0.35', precision: 2, scale: 2);
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to int Decimal', () {
      final value1 = Decimal(value: '0.3', precision: 1, scale: 1);
      final value2 = Decimal(value: '-20', precision: 2, scale: 0);
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to unconstrained int Decimal', () {
      final value1 = Decimal(value: '0.3', precision: 1, scale: 1);
      final value2 = Decimal(value: '-20');
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to float Decimal', () {
      final value1 = Decimal(value: '0.3', precision: 1, scale: 1);
      final value2 = Decimal(value: '-20.3', precision: 3, scale: 1);
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to unconstrained float Decimal', () {
      final value1 = Decimal(value: '0.3', precision: 1, scale: 1);
      final value2 = Decimal(value: '-20.3');
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to fractional Decimal', () {
      final value1 = Decimal(value: '0.3', precision: 1, scale: 1);
      final value2 = Decimal(value: '-0.35', precision: 2, scale: 2);
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });
  });

  group('mixed sign comparison (negative + positive)', () {
    test('should return -1 when comparing to BigInteger', () {
      final value1 = Decimal(value: '-0.3', precision: 1, scale: 1);
      final value2 = BigInteger(20);
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to Integer', () {
      final value1 = Decimal(value: '-0.3', precision: 1, scale: 1);
      final value2 = Integer(20);
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to SmallInteger', () {
      final value1 = Decimal(value: '-0.3', precision: 1, scale: 1);
      final value2 = SmallInteger(20);
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to BigSerial', () {
      final value1 = Decimal(value: '-0.3', precision: 1, scale: 1);
      final value2 = BigSerial(20);
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to Serial', () {
      final value1 = Decimal(value: '-0.3', precision: 1, scale: 1);
      final value2 = Serial(20);
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to SmallSerial', () {
      final value1 = Decimal(value: '-0.3', precision: 1, scale: 1);
      final value2 = SmallSerial(20);
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to int', () {
      final value1 = Decimal(value: '-0.3', precision: 1, scale: 1);
      const value2 = 20;
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to integer-valued double', () {
      final value1 = Decimal(value: '-0.3', precision: 1, scale: 1);
      const value2 = 20.0;
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to fractional double', () {
      final value1 = Decimal(value: '-0.3', precision: 1, scale: 1);
      const value2 = 20.3;
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to integer-valued Real', () {
      final value1 = Decimal(value: '-0.3', precision: 1, scale: 1);
      final value2 = Real(20);
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to fractional Real', () {
      final value1 = Decimal(value: '-0.3', precision: 1, scale: 1);
      final value2 = Real(20.3);
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to integer-valued DoublePrecision',
        () {
      final value1 = Decimal(value: '-0.3', precision: 1, scale: 1);
      final value2 = DoublePrecision(20);
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to fractional DoublePrecision', () {
      final value1 = Decimal(value: '-0.3', precision: 1, scale: 1);
      final value2 = DoublePrecision(20.3);
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to int Numeric', () {
      final value1 = Decimal(value: '-0.3', precision: 1, scale: 1);
      final value2 = Numeric(value: '20', precision: 2, scale: 0);
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to unconstrained int Numeric', () {
      final value1 = Decimal(value: '-0.3', precision: 1, scale: 1);
      final value2 = Numeric(value: '20');
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to float Numeric', () {
      final value1 = Decimal(value: '-0.3', precision: 1, scale: 1);
      final value2 = Numeric(value: '20.3', precision: 3, scale: 1);
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to unconstrained float Numeric', () {
      final value1 = Decimal(value: '-0.3', precision: 1, scale: 1);
      final value2 = Numeric(value: '20.3');
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to fractional Numeric', () {
      final value1 = Decimal(value: '-0.3', precision: 1, scale: 1);
      final value2 = Numeric(value: '0.35', precision: 2, scale: 2);
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to int Decimal', () {
      final value1 = Decimal(value: '-0.3', precision: 1, scale: 1);
      final value2 = Decimal(value: '20', precision: 2, scale: 0);
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to unconstrained int Decimal', () {
      final value1 = Decimal(value: '-0.3', precision: 1, scale: 1);
      final value2 = Decimal(value: '20');
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to float Decimal', () {
      final value1 = Decimal(value: '-0.3', precision: 1, scale: 1);
      final value2 = Decimal(value: '20.3', precision: 3, scale: 1);
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to unconstrained float Decimal', () {
      final value1 = Decimal(value: '-0.3', precision: 1, scale: 1);
      final value2 = Decimal(value: '20.3');
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to fractional Decimal', () {
      final value1 = Decimal(value: '-0.3', precision: 1, scale: 1);
      final value2 = Decimal(value: '0.35', precision: 2, scale: 2);
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });
  });

  group('zero comparison (greater)', () {
    test('should return 1 when comparing to BigInteger', () {
      final value1 = Decimal(value: '0.1', precision: 1, scale: 1);
      final value2 = BigInteger(0);
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to Integer', () {
      final value1 = Decimal(value: '0.1', precision: 1, scale: 1);
      final value2 = Integer(0);
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to SmallInteger', () {
      final value1 = Decimal(value: '0.1', precision: 1, scale: 1);
      final value2 = SmallInteger(0);
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to int', () {
      final value1 = Decimal(value: '0.1', precision: 1, scale: 1);
      const value2 = 0;
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to integer-valued double', () {
      final value1 = Decimal(value: '0.1', precision: 1, scale: 1);
      const value2 = 0.0;
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to integer-valued Real', () {
      final value1 = Decimal(value: '0.1', precision: 1, scale: 1);
      final value2 = Real(0);
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to integer-valued DoublePrecision',
        () {
      final value1 = Decimal(value: '0.1', precision: 1, scale: 1);
      final value2 = DoublePrecision(0);
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to int Numeric', () {
      final value1 = Decimal(value: '0.1', precision: 1, scale: 1);
      final value2 = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to unconstrained int Numeric', () {
      final value1 = Decimal(value: '0.1', precision: 1, scale: 1);
      final value2 = Numeric(value: '0');
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to float Numeric', () {
      final value1 = Decimal(value: '0.1', precision: 1, scale: 1);
      final value2 = Numeric(value: '0.0', precision: 2, scale: 1);
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to unconstrained float Numeric', () {
      final value1 = Decimal(value: '0.1', precision: 1, scale: 1);
      final value2 = Numeric(value: '0.0');
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to int Decimal', () {
      final value1 = Decimal(value: '0.1', precision: 1, scale: 1);
      final value2 = Decimal(value: '0', precision: 1, scale: 0);
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to unconstrained int Decimal', () {
      final value1 = Decimal(value: '0.1', precision: 1, scale: 1);
      final value2 = Decimal(value: '0');
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to float Decimal', () {
      final value1 = Decimal(value: '0.1', precision: 1, scale: 1);
      final value2 = Decimal(value: '0.0', precision: 2, scale: 1);
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to unconstrained float Decimal', () {
      final value1 = Decimal(value: '0.1', precision: 1, scale: 1);
      final value2 = Decimal(value: '0.0');
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });
  });

  group('zero comparison (less)', () {
    test('should return -1 when comparing to BigInteger', () {
      final value1 = Decimal(value: '-0.1', precision: 1, scale: 1);
      final value2 = BigInteger(0);
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to Integer', () {
      final value1 = Decimal(value: '-0.1', precision: 1, scale: 1);
      final value2 = Integer(0);
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to SmallInteger', () {
      final value1 = Decimal(value: '-0.1', precision: 1, scale: 1);
      final value2 = SmallInteger(0);
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to int', () {
      final value1 = Decimal(value: '-0.1', precision: 1, scale: 1);
      const value2 = 0;
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to integer-valued double', () {
      final value1 = Decimal(value: '-0.1', precision: 1, scale: 1);
      const value2 = 0.0;
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to integer-valued Real', () {
      final value1 = Decimal(value: '-0.1', precision: 1, scale: 1);
      final value2 = Real(0);
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to integer-valued DoublePrecision',
        () {
      final value1 = Decimal(value: '-0.1', precision: 1, scale: 1);
      final value2 = DoublePrecision(0);
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to int Numeric', () {
      final value1 = Decimal(value: '-0.1', precision: 1, scale: 1);
      final value2 = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to unconstrained int Numeric', () {
      final value1 = Decimal(value: '-0.1', precision: 1, scale: 1);
      final value2 = Numeric(value: '0');
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to float Numeric', () {
      final value1 = Decimal(value: '-0.1', precision: 1, scale: 1);
      final value2 = Numeric(value: '0.0', precision: 2, scale: 1);
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to unconstrained float Numeric', () {
      final value1 = Decimal(value: '-0.1', precision: 1, scale: 1);
      final value2 = Numeric(value: '0.0');
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to int Decimal', () {
      final value1 = Decimal(value: '-0.1', precision: 1, scale: 1);
      final value2 = Decimal(value: '0', precision: 1, scale: 0);
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to unconstrained int Decimal', () {
      final value1 = Decimal(value: '-0.1', precision: 1, scale: 1);
      final value2 = Decimal(value: '0');
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to float Decimal', () {
      final value1 = Decimal(value: '-0.1', precision: 1, scale: 1);
      final value2 = Decimal(value: '0.0', precision: 2, scale: 1);
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to unconstrained float Decimal', () {
      final value1 = Decimal(value: '-0.1', precision: 1, scale: 1);
      final value2 = Decimal(value: '0.0');
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });
  });

  group('positive close proximity comparison (greater)', () {
    test('should return 1 when comparing to BigInteger', () {
      final value1 = Decimal(value: '0.00001', precision: 5, scale: 5);
      final value2 = BigInteger(0);
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to Integer', () {
      final value1 = Decimal(value: '0.00001', precision: 5, scale: 5);
      final value2 = Integer(0);
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to SmallInteger', () {
      final value1 = Decimal(value: '0.00001', precision: 5, scale: 5);
      final value2 = SmallInteger(0);
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to int', () {
      final value1 = Decimal(value: '0.00001', precision: 5, scale: 5);
      const value2 = 0;
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to integer-valued double', () {
      final value1 = Decimal(value: '0.00001', precision: 5, scale: 5);
      const value2 = 0.0;
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to integer-valued Real', () {
      final value1 = Decimal(value: '0.00001', precision: 5, scale: 5);
      final value2 = Real(0);
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to integer-valued DoublePrecision',
        () {
      final value1 = Decimal(value: '0.00001', precision: 5, scale: 5);
      final value2 = DoublePrecision(0);
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to int Numeric', () {
      final value1 = Decimal(value: '0.00001', precision: 5, scale: 5);
      final value2 = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to unconstrained int Numeric', () {
      final value1 = Decimal(value: '0.00001', precision: 5, scale: 5);
      final value2 = Numeric(value: '0');
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to float Numeric', () {
      final value1 = Decimal(value: '0.00001', precision: 5, scale: 5);
      final value2 = Numeric(value: '0.0', precision: 2, scale: 1);
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to unconstrained float Numeric', () {
      final value1 = Decimal(value: '0.00001', precision: 5, scale: 5);
      final value2 = Numeric(value: '0.0', precision: 2, scale: 1);
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to fractional Numeric', () {
      final value1 = Decimal(value: '0.00001', precision: 5, scale: 5);
      final value2 = Numeric(value: '0.0', precision: 1, scale: 1);
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to int Decimal', () {
      final value1 = Decimal(value: '0.00001', precision: 5, scale: 5);
      final value2 = Decimal(value: '0', precision: 1, scale: 0);
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to unconstrained int Decimal', () {
      final value1 = Decimal(value: '0.00001', precision: 5, scale: 5);
      final value2 = Decimal(value: '0');
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to float Decimal', () {
      final value1 = Decimal(value: '0.00001', precision: 5, scale: 5);
      final value2 = Decimal(value: '0.0', precision: 2, scale: 1);
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to unconstrained float Decimal', () {
      final value1 = Decimal(value: '0.00001', precision: 5, scale: 5);
      final value2 = Decimal(value: '0.0');
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });

    test('should return 1 when comparing to fractional Decimal', () {
      final value1 = Decimal(value: '0.00001', precision: 5, scale: 5);
      final value2 = Decimal(value: '0.0', precision: 1, scale: 1);
      final operation = value1.compareTo(value2);
      expect(operation, 1);
    });
  });

  group('negative close proximity comparison (less)', () {
    test('should return -1 when comparing to BigInteger', () {
      final value1 = Decimal(value: '-0.00001', precision: 5, scale: 5);
      final value2 = BigInteger(0);
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to Integer', () {
      final value1 = Decimal(value: '-0.00001', precision: 5, scale: 5);
      final value2 = Integer(0);
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to SmallInteger', () {
      final value1 = Decimal(value: '-0.00001', precision: 5, scale: 5);
      final value2 = SmallInteger(0);
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to int', () {
      final value1 = Decimal(value: '-0.00001', precision: 5, scale: 5);
      const value2 = 0;
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to integer-valued double', () {
      final value1 = Decimal(value: '-0.00001', precision: 5, scale: 5);
      const value2 = 0.0;
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to fractional double', () {
      final value1 = Decimal(value: '-0.00001', precision: 5, scale: 5);
      const value2 = 0.0;
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to integer-valued Real', () {
      final value1 = Decimal(value: '-0.00001', precision: 5, scale: 5);
      final value2 = Real(0.0);
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to fractional Real', () {
      final value1 = Decimal(value: '-0.00001', precision: 5, scale: 5);
      final value2 = Real(0.0);
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to integer-valued DoublePrecision',
        () {
      final value1 = Decimal(value: '-0.00001', precision: 5, scale: 5);
      final value2 = DoublePrecision(0.0);
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to fractional DoublePrecision', () {
      final value1 = Decimal(value: '-0.00001', precision: 5, scale: 5);
      final value2 = DoublePrecision(0.0);
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to int Numeric', () {
      final value1 = Decimal(value: '-0.00001', precision: 5, scale: 5);
      final value2 = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to unconstrained int Numeric', () {
      final value1 = Decimal(value: '-0.00001', precision: 5, scale: 5);
      final value2 = Numeric(value: '0');
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to float Numeric', () {
      final value1 = Decimal(value: '-0.00001', precision: 5, scale: 5);
      final value2 = Numeric(value: '0.0', precision: 2, scale: 1);
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to unconstrained float Numeric', () {
      final value1 = Decimal(value: '-0.00001', precision: 5, scale: 5);
      final value2 = Numeric(value: '0.0');
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to fractional Numeric', () {
      final value1 = Decimal(value: '-0.00001', precision: 5, scale: 5);
      final value2 = Numeric(value: '0.0', precision: 1, scale: 1);
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to int Decimal', () {
      final value1 = Decimal(value: '-0.00001', precision: 5, scale: 5);
      final value2 = Decimal(value: '0', precision: 1, scale: 0);
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to unconstrained int Decimal', () {
      final value1 = Decimal(value: '-0.00001', precision: 5, scale: 5);
      final value2 = Decimal(value: '0');
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to float Decimal', () {
      final value1 = Decimal(value: '-0.00001', precision: 5, scale: 5);
      final value2 = Decimal(value: '0.0', precision: 2, scale: 1);
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to unconstrained float Decimal', () {
      final value1 = Decimal(value: '-0.00001', precision: 5, scale: 5);
      final value2 = Decimal(value: '0.0');
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });

    test('should return -1 when comparing to fractional Decimal', () {
      final value1 = Decimal(value: '-0.00001', precision: 5, scale: 5);
      final value2 = Decimal(value: '0.0', precision: 1, scale: 1);
      final operation = value1.compareTo(value2);
      expect(operation, -1);
    });
  });

  group('positive close proximity comparison (equal)', () {
    test('should return 0 when comparing to fractional double', () {
      final value1 = Decimal(value: '0.99999', precision: 5, scale: 5);
      const value2 = 0.99999;
      final operation = value1.compareTo(value2);
      expect(operation, 0);
    });

    test('should return 0 when comparing to fractional Real', () {
      final value1 = Decimal(value: '0.99999', precision: 5, scale: 5);
      final value2 = Real(0.99999);
      final operation = value1.compareTo(value2);
      expect(operation, 0);
    });

    test('should return 0 when comparing to fractional DoublePrecision', () {
      final value1 = Decimal(value: '0.99999', precision: 5, scale: 5);
      final value2 = DoublePrecision(0.99999);
      final operation = value1.compareTo(value2);
      expect(operation, 0);
    });

    test('should return 0 when comparing to float Numeric', () {
      final value1 = Decimal(value: '0.99999', precision: 5, scale: 5);
      final value2 = Numeric(value: '0.99999', precision: 6, scale: 5);
      final operation = value1.compareTo(value2);
      expect(operation, 0);
    });

    test('should return 0 when comparing to unconstrained float Numeric', () {
      final value1 = Decimal(value: '0.99999', precision: 5, scale: 5);
      final value2 = Numeric(value: '0.99999');
      final operation = value1.compareTo(value2);
      expect(operation, 0);
    });

    test('should return 0 when comparing to fractional Numeric', () {
      final value1 = Decimal(value: '0.99999', precision: 5, scale: 5);
      final value2 = Numeric(value: '0.99999', precision: 5, scale: 5);
      final operation = value1.compareTo(value2);
      expect(operation, 0);
    });

    test('should return 0 when comparing to float Decimal', () {
      final value1 = Decimal(value: '0.99999', precision: 5, scale: 5);
      final value2 = Decimal(value: '0.99999', precision: 6, scale: 5);
      final operation = value1.compareTo(value2);
      expect(operation, 0);
    });

    test('should return 0 when comparing to unconstrained float Decimal', () {
      final value1 = Decimal(value: '0.99999', precision: 5, scale: 5);
      final value2 = Decimal(value: '0.99999');
      final operation = value1.compareTo(value2);
      expect(operation, 0);
    });

    test('should return 0 when comparing to fractional Decimal', () {
      final value1 = Decimal(value: '0.99999', precision: 5, scale: 5);
      final value2 = Decimal(value: '0.99999', precision: 5, scale: 5);
      final operation = value1.compareTo(value2);
      expect(operation, 0);
    });
  });

  group('negative close proximity comparison (equal)', () {
    test('should return 0 when comparing to fractional double', () {
      final value1 = Decimal(value: '-0.99999', precision: 5, scale: 5);
      const value2 = -0.99999;
      final operation = value1.compareTo(value2);
      expect(operation, 0);
    });

    test('should return 0 when comparing to fractional Real', () {
      final value1 = Decimal(value: '-0.99999', precision: 5, scale: 5);
      final value2 = Real(-0.99999);
      final operation = value1.compareTo(value2);
      expect(operation, 0);
    });

    test('should return 0 when comparing to fractional DoublePrecision', () {
      final value1 = Decimal(value: '-0.99999', precision: 5, scale: 5);
      final value2 = DoublePrecision(-0.99999);
      final operation = value1.compareTo(value2);
      expect(operation, 0);
    });

    test('should return 0 when comparing to float Numeric', () {
      final value1 = Decimal(value: '-0.99999', precision: 5, scale: 5);
      final value2 = Numeric(value: '-0.99999', precision: 6, scale: 5);
      final operation = value1.compareTo(value2);
      expect(operation, 0);
    });

    test('should return 0 when comparing to unconstrained float Numeric', () {
      final value1 = Decimal(value: '-0.99999', precision: 5, scale: 5);
      final value2 = Numeric(value: '-0.99999');
      final operation = value1.compareTo(value2);
      expect(operation, 0);
    });

    test('should return 0 when comparing to fractional Numeric', () {
      final value1 = Decimal(value: '-0.99999', precision: 5, scale: 5);
      final value2 = Numeric(value: '-0.99999', precision: 5, scale: 5);
      final operation = value1.compareTo(value2);
      expect(operation, 0);
    });

    test('should return 0 when comparing to float Decimal', () {
      final value1 = Decimal(value: '-0.99999', precision: 5, scale: 5);
      final value2 = Decimal(value: '-0.99999', precision: 6, scale: 5);
      final operation = value1.compareTo(value2);
      expect(operation, 0);
    });

    test('should return 0 when comparing to unconstrained float Decimal', () {
      final value1 = Decimal(value: '-0.99999', precision: 5, scale: 5);
      final value2 = Decimal(value: '-0.99999');
      final operation = value1.compareTo(value2);
      expect(operation, 0);
    });

    test('should return 0 when comparing to fractional Decimal', () {
      final value1 = Decimal(value: '-0.99999', precision: 5, scale: 5);
      final value2 = Decimal(value: '-0.99999', precision: 5, scale: 5);
      final operation = value1.compareTo(value2);
      expect(operation, 0);
    });
  });

  group('zero cases', () {
    test(
        'should return 0 when comparing positive zero to negative Decimal zero',
        () {
      final value1 = Decimal(value: '0.0', precision: 1, scale: 1);
      final value2 = Decimal(value: '-0.0', precision: 1, scale: 1);
      final operation = value1.compareTo(value2);
      expect(operation, 0);
    });

    test(
        'should return 0 when comparing positive zero to negative Numeric zero',
        () {
      final value1 = Decimal(value: '0.0', precision: 1, scale: 1);
      final value2 = Numeric(value: '-0.0', precision: 1, scale: 1);
      final operation = value1.compareTo(value2);
      expect(operation, 0);
    });

    test(
        'should return 0 when comparing negative zero to positive Decimal zero',
        () {
      final value1 = Decimal(value: '-0.0', precision: 1, scale: 1);
      final value2 = Decimal(value: '0.0', precision: 1, scale: 1);
      final operation = value1.compareTo(value2);
      expect(operation, 0);
    });

    test(
        'should return 0 when comparing negative zero to positive Numeric zero',
        () {
      final value1 = Decimal(value: '-0.0', precision: 1, scale: 1);
      final value2 = Numeric(value: '0.0', precision: 1, scale: 1);
      final operation = value1.compareTo(value2);
      expect(operation, 0);
    });
  });

  group('general errors', () {
    test('should throw ArgumentError if value is NaN', () {
      final value1 = Decimal(value: '0.3', precision: 1, scale: 1);
      const value2 = double.nan;
      expect(() => value1.compareTo(value2), throwsArgumentError);
    });

    test('should throw ArgumentError if value is infinity', () {
      final value1 = Decimal(value: '0.3', precision: 1, scale: 1);
      const value2 = double.infinity;
      expect(() => value1.compareTo(value2), throwsArgumentError);
    });

    test('should throw ArgumentError if value is negative infinity', () {
      final value1 = Decimal(value: '0.3', precision: 1, scale: 1);
      const value2 = double.negativeInfinity;
      expect(() => value1.compareTo(value2), throwsArgumentError);
    });

    test('should throw ArgumentError if value is unsupported', () {
      final value1 = Decimal(value: '0.3', precision: 1, scale: 1);
      final value2 = DateTime(2022);
      expect(() => value1.compareTo(value2), throwsArgumentError);
    });
  });
}
