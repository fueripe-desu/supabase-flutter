import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/floating_point_data_types.dart';

void main() {
  group('positive comparison', () {
    test('should return true if other has same type and value', () {
      expect(DoublePrecision(20).identicalTo(DoublePrecision(20)), true);
    });

    test(
        'should return false if other has same type but different fractional parts',
        () {
      expect(DoublePrecision(20.3).identicalTo(DoublePrecision(20.7)), false);
    });

    test(
        'should return false if other has same type and value but different sign',
        () {
      expect(DoublePrecision(20).identicalTo(DoublePrecision(-20)), false);
    });

    test('should return false if other has same type but different value', () {
      expect(DoublePrecision(20).identicalTo(DoublePrecision(40)), false);
    });

    test('should return false if other has different type and value', () {
      expect(DoublePrecision(20).identicalTo(Real(40)), false);
    });
  });

  group('negative comparison', () {
    test('should return true if other has same type and value', () {
      expect(DoublePrecision(-20).identicalTo(DoublePrecision(-20)), true);
    });

    test(
        'should return false if other has same type but different fractional parts',
        () {
      expect(DoublePrecision(-20.3).identicalTo(DoublePrecision(-20.7)), false);
    });

    test(
        'should return false if other has same type and value but different sign',
        () {
      expect(DoublePrecision(-20).identicalTo(DoublePrecision(20)), false);
    });

    test('should return false if other has same type but different value', () {
      expect(DoublePrecision(-20).identicalTo(DoublePrecision(-40)), false);
    });

    test('should return false if other has different type and value', () {
      expect(DoublePrecision(-20).identicalTo(Real(-40)), false);
    });
  });

  test('should return true if both have same type and zero values', () {
    expect(DoublePrecision(0).identicalTo(DoublePrecision(0)), true);
  });

  test('should return true when comparing -0.0 and 0.0', () {
    expect(DoublePrecision(-0).identicalTo(DoublePrecision(0)), true);
  });
}
