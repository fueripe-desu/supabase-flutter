import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/floating_point_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
// Tests if compareTo() method works correctly with positive parameters.
//
// This test group evaluates the correctness of the compareTo() method when used with
// positive parameters across all supported data types in PostgreSQL. The primary focus
// is on verifying the correct result of comparisons and ensuring that they execute
// successfully without errors or unexpected behavior for each data type.
//
// Observations:
// - Tests exclude the 0 and -1 results for [fractional arbitrary types] since an [Integer type]
// cannot be positive and simultaneously less than or equal to a [fractional arbitrary type].
// For example, with Numeric(value: '0.35', precision: 2, scale: 2), no positive integer can
// equate to or be less than this fractional value. Thus, such scenarios are not tested.
  group('positive comparison', () {
    test('should return 0 if value is equal to BigInteger', () {
      expect(SmallSerial(20).compareTo(BigInteger(20)), 0);
    });

    test('should return -1 if value is less than BigInteger', () {
      expect(SmallSerial(20).compareTo(BigInteger(30)), -1);
    });

    test('should return 1 if value is greater than BigInteger', () {
      expect(SmallSerial(40).compareTo(BigInteger(30)), 1);
    });

    test('should return 0 if value is equal to Integer', () {
      expect(SmallSerial(20).compareTo(Integer(20)), 0);
    });

    test('should return -1 if value is less than Integer', () {
      expect(SmallSerial(20).compareTo(Integer(30)), -1);
    });

    test('should return 1 if value is greater than Integer', () {
      expect(SmallSerial(40).compareTo(Integer(30)), 1);
    });

    test('should return 0 if value is equal to SmallInteger', () {
      expect(SmallSerial(20).compareTo(SmallInteger(20)), 0);
    });

    test('should return -1 if value is less than SmallInteger', () {
      expect(SmallSerial(20).compareTo(SmallInteger(30)), -1);
    });

    test('should return 1 if value is greter SmallInteger', () {
      expect(SmallSerial(40).compareTo(SmallInteger(30)), 1);
    });

    test('should return 0 if value is equal to BigSerial', () {
      expect(SmallSerial(20).compareTo(BigSerial(20)), 0);
    });

    test('should return -1 if value is less than BigSerial', () {
      expect(SmallSerial(20).compareTo(BigSerial(30)), -1);
    });

    test('should return 1 if value is greater than BigSerial', () {
      expect(SmallSerial(40).compareTo(BigSerial(30)), 1);
    });

    test('should return 0 if value is equal to Serial', () {
      expect(SmallSerial(20).compareTo(Serial(20)), 0);
    });

    test('should return -1 if value is less than Serial', () {
      expect(SmallSerial(20).compareTo(Serial(30)), -1);
    });

    test('should return 1 if value is greater than Serial', () {
      expect(SmallSerial(40).compareTo(Serial(30)), 1);
    });

    test('should return 0 if value is equal to SmallSerial', () {
      expect(SmallSerial(20).compareTo(SmallSerial(20)), 0);
    });

    test('should return -1 if value is less than SmallSerial', () {
      expect(SmallSerial(20).compareTo(SmallSerial(30)), -1);
    });

    test('should return 1 if value is greater than SmallSerial', () {
      expect(SmallSerial(40).compareTo(SmallSerial(30)), 1);
    });

    test('should return 0 if value is equal to int primitive', () {
      expect(SmallSerial(20).compareTo(20), 0);
    });

    test('should return -1 if value is less than int primitive', () {
      expect(SmallSerial(20).compareTo(30), -1);
    });

    test('should return 1 if value is greater than int primitive', () {
      expect(SmallSerial(40).compareTo(30), 1);
    });

    test('should return 0 if value is equal to double primitive', () {
      expect(SmallSerial(20).compareTo(20.0), 0);
    });

    test('should return -1 if value is less than double primitive', () {
      expect(SmallSerial(20).compareTo(20.5), -1);
    });

    test('should return 1 if value is greater than double primitive', () {
      expect(SmallSerial(40).compareTo(20.5), 1);
    });

    test('should return 0 if value is lexicographically equal to string', () {
      expect(SmallSerial(20).compareTo('20'), 0);
    });

    test('should return -1 if value is lexicographically less than string', () {
      expect(SmallSerial(20).compareTo('sample'), -1);
    });

    test('should return 1 if value is lexicographically greater than string',
        () {
      expect(SmallSerial(200).compareTo('199'), 1);
    });

    test('should return 0 if value is equal to Real', () {
      expect(SmallSerial(20).compareTo(Real(20)), 0);
    });

    test('should return -1 if value is less than Real', () {
      expect(SmallSerial(20).compareTo(Real(30)), -1);
    });

    test('should return 1 if value is greater than Real', () {
      expect(SmallSerial(40).compareTo(Real(30)), 1);
    });

    test('should return 0 if value is equal to DoublePrecision', () {
      expect(SmallSerial(20).compareTo(DoublePrecision(20)), 0);
    });

    test('should return -1 if value is less than DoublePrecision', () {
      expect(SmallSerial(20).compareTo(DoublePrecision(30)), -1);
    });

    test('should return 1 if value is greater than DoublePrecision', () {
      expect(SmallSerial(40).compareTo(DoublePrecision(30)), 1);
    });

    test('should return 0 if value is equal to int Numeric', () {
      final numeric = Numeric(value: '20', precision: 2, scale: 0);
      expect(SmallSerial(20).compareTo(numeric), 0);
    });

    test('should return -1 if value is less than int Numeric', () {
      final numeric = Numeric(value: '30', precision: 2, scale: 0);
      expect(SmallSerial(20).compareTo(numeric), -1);
    });

    test('should return 1 if value is greater than int Numeric', () {
      final numeric = Numeric(value: '30', precision: 2, scale: 0);
      expect(SmallSerial(40).compareTo(numeric), 1);
    });

    test('should return 0 if value is equal to unconstrained int Numeric', () {
      final numeric = Numeric(value: '20');
      expect(SmallSerial(20).compareTo(numeric), 0);
    });

    test('should return -1 if value is less than unconstrained int Numeric',
        () {
      final numeric = Numeric(value: '30');
      expect(SmallSerial(20).compareTo(numeric), -1);
    });

    test('should return 1 if value is greater than unconstrained int Numeric',
        () {
      final numeric = Numeric(value: '30');
      expect(SmallSerial(40).compareTo(numeric), 1);
    });

    test('should return 0 if value is equal to float Numeric', () {
      final numeric = Numeric(value: '20.0', precision: 3, scale: 1);
      expect(SmallSerial(20).compareTo(numeric), 0);
    });

    test('should return -1 if value is less than float Numeric', () {
      final numeric = Numeric(value: '30.5', precision: 3, scale: 1);
      expect(SmallSerial(20).compareTo(numeric), -1);
    });

    test('should return 1 if value is greater than float Numeric', () {
      final numeric = Numeric(value: '30.5', precision: 3, scale: 1);
      expect(SmallSerial(40).compareTo(numeric), 1);
    });

    test('should return 0 if value is equal to unconstrained float Numeric',
        () {
      final numeric = Numeric(value: '20.0');
      expect(SmallSerial(20).compareTo(numeric), 0);
    });

    test('should return -1 if value is less than unconstrained float Numeric',
        () {
      final numeric = Numeric(value: '30.5');
      expect(SmallSerial(20).compareTo(numeric), -1);
    });

    test('should return 1 if value is greater than unconstrained float Numeric',
        () {
      final numeric = Numeric(value: '30.5');
      expect(SmallSerial(40).compareTo(numeric), 1);
    });

    test('should return 1 if value is greater than fractional Numeric', () {
      final numeric = Numeric(value: '0.35', precision: 2, scale: 2);
      expect(SmallSerial(40).compareTo(numeric), 1);
    });

    test('should return 0 if value is equal to int Decimal', () {
      final decimal = Decimal(value: '20', precision: 2, scale: 0);
      expect(SmallSerial(20).compareTo(decimal), 0);
    });

    test('should return -1 if value is less than int Decimal', () {
      final decimal = Decimal(value: '30', precision: 2, scale: 0);
      expect(SmallSerial(20).compareTo(decimal), -1);
    });

    test('should return 1 if value is greater than int Decimal', () {
      final decimal = Decimal(value: '30', precision: 2, scale: 0);
      expect(SmallSerial(40).compareTo(decimal), 1);
    });

    test('should return 0 if value is equal to unconstrained int Decimal', () {
      final decimal = Decimal(value: '20');
      expect(SmallSerial(20).compareTo(decimal), 0);
    });

    test('should return -1 if value is less than unconstrained int Decimal',
        () {
      final decimal = Decimal(value: '30');
      expect(SmallSerial(20).compareTo(decimal), -1);
    });

    test('should return 1 if value is greater than unconstrained int Decimal',
        () {
      final decimal = Decimal(value: '30');
      expect(SmallSerial(40).compareTo(decimal), 1);
    });

    test('should return 0 if value is equal to float Decimal', () {
      final decimal = Decimal(value: '20.0', precision: 3, scale: 1);
      expect(SmallSerial(20).compareTo(decimal), 0);
    });

    test('should return -1 if value is less than float Decimal', () {
      final decimal = Decimal(value: '30.5', precision: 3, scale: 1);
      expect(SmallSerial(20).compareTo(decimal), -1);
    });

    test('should return 1 if value is greater than float Decimal', () {
      final decimal = Decimal(value: '30.5', precision: 3, scale: 1);
      expect(SmallSerial(40).compareTo(decimal), 1);
    });

    test('should return 0 if value is equal to unconstrained float Decimal',
        () {
      final decimal = Decimal(value: '20.0');
      expect(SmallSerial(20).compareTo(decimal), 0);
    });

    test('should return -1 if value is less than unconstrained float Decimal',
        () {
      final decimal = Decimal(value: '30.5');
      expect(SmallSerial(20).compareTo(decimal), -1);
    });

    test('should return 1 if value is greater than unconstrained float Decimal',
        () {
      final decimal = Decimal(value: '30.5');
      expect(SmallSerial(40).compareTo(decimal), 1);
    });

    test('should return 1 if value is greater than fractional Decimal', () {
      final decimal = Decimal(value: '0.35', precision: 2, scale: 2);
      expect(SmallSerial(40).compareTo(decimal), 1);
    });
  });

// Tests if compareTo() method works correctly with the first parameter being positive
// and the second parameter being negative.
//
// This test group evaluates the correctness of the compareTo() method when used with
// mixed sign parameters across all supported data types in PostgreSQL. The primary
// focus is on verifying the correct result of comparisons and ensuring that they
// execute successfully without errors or unexpected behavior for each data type.
//
// Observations:
// - Tests exclude the 0 and -1 results because a positive value is always greater
// than a negative one, in every scenario.
//
// - [Serial types] are excluded from this test group because their minimum {value}
// is 1, and they cannot store negative values.
//
// - There are no tests with strings because there is no need to tests lexicographical
// comparison in such scenarios.
  group('mixed sign comparison (positive + negative)', () {
    test('should return 1 if value is greater than BigInteger', () {
      expect(SmallSerial(40).compareTo(BigInteger(-30)), 1);
    });

    test('should return 1 if value is greater than Integer', () {
      expect(SmallSerial(40).compareTo(Integer(-30)), 1);
    });

    test('should return 1 if value is greater than SmallInteger', () {
      expect(SmallSerial(40).compareTo(SmallInteger(-30)), 1);
    });

    test('should return 1 if value is greater than int primitive', () {
      expect(SmallSerial(40).compareTo(-30), 1);
    });

    test('should return 1 if value is greater than double primitive', () {
      expect(SmallSerial(40).compareTo(-20.5), 1);
    });

    test('should return 1 if value is greater than Real', () {
      expect(SmallSerial(40).compareTo(Real(-30)), 1);
    });

    test('should return 1 if value is greater than DoublePrecision', () {
      expect(SmallSerial(40).compareTo(DoublePrecision(-30)), 1);
    });

    test('should return 1 if value is greater than int Numeric', () {
      final numeric = Numeric(value: '-30', precision: 2, scale: 0);
      expect(SmallSerial(40).compareTo(numeric), 1);
    });

    test('should return 1 if value is greater than unconstrained int Numeric',
        () {
      final numeric = Numeric(value: '-30');
      expect(SmallSerial(40).compareTo(numeric), 1);
    });

    test('should return 1 if value is greater than float Numeric', () {
      final numeric = Numeric(value: '-30.5', precision: 3, scale: 1);
      expect(SmallSerial(40).compareTo(numeric), 1);
    });

    test('should return 1 if value is greater than unconstrained float Numeric',
        () {
      final numeric = Numeric(value: '-30.5');
      expect(SmallSerial(40).compareTo(numeric), 1);
    });

    test('should return 1 if value is greater than fractional Numeric', () {
      final numeric = Numeric(value: '-0.35', precision: 2, scale: 2);
      expect(SmallSerial(40).compareTo(numeric), 1);
    });

    test('should return 1 if value is greater than int Decimal', () {
      final decimal = Decimal(value: '-30', precision: 2, scale: 0);
      expect(SmallSerial(40).compareTo(decimal), 1);
    });

    test('should return 1 if value is greater than unconstrained int Decimal',
        () {
      final decimal = Decimal(value: '-30');
      expect(SmallSerial(40).compareTo(decimal), 1);
    });

    test('should return 1 if value is greater than float Decimal', () {
      final decimal = Decimal(value: '-30.5', precision: 3, scale: 1);
      expect(SmallSerial(40).compareTo(decimal), 1);
    });

    test('should return 1 if value is greater than unconstrained float Decimal',
        () {
      final decimal = Decimal(value: '-30.5');
      expect(SmallSerial(40).compareTo(decimal), 1);
    });

    test('should return 1 if value is greater than fractional Decimal', () {
      final decimal = Decimal(value: '-0.35', precision: 2, scale: 2);
      expect(SmallSerial(40).compareTo(decimal), 1);
    });
  });

  group('general errors', () {
    test('should throw ArgumentError if compared to an unsupported value', () {
      expect(
        () => SmallSerial(20).compareTo(DateTime(2022)),
        throwsArgumentError,
      );
    });
  });
}
