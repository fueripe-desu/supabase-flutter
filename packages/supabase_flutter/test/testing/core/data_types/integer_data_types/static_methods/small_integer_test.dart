import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
  group('isValid() method', () {
    test('should return true if value is valid', () {
      const value = 123;
      final operation = SmallInteger.isValid(value);
      expect(operation, true);
    });

    test('should return true if value is not valid', () {
      const value = BigInteger.maxValue;
      final operation = SmallInteger.isValid(value);
      expect(operation, false);
    });
  });

  group('tryCreate() method', () {
    test('should return BigInteger if value is valid', () {
      const value = 123;
      final expected = SmallInteger(123);
      final operation = SmallInteger.tryCreate(value);
      expect(operation, isNotNull);
      expect(operation!.identicalTo(expected), true);
    });

    test('should return null if value is not valid', () {
      const value = BigInteger.maxValue;
      const expected = null;
      final operation = SmallInteger.tryCreate(value);
      expect(operation, isNull);
      expect(operation == expected, true);
    });
  });
}
