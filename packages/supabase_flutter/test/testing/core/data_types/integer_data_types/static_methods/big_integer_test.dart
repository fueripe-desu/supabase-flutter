import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
  group('isValid() method', () {
    test('should return true if value is valid', () {
      const value = 123;
      final operation = BigInteger.isValid(value);
      expect(operation, true);
    });
  });

  group('tryCreate() method', () {
    test('should return BigInteger if value is valid', () {
      const value = 123;
      final expected = BigInteger(123);
      final operation = BigInteger.tryCreate(value);
      expect(operation, isNotNull);
      expect(operation!.identicalTo(expected), true);
    });
  });
}
