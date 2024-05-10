import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
  group('within bounds (positive + positive)', () {
    test('should return itself if value is within bounds', () {
      final value = Integer(5);
      const lowerBound = 1;
      const upperBound = 10;
      final expected = Integer(5);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });

    test('should return itself if value is in the minimum edge', () {
      final value = Integer(1);
      const lowerBound = 1;
      const upperBound = 10;
      final expected = Integer(1);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });

    test('should return itself if value is in the maximum edge', () {
      final value = Integer(1);
      const lowerBound = 1;
      const upperBound = 10;
      final expected = Integer(1);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });
  });

  group('within bounds (negative + negative)', () {
    test('should return itself if value is within bounds', () {
      final value = Integer(-5);
      const lowerBound = -10;
      const upperBound = -1;
      final expected = Integer(-5);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });

    test('should return itself if value is in the minimum edge', () {
      final value = Integer(-10);
      const lowerBound = -10;
      const upperBound = -1;
      final expected = Integer(-10);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });

    test('should return itself if value is in the maximum edge', () {
      final value = Integer(-1);
      const lowerBound = -10;
      const upperBound = -1;
      final expected = Integer(-1);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });
  });

  group('within bounds (negative + positive)', () {
    test('should return itself if value is within bounds', () {
      final value = Integer(-5);
      const lowerBound = -10;
      const upperBound = 1;
      final expected = Integer(-5);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });

    test('should return itself if value is in the minimum edge', () {
      final value = Integer(-10);
      const lowerBound = -10;
      const upperBound = 1;
      final expected = Integer(-10);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });

    test('should return itself if value is in the maximum edge', () {
      final value = Integer(1);
      const lowerBound = -10;
      const upperBound = 1;
      final expected = Integer(1);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });
  });

  group('out of bounds (positive + positive)', () {
    test('should return clamp if value is above maximum', () {
      final value = Integer(15);
      const lowerBound = 1;
      const upperBound = 10;
      final expected = Integer(10);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });

    test('should return clamp if value is below minimum', () {
      final value = Integer(-20);
      const lowerBound = 1;
      const upperBound = 10;
      final expected = Integer(1);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });
  });

  group('out of bounds (negative + negative)', () {
    test('should return clamp if value is above maximum', () {
      final value = Integer(15);
      const lowerBound = -10;
      const upperBound = -1;
      final expected = Integer(-1);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });

    test('should return clamp if value is below minimum', () {
      final value = Integer(-20);
      const lowerBound = -10;
      const upperBound = -1;
      final expected = Integer(-10);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });
  });

  group('out of bounds (negative + positive)', () {
    test('should return clamp if value is above maximum', () {
      final value = Integer(15);
      const lowerBound = -10;
      const upperBound = 1;
      final expected = Integer(1);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });

    test('should return clamp if value is below minimum', () {
      final value = Integer(-20);
      const lowerBound = -10;
      const upperBound = 1;
      final expected = Integer(-10);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });
  });

  group('bounds are equal', () {
    test('should return work correctly if both bounds are positive', () {
      final value = Integer(15);
      const lowerBound = 5;
      const upperBound = 5;
      final expected = Integer(5);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });

    test('should return work correctly if both bounds are negative', () {
      final value = Integer(-15);
      const lowerBound = -5;
      const upperBound = -5;
      final expected = Integer(-5);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });

    test('should return work correctly if both bounds are zero', () {
      final value = Integer(15);
      const lowerBound = 0;
      const upperBound = 0;
      final expected = Integer(0);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });
  });

  group('general errors', () {
    test(
        'should throw ArgumentError if lower limit is greater than upper limit',
        () {
      final value = Integer(0);
      const lowerBound = 20;
      const upperBound = 10;
      expect(() => value.clamp(lowerBound, upperBound), throwsArgumentError);
    });
  });
}
