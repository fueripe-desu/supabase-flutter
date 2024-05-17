import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/floating_point_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
  group('positive comparison (greater)', () {
    test('should return false when comparing to BigInteger', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = BigInteger(10);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to Integer', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = Integer(10);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to SmallInteger', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = SmallInteger(10);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to BigSerial', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = BigSerial(10);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to Serial', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = Serial(10);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to SmallSerial', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = SmallSerial(10);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to int', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      const value2 = 10;
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to integer-valued double', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      const value2 = 10.0;
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to fractional double', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      const value2 = 10.3;
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to integer-valued Real', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = Real(10);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to fractional Real', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = Real(10.3);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to integer-valued DoublePrecision',
        () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = DoublePrecision(10);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to fractional DoublePrecision',
        () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = DoublePrecision(10.3);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to int Numeric', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = Numeric(value: '10', precision: 2, scale: 0);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to unconstrained int Numeric', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = Numeric(value: '10');
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to float Numeric', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = Numeric(value: '10.3', precision: 3, scale: 1);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to unconstrained float Numeric',
        () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = Numeric(value: '10.3');
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to int Decimal', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = Decimal(value: '10', precision: 2, scale: 0);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to unconstrained int Decimal', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = Decimal(value: '10');
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to float Decimal', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = Decimal(value: '10.3', precision: 3, scale: 1);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to unconstrained float Decimal',
        () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = Decimal(value: '10.3');
      final operation = value1 <= value2;
      expect(operation, false);
    });
  });

  group('positive comparison (less)', () {
    test('should return true when comparing to BigInteger', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = BigInteger(30);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to Integer', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = Integer(30);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to SmallInteger', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = SmallInteger(30);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to BigSerial', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = BigSerial(30);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to Serial', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = Serial(30);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to SmallSerial', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = SmallSerial(30);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to int', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      const value2 = 30;
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to integer-valued double', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      const value2 = 30.0;
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to fractional double', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      const value2 = 30.0;
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to integer-valued Real', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = Real(30);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to fractional Real', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = Real(30.3);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to integer-valued DoublePrecision',
        () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = DoublePrecision(30);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to fractional DoublePrecision', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = DoublePrecision(30.3);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to int Numeric', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = Numeric(value: '30', precision: 2, scale: 0);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to unconstrained int Numeric', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = Numeric(value: '30');
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to float Numeric', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = Numeric(value: '30.3', precision: 3, scale: 1);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to unconstrained float Numeric',
        () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = Numeric(value: '30.3');
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to int Decimal', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = Decimal(value: '30', precision: 2, scale: 0);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to unconstrained int Decimal', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = Decimal(value: '30');
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to float Decimal', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = Decimal(value: '30.3', precision: 3, scale: 1);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to unconstrained float Decimal',
        () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = Decimal(value: '30.3');
      final operation = value1 <= value2;
      expect(operation, true);
    });
  });

  group('positive comparison (equal)', () {
    test('should return true when comparing to BigInteger', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = BigInteger(20);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to Integer', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = Integer(20);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to SmallInteger', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = SmallInteger(20);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to BigSerial', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = BigSerial(20);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to Serial', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = Serial(20);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to SmallSerial', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = SmallSerial(20);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to int', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      const value2 = 20;
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to integer-valued double', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      const value2 = 20.0;
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to integer-valued Real', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = Real(20);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to integer-valued DoublePrecision',
        () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = DoublePrecision(20);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to int Numeric', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = Numeric(value: '20', precision: 2, scale: 0);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to unconstrained int Numeric', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = Numeric(value: '20');
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to int Decimal', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = Decimal(value: '20', precision: 2, scale: 0);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to unconstrained int Decimal', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = Decimal(value: '20');
      final operation = value1 <= value2;
      expect(operation, true);
    });
  });

  group('negative comparison (greater)', () {
    test('should return false when comparing to BigInteger', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = BigInteger(-30);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to Integer', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = Integer(-30);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to SmallInteger', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = SmallInteger(-30);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to int', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      const value2 = -30;
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to integer-valued double', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      const value2 = -30.0;
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to fractional double', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      const value2 = -30.3;
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to integer-valued Real', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = Real(-30);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to fractional Real', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = Real(-30.3);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to integer-valued DoublePrecision',
        () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = DoublePrecision(-30);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to fractional DoublePrecision',
        () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = DoublePrecision(-30.3);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to int Numeric', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = Numeric(value: '-30', precision: 2, scale: 0);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to unconstrained int Numeric', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = Numeric(value: '-30');
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to float Numeric', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = Numeric(value: '-30.3', precision: 3, scale: 1);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to unconstrained float Numeric',
        () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = Numeric(value: '-30.3');
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to int Decimal', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = Decimal(value: '-30', precision: 2, scale: 0);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to unconstrained int Decimal', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = Decimal(value: '-30');
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to float Decimal', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = Decimal(value: '-30.3', precision: 3, scale: 1);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to unconstrained float Decimal',
        () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = Decimal(value: '-30.3');
      final operation = value1 <= value2;
      expect(operation, false);
    });
  });

  group('negative comparison (less)', () {
    test('should return true when comparing to BigInteger', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = BigInteger(-10);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to Integer', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = Integer(-10);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to SmallInteger', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = SmallInteger(-10);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to int', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      const value2 = -10;
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to integer-valued double', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      const value2 = -10.0;
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to fractional double', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      const value2 = -10.3;
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to integer-valued Real', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = Real(-10);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to fractional Real', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = Real(-10.3);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to integer-valued DoublePrecision',
        () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = DoublePrecision(-10);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to fractional DoublePrecision', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = DoublePrecision(-10.3);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to int Numeric', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = Numeric(value: '-10', precision: 2, scale: 0);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to unconstrained int Numeric', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = Numeric(value: '-10');
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to float Numeric', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = Numeric(value: '-10.3', precision: 3, scale: 1);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to unconstrained float Numeric',
        () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = Numeric(value: '-10.3');
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to int Decimal', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = Decimal(value: '-10', precision: 2, scale: 0);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to unconstrained int Decimal', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = Decimal(value: '-10');
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to float Decimal', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = Decimal(value: '-10.3', precision: 3, scale: 1);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to unconstrained float Decimal',
        () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = Decimal(value: '-10.3');
      final operation = value1 <= value2;
      expect(operation, true);
    });
  });

  group('negative comparison (equal)', () {
    test('should return true when comparing to BigInteger', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = BigInteger(-20);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to Integer', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = Integer(-20);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to SmallInteger', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = SmallInteger(-20);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to int', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      const value2 = -20;
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to integer-valued double', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      const value2 = -20.0;
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to fractional double', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      const value2 = -20.0;
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to integer-valued Real', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = Real(-20);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to integer-valued DoublePrecision',
        () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = DoublePrecision(-20);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to int Numeric', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = Numeric(value: '-20', precision: 2, scale: 0);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to unconstrained int Numeric', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = Numeric(value: '-20');
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to int Decimal', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = Decimal(value: '-20', precision: 2, scale: 0);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to unconstrained int Decimal', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = Decimal(value: '-20');
      final operation = value1 <= value2;
      expect(operation, true);
    });
  });

  group('mixed sign comparison (positive + negative)', () {
    test('should return false when comparing to BigInteger', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = BigInteger(-10);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to Integer', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = Integer(-10);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to SmallInteger', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = SmallInteger(-10);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to int', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      const value2 = -10;
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to integer-valued double', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      const value2 = -10.0;
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to fractional double', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      const value2 = -10.3;
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to integer-valued Real', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = Real(-10);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to fractional Real', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = Real(-10.3);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to integer-valued DoublePrecision',
        () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = DoublePrecision(-10);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to fractional DoublePrecision',
        () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = DoublePrecision(-10.3);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to int Numeric', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = Numeric(value: '-10', precision: 2, scale: 0);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to unconstrained int Numeric', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = Numeric(value: '-10');
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to float Numeric', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = Numeric(value: '-10.3', precision: 3, scale: 1);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to unconstrained float Numeric',
        () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = Numeric(value: '-10.3');
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to int Decimal', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = Decimal(value: '-10', precision: 2, scale: 0);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to unconstrained int Decimal', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = Decimal(value: '-10');
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to float Decimal', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = Decimal(value: '-10.3', precision: 3, scale: 1);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to unconstrained float Decimal',
        () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = Decimal(value: '-10.3');
      final operation = value1 <= value2;
      expect(operation, false);
    });
  });

  group('mixed sign comparison (negative + positive)', () {
    test('should return true when comparing to BigInteger', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = BigInteger(10);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to Integer', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = Integer(10);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to SmallInteger', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = SmallInteger(10);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to BigSerial', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = BigSerial(10);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to Serial', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = Serial(10);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to SmallSerial', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = SmallSerial(10);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to int', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      const value2 = 10;
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to integer-valued double', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      const value2 = 10.0;
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to fractional double', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      const value2 = 10.3;
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to integer-valued Real', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = Real(10);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to fractional Real', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = Real(10.3);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to integer-valued DoublePrecision',
        () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = DoublePrecision(10);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to fractional DoublePrecision', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = DoublePrecision(10.3);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to int Numeric', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = Numeric(value: '10', precision: 2, scale: 0);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to unconstrained int Numeric', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = Numeric(value: '10');
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to float Numeric', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = Numeric(value: '10.3', precision: 3, scale: 1);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to unconstrained float Numeric',
        () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = Numeric(value: '10.3');
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to int Decimal', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = Decimal(value: '10', precision: 2, scale: 0);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to unconstrained int Decimal', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = Decimal(value: '10');
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to float Decimal', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = Decimal(value: '10.3', precision: 3, scale: 1);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to unconstrained float Decimal',
        () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = Decimal(value: '10.3');
      final operation = value1 <= value2;
      expect(operation, true);
    });
  });

  group('zero comparison (greater)', () {
    test('should return false when comparing to BigInteger', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = BigInteger(0);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to Integer', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = Integer(0);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to SmallInteger', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = SmallInteger(0);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to int', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      const value2 = 0;
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to integer-valued double', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      const value2 = 0.0;
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to integer-valued Real', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = Real(0);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to integer-valued DoublePrecision',
        () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = DoublePrecision(0);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to int Numeric', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = Numeric(value: '0', precision: 2, scale: 0);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to unconstrained int Numeric', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = Numeric(value: '0');
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to float Numeric', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = Numeric(value: '0.0', precision: 3, scale: 1);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to unconstrained float Numeric',
        () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = Numeric(value: '0.3');
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to int Decimal', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = Decimal(value: '0', precision: 2, scale: 0);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to unconstrained int Decimal', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = Decimal(value: '0');
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to float Decimal', () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = Decimal(value: '0.0', precision: 3, scale: 1);
      final operation = value1 <= value2;
      expect(operation, false);
    });

    test('should return false when comparing to unconstrained float Decimal',
        () {
      final value1 = Decimal(value: '24', precision: 2, scale: -1);
      final value2 = Decimal(value: '0.0');
      final operation = value1 <= value2;
      expect(operation, false);
    });
  });

  group('zero comparison (less)', () {
    test('should return true when comparing to BigInteger', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = BigInteger(0);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to Integer', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = Integer(0);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to SmallInteger', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = SmallInteger(0);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to int', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      const value2 = 0;
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to integer-valued double', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      const value2 = 0.0;
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to integer-valued Real', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = Real(0);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to integer-valued DoublePrecision',
        () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = DoublePrecision(0);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to int Numeric', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = Numeric(value: '0', precision: 2, scale: 0);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to unconstrained int Numeric', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = Numeric(value: '0');
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to float Numeric', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = Numeric(value: '0.0', precision: 3, scale: 1);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to unconstrained float Numeric',
        () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = Numeric(value: '0.3');
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to int Decimal', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = Decimal(value: '0', precision: 2, scale: 0);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to unconstrained int Decimal', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = Decimal(value: '0');
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to float Decimal', () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = Decimal(value: '0.0', precision: 3, scale: 1);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to unconstrained float Decimal',
        () {
      final value1 = Decimal(value: '-24', precision: 2, scale: -1);
      final value2 = Decimal(value: '0.0');
      final operation = value1 <= value2;
      expect(operation, true);
    });
  });

  group('zero comparison (equal)', () {
    test('should return true when comparing to BigInteger', () {
      final value1 = Decimal(value: '14', precision: 2, scale: -3);
      final value2 = BigInteger(0);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to Integer', () {
      final value1 = Decimal(value: '14', precision: 2, scale: -3);
      final value2 = Integer(0);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to SmallInteger', () {
      final value1 = Decimal(value: '14', precision: 2, scale: -3);
      final value2 = SmallInteger(0);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to int', () {
      final value1 = Decimal(value: '14', precision: 2, scale: -3);
      const value2 = 0;
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to integer-valued double', () {
      final value1 = Decimal(value: '14', precision: 2, scale: -3);
      const value2 = 0.0;
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to integer-valued Real', () {
      final value1 = Decimal(value: '14', precision: 2, scale: -3);
      final value2 = Real(0);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to integer-valued DoublePrecision',
        () {
      final value1 = Decimal(value: '14', precision: 2, scale: -3);
      final value2 = DoublePrecision(0);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to int Numeric', () {
      final value1 = Decimal(value: '14', precision: 2, scale: -3);
      final value2 = Numeric(value: '0', precision: 2, scale: 0);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to unconstrained int Numeric', () {
      final value1 = Decimal(value: '14', precision: 2, scale: -3);
      final value2 = Numeric(value: '0');
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to float Numeric', () {
      final value1 = Decimal(value: '14', precision: 2, scale: -3);
      final value2 = Numeric(value: '0.0', precision: 3, scale: 1);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to unconstrained float Numeric',
        () {
      final value1 = Decimal(value: '14', precision: 2, scale: -3);
      final value2 = Numeric(value: '0.0');
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to int Decimal', () {
      final value1 = Decimal(value: '14', precision: 2, scale: -3);
      final value2 = Decimal(value: '0', precision: 2, scale: 0);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to unconstrained int Decimal', () {
      final value1 = Decimal(value: '14', precision: 2, scale: -3);
      final value2 = Decimal(value: '0');
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to float Decimal', () {
      final value1 = Decimal(value: '14', precision: 2, scale: -3);
      final value2 = Decimal(value: '0.0', precision: 3, scale: 1);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test('should return true when comparing to unconstrained float Decimal',
        () {
      final value1 = Decimal(value: '14', precision: 2, scale: -3);
      final value2 = Decimal(value: '0.0');
      final operation = value1 <= value2;
      expect(operation, true);
    });
  });

  group('zero cases', () {
    test(
        'should return true when comparing positive zero to negative Decimal zero',
        () {
      final value1 = Decimal(value: '14', precision: 2, scale: -3);
      final value2 = Decimal(value: '-14', precision: 2, scale: -3);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test(
        'should return true when comparing positive zero to negative Numeric zero',
        () {
      final value1 = Decimal(value: '14', precision: 2, scale: -3);
      final value2 = Numeric(value: '-14', precision: 2, scale: -3);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test(
        'should return true when comparing negative zero to positive Decimal zero',
        () {
      final value1 = Decimal(value: '-14', precision: 2, scale: -3);
      final value2 = Decimal(value: '14', precision: 2, scale: -3);
      final operation = value1 <= value2;
      expect(operation, true);
    });

    test(
        'should return true when comparing negative zero to positive Numeric zero',
        () {
      final value1 = Decimal(value: '-14', precision: 2, scale: -3);
      final value2 = Numeric(value: '14', precision: 2, scale: -3);
      final operation = value1 <= value2;
      expect(operation, true);
    });
  });

  group('general errors', () {
    test('should throw ArgumentError if value is NaN', () {
      final value1 = Decimal(value: '14', precision: 2, scale: -1);
      const value2 = double.nan;
      expect(() => value1 <= value2, throwsArgumentError);
    });

    test('should throw ArgumentError if value is infinity', () {
      final value1 = Decimal(value: '14', precision: 2, scale: -1);
      const value2 = double.infinity;
      expect(() => value1 <= value2, throwsArgumentError);
    });

    test('should throw ArgumentError if value is negative infinity', () {
      final value1 = Decimal(value: '14', precision: 2, scale: -1);
      const value2 = double.negativeInfinity;
      expect(() => value1 <= value2, throwsArgumentError);
    });

    test('should throw ArgumentError if value is unsupported', () {
      final value1 = Decimal(value: '14', precision: 2, scale: -1);
      final value2 = DateTime(2022);
      expect(() => value1 <= value2, throwsArgumentError);
    });
  });
}
