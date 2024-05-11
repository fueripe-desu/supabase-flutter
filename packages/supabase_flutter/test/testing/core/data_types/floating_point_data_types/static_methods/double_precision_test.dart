import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/floating_point_data_types.dart';

void main() {
  group('isValid() method', () {
    test('should return true if value is valid', () {
      const value = 10.5;
      final operation = DoublePrecision.isValid(value);
      expect(operation, true);
    });

    test('should return false if value is invalid', () {
      const value = double.infinity;
      final operation = DoublePrecision.isValid(value);
      expect(operation, false);
    });
  });

  group('tryCreate() method', () {
    test('should return DoublePrecision if value is valid', () {
      const value = 10.5;
      final expected = DoublePrecision(10.5);
      final operation = DoublePrecision.tryCreate(value);
      expect(operation, isNotNull);
      expect(operation!.identicalTo(expected), true);
    });

    test('should return null if value is invalid', () {
      const value = double.infinity;
      const expected = null;
      final operation = DoublePrecision.tryCreate(value);
      expect(operation, isNull);
      expect(operation == expected, true);
    });
  });
}
