import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/floating_point_data_types.dart';

void main() {
  group('positive comparison', () {
    test('should return true if other has same type and value', () {
      final value1 = Decimal(value: '0.3', precision: 1, scale: 1);
      final value2 = Decimal(value: '0.3', precision: 1, scale: 1);
      expect(value1.identicalTo(value2), true);
    });

    test(
        'should return false if other has same type but different fractional parts',
        () {
      final value1 = Decimal(value: '0.3', precision: 1, scale: 1);
      final value2 = Decimal(value: '0.7', precision: 1, scale: 1);
      expect(value1.identicalTo(value2), false);
    });

    test(
        'should return false if other has same type and value but different sign',
        () {
      final value1 = Decimal(value: '0.3', precision: 1, scale: 1);
      final value2 = Decimal(value: '-0.3', precision: 1, scale: 1);
      expect(value1.identicalTo(value2), false);
    });

    test('should return false if other has same type but different value', () {
      final value1 = Decimal(value: '0.3', precision: 1, scale: 1);
      final value2 = Decimal(value: '0.4', precision: 1, scale: 1);
      expect(value1.identicalTo(value2), false);
    });

    test('should return false if other has different type and value', () {
      final value1 = Decimal(value: '0.3', precision: 1, scale: 1);
      final value2 = Real(40);
      expect(value1.identicalTo(value2), false);
    });
  });

  group('negative comparison', () {
    test('should return true if other has same type and value', () {
      final value1 = Decimal(value: '-0.3', precision: 1, scale: 1);
      final value2 = Decimal(value: '-0.3', precision: 1, scale: 1);
      expect(value1.identicalTo(value2), true);
    });

    test(
        'should return false if other has same type but different fractional parts',
        () {
      final value1 = Decimal(value: '-0.3', precision: 1, scale: 1);
      final value2 = Decimal(value: '-0.7', precision: 1, scale: 1);
      expect(value1.identicalTo(value2), false);
    });

    test(
        'should return false if other has same type and value but different sign',
        () {
      final value1 = Decimal(value: '-0.3', precision: 1, scale: 1);
      final value2 = Decimal(value: '0.3', precision: 1, scale: 1);
      expect(value1.identicalTo(value2), false);
    });

    test('should return false if other has same type but different value', () {
      final value1 = Decimal(value: '-0.3', precision: 1, scale: 1);
      final value2 = Decimal(value: '-0.4', precision: 1, scale: 1);
      expect(value1.identicalTo(value2), false);
    });

    test('should return false if other has different type and value', () {
      final value1 = Decimal(value: '-0.3', precision: 1, scale: 1);
      final value2 = Real(-40);
      expect(value1.identicalTo(value2), false);
    });
  });

  test('should return true if both have same type and zero values', () {
    final value1 = Decimal(value: '0.0', precision: 1, scale: 1);
    final value2 = Decimal(value: '0.0', precision: 1, scale: 1);
    expect(value1.identicalTo(value2), true);
  });

  test('should return true when comparing -0.0 and 0.0', () {
    final value1 = Decimal(value: '-0.0', precision: 1, scale: 1);
    final value2 = Decimal(value: '0.0', precision: 1, scale: 1);
    expect(value1.identicalTo(value2), true);
  });
}
