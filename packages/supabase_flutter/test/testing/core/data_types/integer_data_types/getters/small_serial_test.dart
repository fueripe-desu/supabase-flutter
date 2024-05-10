import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
  group('bitCount getter', () {
    test('should return the maximum amount of bits', () {
      final value = SmallSerial(22);
      expect(value.bitCount, 16);
    });
  });

  group('bitLength getter', () {
    test('should return the minimum amount of bits required', () {
      final value = SmallSerial(22);
      expect(value.bitLength, 5);
    });
  });

  group('sign getter', () {
    test('should return 1 if value is positive', () {
      final value = SmallSerial(22);
      expect(value.sign, 1);
    });
  });

  group('isEven getter', () {
    test('should return true if value is even', () {
      final value = SmallSerial(22);
      expect(value.isEven, true);
    });

    test('should return false if value is odd', () {
      final value = SmallSerial(21);
      expect(value.isEven, false);
    });
  });

  group('isOdd getter', () {
    test('should return true if value is odd', () {
      final value = SmallSerial(21);
      expect(value.isOdd, true);
    });

    test('should return false if value is even', () {
      final value = SmallSerial(22);
      expect(value.isOdd, false);
    });
  });

  group('isNegative', () {
    test('should return false if value is positive', () {
      final value = SmallSerial(22);
      expect(value.isNegative, false);
    });
  });
}
