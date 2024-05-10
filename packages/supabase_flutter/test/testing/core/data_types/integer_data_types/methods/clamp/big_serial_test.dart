import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
  group('within bounds (positive + positive)', () {
    test('should return itself if value is within bounds', () {
      final value = BigSerial(5);
      const lowerBound = 1;
      const upperBound = 10;
      final expected = BigSerial(5);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });

    test('should return itself if value is in the minimum edge', () {
      final value = BigSerial(1);
      const lowerBound = 1;
      const upperBound = 10;
      final expected = BigSerial(1);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });

    test('should return itself if value is in the maximum edge', () {
      final value = BigSerial(1);
      const lowerBound = 1;
      const upperBound = 10;
      final expected = BigSerial(1);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });
  });

  group('within bounds (negative + positive)', () {
    test('should return itself if value is within bounds', () {
      final value = BigSerial(3);
      const lowerBound = -10;
      const upperBound = 5;
      final expected = BigSerial(3);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });

    test('should return itself if value is in the maximum edge', () {
      final value = BigSerial(1);
      const lowerBound = -10;
      const upperBound = 1;
      final expected = BigSerial(1);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });
  });

  group('out of bounds (positive + positive)', () {
    test('should return clamp if value is above maximum', () {
      final value = BigSerial(15);
      const lowerBound = 1;
      const upperBound = 10;
      final expected = BigSerial(10);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });

    test('should return clamp if value is below minimum', () {
      final value = BigSerial(1);
      const lowerBound = 5;
      const upperBound = 10;
      final expected = BigSerial(5);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });
  });

  group('out of bounds (negative + positive)', () {
    test('should return clamp if value is above maximum', () {
      final value = BigSerial(15);
      const lowerBound = -10;
      const upperBound = 5;
      final expected = BigSerial(5);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });
  });

  group('bounds are equal', () {
    test('should return work correctly if both bounds are positive', () {
      final value = BigSerial(15);
      const lowerBound = 5;
      const upperBound = 5;
      final expected = BigSerial(5);
      final operation = value.clamp(lowerBound, upperBound);
      expect(operation.identicalTo(expected), true);
    });
  });

  group('general errors', () {
    test(
        'should throw ArgumentError if lower limit is greater than upper limit',
        () {
      final value = BigSerial(1);
      const lowerBound = 20;
      const upperBound = 10;
      expect(() => value.clamp(lowerBound, upperBound), throwsArgumentError);
    });
  });
}
