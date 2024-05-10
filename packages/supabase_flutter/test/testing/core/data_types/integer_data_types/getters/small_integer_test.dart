import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
  group('bitCount getter', () {
    test('should return the maximum amount of bits', () {
      final value = SmallInteger(22);
      expect(value.bitCount, 16);
    });
  });

  group('bitLength getter', () {
    test('should return the minimum amount of bits required', () {
      final value = SmallInteger(22);
      expect(value.bitLength, 5);
    });

    test('should not count the sign bit', () {
      final value = SmallInteger(-1);
      expect(value.bitLength, 0);
    });
  });

  group('sign getter', () {
    test('should return 1 if value is positive', () {
      final value = SmallInteger(22);
      expect(value.sign, 1);
    });

    test('should return 10 if value is zero', () {
      final value = SmallInteger(0);
      expect(value.sign, 0);
    });

    test('should return -1 if value is negative', () {
      final value = SmallInteger(-10);
      expect(value.sign, -1);
    });
  });

  group('isEven getter', () {
    test('should return true if value is even', () {
      final value = SmallInteger(22);
      expect(value.isEven, true);
    });

    test('should return false if value is odd', () {
      final value = SmallInteger(21);
      expect(value.isEven, false);
    });
  });

  group('isOdd getter', () {
    test('should return true if value is odd', () {
      final value = SmallInteger(21);
      expect(value.isOdd, true);
    });

    test('should return false if value is even', () {
      final value = SmallInteger(22);
      expect(value.isOdd, false);
    });
  });

  group('isNegative', () {
    test('should return false if value is positive', () {
      final value = SmallInteger(22);
      expect(value.isNegative, false);
    });

    test('should return false if value is zero', () {
      final value = SmallInteger(0);
      expect(value.isNegative, false);
    });

    test('should return true if value is negative', () {
      final value = SmallInteger(-10);
      expect(value.isNegative, true);
    });
  });
}
