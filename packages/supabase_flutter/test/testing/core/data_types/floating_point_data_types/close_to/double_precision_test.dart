import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/floating_point_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
  group('positive values', () {
    test('should return true if variation is within delta', () {
      final value1 = DoublePrecision(3.0001);
      final value2 = DoublePrecision(3.0002);
      const delta = 0.001;
      expect(value1.closeTo(value2, delta), true);
    });

    test('should return false if variation is larger than delta', () {
      final value1 = DoublePrecision(3.0001);
      final value2 = DoublePrecision(3.0002);
      const delta = 0.00001;
      expect(value1.closeTo(value2, delta), false);
    });
  });

  group('negative values', () {
    test('should return true if variation is within delta', () {
      final value1 = DoublePrecision(-3.0001);
      final value2 = DoublePrecision(-3.0002);
      const delta = 0.001;
      expect(value1.closeTo(value2, delta), true);
    });

    test('should return false if variation is larger than delta', () {
      final value1 = DoublePrecision(-3.0001);
      final value2 = DoublePrecision(-3.0002);
      const delta = 0.00001;
      expect(value1.closeTo(value2, delta), false);
    });
  });

  group('zero tolerance', () {
    test('should return true if values are identical', () {
      final value1 = DoublePrecision(3.0001);
      final value2 = DoublePrecision(3.0001);
      const delta = 0.0;
      expect(value1.closeTo(value2, delta), true);
    });

    test('should return false if values are different', () {
      final value1 = DoublePrecision(3.0001);
      final value2 = DoublePrecision(3.0002);
      const delta = 0.0;
      expect(value1.closeTo(value2, delta), false);
    });
  });

  test('should work correctly with value being zero', () {
    final value1 = DoublePrecision(0);
    final value2 = DoublePrecision(0.0001);
    const delta = 0.0001;
    expect(value1.closeTo(value2, delta), true);
  });

  test('should work correctly when values have a small difference', () {
    final value1 = DoublePrecision(3.0001);
    final value2 = DoublePrecision(3.0002);
    const delta = 0.0001;
    expect(value1.closeTo(value2, delta), true);
  });

  test('should return false if other is not of the same type', () {
    final value1 = DoublePrecision(3.0001);
    final value2 = BigInteger(2);
    const delta = 0.0001;
    expect(value1.closeTo(value2, delta), false);
  });

  test('should throw ArgumentError if delta is negative', () {
    final value1 = DoublePrecision(3.0001);
    final value2 = DoublePrecision(3.0002);
    const delta = -0.0001;
    expect(() => value1.closeTo(value2, delta), throwsArgumentError);
  });

  test('should throw ArgumentError if delta is NaN', () {
    final value1 = DoublePrecision(3.0001);
    final value2 = DoublePrecision(3.0002);
    const delta = double.nan;
    expect(() => value1.closeTo(value2, delta), throwsArgumentError);
  });

  test('should throw ArgumentError if delta is infinity', () {
    final value1 = DoublePrecision(3.0001);
    final value2 = DoublePrecision(3.0002);
    const delta = double.infinity;
    expect(() => value1.closeTo(value2, delta), throwsArgumentError);
  });

  test('should throw ArgumentError if delta is negative infinity', () {
    final value1 = DoublePrecision(3.0001);
    final value2 = DoublePrecision(3.0002);
    const delta = double.negativeInfinity;
    expect(() => value1.closeTo(value2, delta), throwsArgumentError);
  });
}
