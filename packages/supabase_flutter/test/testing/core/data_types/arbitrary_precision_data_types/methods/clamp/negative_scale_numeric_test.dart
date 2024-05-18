import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';

void main() {
  group('within bounds (positive + positive)', () {
    test('should return itself if value is within bounds', () {
      final upperBound = Numeric(value: '142', precision: 3, scale: -2);
      final lowerBound = Numeric(value: '14', precision: 2, scale: -1);
      final value = Numeric(value: '54', precision: 2, scale: -1);
      final expected = Numeric(value: '50', precision: 2, scale: 0);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });

    test('should return itself if value is in the minimum edge', () {
      final upperBound = Numeric(value: '142', precision: 3, scale: -2);
      final lowerBound = Numeric(value: '14', precision: 2, scale: -1);
      final value = Numeric(value: '14', precision: 2, scale: -1);
      final expected = Numeric(value: '10', precision: 2, scale: 0);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });

    test('should return itself if value is in the maximum edge', () {
      final upperBound = Numeric(value: '142', precision: 3, scale: -2);
      final lowerBound = Numeric(value: '14', precision: 2, scale: -1);
      final value = Numeric(value: '14', precision: 2, scale: -1);
      final expected = Numeric(value: '10', precision: 2, scale: 0);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });
  });

  group('within bounds (negative + negative)', () {
    test('should return itself if value is within bounds', () {
      final upperBound = Numeric(value: '-14', precision: 2, scale: -1);
      final lowerBound = Numeric(value: '-142', precision: 3, scale: -2);
      final value = Numeric(value: '-54', precision: 2, scale: -1);
      final expected = Numeric(value: '-50', precision: 2, scale: 0);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });

    test('should return itself if value is in the minimum edge', () {
      final upperBound = Numeric(value: '-14', precision: 2, scale: -1);
      final lowerBound = Numeric(value: '-142', precision: 3, scale: -2);
      final value = Numeric(value: '-142', precision: 3, scale: -2);
      final expected = Numeric(value: '-100', precision: 3, scale: 0);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });

    test('should return itself if value is in the maximum edge', () {
      final upperBound = Numeric(value: '-14', precision: 2, scale: -1);
      final lowerBound = Numeric(value: '-142', precision: 3, scale: -2);
      final value = Numeric(value: '-14', precision: 2, scale: -1);
      final expected = Numeric(value: '-10', precision: 2, scale: 0);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });
  });

  group('within bounds (negative + positive)', () {
    test('should return itself if value is within bounds', () {
      final upperBound = Numeric(value: '14', precision: 2, scale: -1);
      final lowerBound = Numeric(value: '-142', precision: 3, scale: -2);
      final value = Numeric(value: '-54', precision: 2, scale: -1);
      final expected = Numeric(value: '-50', precision: 2, scale: 0);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });

    test('should return itself if value is in the minimum edge', () {
      final upperBound = Numeric(value: '14', precision: 2, scale: -1);
      final lowerBound = Numeric(value: '-142', precision: 3, scale: -2);
      final value = Numeric(value: '-142', precision: 3, scale: -2);
      final expected = Numeric(value: '-100', precision: 3, scale: 0);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });

    test('should return itself if value is in the maximum edge', () {
      final upperBound = Numeric(value: '14', precision: 2, scale: -1);
      final lowerBound = Numeric(value: '-142', precision: 3, scale: -2);
      final value = Numeric(value: '14', precision: 2, scale: -1);
      final expected = Numeric(value: '10', precision: 2, scale: 0);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });
  });

  group('out of bounds (positive + positive)', () {
    test('should return clamp if value is above maximum', () {
      final upperBound = Numeric(value: '142', precision: 3, scale: -2);
      final lowerBound = Numeric(value: '14', precision: 2, scale: -1);
      final value = Numeric(value: '242', precision: 3, scale: -2);
      final expected = Numeric(value: '100', precision: 3, scale: 0);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });

    test('should return clamp if value is below minimum', () {
      final upperBound = Numeric(value: '142', precision: 3, scale: -2);
      final lowerBound = Numeric(value: '14', precision: 2, scale: -1);
      final value = Numeric(value: '14', precision: 2, scale: -1);
      final expected = Numeric(value: '10', precision: 2, scale: 0);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });
  });

  group('out of bounds (negative + negative)', () {
    test('should return clamp if value is above maximum', () {
      final upperBound = Numeric(value: '-14', precision: 2, scale: -1);
      final lowerBound = Numeric(value: '-142', precision: 3, scale: -2);
      final value = Numeric(value: '242', precision: 3, scale: -2);
      final expected = Numeric(value: '-10', precision: 3, scale: 0);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });

    test('should return clamp if value is below minimum', () {
      final upperBound = Numeric(value: '-14', precision: 2, scale: -1);
      final lowerBound = Numeric(value: '-142', precision: 3, scale: -2);
      final value = Numeric(value: '-242', precision: 3, scale: -2);
      final expected = Numeric(value: '-100', precision: 3, scale: 0);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });
  });

  group('out of bounds (negative + positive)', () {
    test('should return clamp if value is above maximum', () {
      final upperBound = Numeric(value: '14', precision: 2, scale: -1);
      final lowerBound = Numeric(value: '-142', precision: 3, scale: -2);
      final value = Numeric(value: '34', precision: 2, scale: -1);
      final expected = Numeric(value: '10', precision: 3, scale: 0);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });

    test('should return clamp if value is below minimum', () {
      final upperBound = Numeric(value: '14', precision: 2, scale: -1);
      final lowerBound = Numeric(value: '-142', precision: 3, scale: -2);
      final value = Numeric(value: '-242', precision: 3, scale: -2);
      final expected = Numeric(value: '-100', precision: 3, scale: 0);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });
  });

  group('bounds are equal', () {
    test('should return work correctly if both bounds are positive', () {
      final upperBound = Numeric(value: '54', precision: 2, scale: -1);
      final lowerBound = Numeric(value: '54', precision: 2, scale: -1);
      final value = Numeric(value: '74', precision: 2, scale: -1);
      final expected = Numeric(value: '50', precision: 2, scale: 0);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });

    test('should return work correctly if both bounds are negative', () {
      final upperBound = Numeric(value: '-54', precision: 2, scale: -1);
      final lowerBound = Numeric(value: '-54', precision: 2, scale: -1);
      final value = Numeric(value: '-74', precision: 2, scale: -1);
      final expected = Numeric(value: '-50', precision: 2, scale: 0);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });
  });

  group('general errors', () {
    test(
        'should throw ArgumentError if lower limit is greater than upper limit',
        () {
      final upperBound = Numeric(value: '14', precision: 2, scale: -1);
      final lowerBound = Numeric(value: '24', precision: 2, scale: -1);
      final value = Numeric(value: '0', precision: 1, scale: 0);
      expect(() => value.clamp(lowerBound, upperBound), throwsArgumentError);
    });
  });
}
