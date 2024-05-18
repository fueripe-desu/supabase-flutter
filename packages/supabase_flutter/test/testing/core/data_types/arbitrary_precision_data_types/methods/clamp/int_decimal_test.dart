import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';

void main() {
  group('within bounds (positive + positive)', () {
    test('should return itself if value is within bounds', () {
      final upperBound = Decimal(value: '10', precision: 2, scale: 0);
      final lowerBound = Decimal(value: '1', precision: 1, scale: 0);
      final value = Decimal(value: '5', precision: 1, scale: 0);
      final expected = Decimal(value: '5', precision: 1, scale: 0);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });

    test('should return itself if value is in the minimum edge', () {
      final upperBound = Decimal(value: '10', precision: 2, scale: 0);
      final lowerBound = Decimal(value: '1', precision: 1, scale: 0);
      final value = Decimal(value: '1', precision: 1, scale: 0);
      final expected = Decimal(value: '1', precision: 1, scale: 0);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });

    test('should return itself if value is in the maximum edge', () {
      final upperBound = Decimal(value: '10', precision: 2, scale: 0);
      final lowerBound = Decimal(value: '1', precision: 1, scale: 0);
      final value = Decimal(value: '10', precision: 2, scale: 0);
      final expected = Decimal(value: '10', precision: 2, scale: 0);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });
  });

  group('within bounds (negative + negative)', () {
    test('should return itself if value is within bounds', () {
      final upperBound = Decimal(value: '-1', precision: 2, scale: 0);
      final lowerBound = Decimal(value: '-10', precision: 2, scale: 0);
      final value = Decimal(value: '-5', precision: 1, scale: 0);
      final expected = Decimal(value: '-5', precision: 1, scale: 0);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });

    test('should return itself if value is in the minimum edge', () {
      final upperBound = Decimal(value: '-1', precision: 2, scale: 0);
      final lowerBound = Decimal(value: '-10', precision: 2, scale: 0);
      final value = Decimal(value: '-10', precision: 2, scale: 0);
      final expected = Decimal(value: '-10', precision: 2, scale: 0);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });

    test('should return itself if value is in the maximum edge', () {
      final upperBound = Decimal(value: '-1', precision: 2, scale: 0);
      final lowerBound = Decimal(value: '-10', precision: 2, scale: 0);
      final value = Decimal(value: '-1', precision: 1, scale: 0);
      final expected = Decimal(value: '-1', precision: 1, scale: 0);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });
  });

  group('within bounds (negative + positive)', () {
    test('should return itself if value is within bounds', () {
      final upperBound = Decimal(value: '1', precision: 1, scale: 0);
      final lowerBound = Decimal(value: '-10', precision: 2, scale: 0);
      final value = Decimal(value: '-5', precision: 1, scale: 0);
      final expected = Decimal(value: '-5', precision: 1, scale: 0);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });

    test('should return itself if value is in the minimum edge', () {
      final upperBound = Decimal(value: '1', precision: 1, scale: 0);
      final lowerBound = Decimal(value: '-10', precision: 2, scale: 0);
      final value = Decimal(value: '-10', precision: 2, scale: 0);
      final expected = Decimal(value: '-10', precision: 2, scale: 0);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });

    test('should return itself if value is in the maximum edge', () {
      final upperBound = Decimal(value: '1', precision: 1, scale: 0);
      final lowerBound = Decimal(value: '-10', precision: 2, scale: 0);
      final value = Decimal(value: '1', precision: 1, scale: 0);
      final expected = Decimal(value: '1', precision: 1, scale: 0);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });
  });

  group('out of bounds (positive + positive)', () {
    test('should return clamp if value is above maximum', () {
      final upperBound = Decimal(value: '10', precision: 2, scale: 0);
      final lowerBound = Decimal(value: '1', precision: 1, scale: 0);
      final value = Decimal(value: '15', precision: 2, scale: 0);
      final expected = Decimal(value: '10', precision: 2, scale: 0);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });

    test('should return clamp if value is below minimum', () {
      final upperBound = Decimal(value: '10', precision: 2, scale: 0);
      final lowerBound = Decimal(value: '1', precision: 1, scale: 0);
      final value = Decimal(value: '-20', precision: 2, scale: 0);
      final expected = Decimal(value: '1', precision: 2, scale: 0);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });
  });

  group('out of bounds (negative + negative)', () {
    test('should return clamp if value is above maximum', () {
      final upperBound = Decimal(value: '-1', precision: 2, scale: 0);
      final lowerBound = Decimal(value: '-10', precision: 2, scale: 0);
      final value = Decimal(value: '15', precision: 2, scale: 0);
      final expected = Decimal(value: '-1', precision: 2, scale: 0);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });

    test('should return clamp if value is below minimum', () {
      final upperBound = Decimal(value: '-1', precision: 2, scale: 0);
      final lowerBound = Decimal(value: '-10', precision: 2, scale: 0);
      final value = Decimal(value: '-20', precision: 2, scale: 0);
      final expected = Decimal(value: '-10', precision: 2, scale: 0);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });
  });

  group('out of bounds (negative + positive)', () {
    test('should return clamp if value is above maximum', () {
      final upperBound = Decimal(value: '1', precision: 1, scale: 0);
      final lowerBound = Decimal(value: '-10', precision: 2, scale: 0);
      final value = Decimal(value: '15', precision: 2, scale: 0);
      final expected = Decimal(value: '1', precision: 2, scale: 0);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });

    test('should return clamp if value is below minimum', () {
      final upperBound = Decimal(value: '1', precision: 1, scale: 0);
      final lowerBound = Decimal(value: '-10', precision: 2, scale: 0);
      final value = Decimal(value: '-20', precision: 2, scale: 0);
      final expected = Decimal(value: '-10', precision: 2, scale: 0);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });
  });

  group('bounds are equal', () {
    test('should return work correctly if both bounds are positive', () {
      final upperBound = Decimal(value: '5', precision: 1, scale: 0);
      final lowerBound = Decimal(value: '5', precision: 1, scale: 0);
      final value = Decimal(value: '15', precision: 2, scale: 0);
      final expected = Decimal(value: '5', precision: 2, scale: 0);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });

    test('should return work correctly if both bounds are negative', () {
      final upperBound = Decimal(value: '-5', precision: 1, scale: 0);
      final lowerBound = Decimal(value: '-5', precision: 1, scale: 0);
      final value = Decimal(value: '-15', precision: 2, scale: 0);
      final expected = Decimal(value: '-5', precision: 2, scale: 0);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });

    test('should return work correctly if both bounds are zero', () {
      final upperBound = Decimal(value: '0', precision: 1, scale: 0);
      final lowerBound = Decimal(value: '0', precision: 1, scale: 0);
      final value = Decimal(value: '15', precision: 2, scale: 0);
      final expected = Decimal(value: '0', precision: 2, scale: 0);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });
  });

  group('general errors', () {
    test(
        'should throw ArgumentError if lower limit is greater than upper limit',
        () {
      final upperBound = Decimal(value: '10', precision: 2, scale: 0);
      final lowerBound = Decimal(value: '20', precision: 2, scale: 0);
      final value = Decimal(value: '0', precision: 1, scale: 0);
      expect(() => value.clamp(lowerBound, upperBound), throwsArgumentError);
    });
  });
}
