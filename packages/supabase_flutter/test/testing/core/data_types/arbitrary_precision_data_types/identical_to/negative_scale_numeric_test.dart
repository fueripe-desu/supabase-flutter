import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
  group('positive comparison', () {
    test('should return true if other has same type and value', () {
      final value1 = Numeric(value: '24', precision: 2, scale: -1);
      final value2 = Numeric(value: '20', precision: 2, scale: 0);
      expect(value1.identicalTo(value2), true);
    });

    test(
        'should return false if other has same type and value but different sign',
        () {
      final value1 = Numeric(value: '24', precision: 2, scale: -1);
      final value2 = Numeric(value: '-20', precision: 2, scale: 0);
      expect(value1.identicalTo(value2), false);
    });

    test('should return false if other has same type but different value', () {
      final value1 = Numeric(value: '24', precision: 2, scale: -1);
      final value2 = Numeric(value: '40', precision: 2, scale: 0);
      expect(value1.identicalTo(value2), false);
    });

    test('should return false if other has different type and value', () {
      final value1 = Numeric(value: '24', precision: 2, scale: -1);
      final value2 = Integer(40);
      expect(value1.identicalTo(value2), false);
    });
  });

  group('negative comparison', () {
    test('should return true if other has same type and value', () {
      final value1 = Numeric(value: '-24', precision: 2, scale: -1);
      final value2 = Numeric(value: '-20', precision: 2, scale: 0);
      expect(value1.identicalTo(value2), true);
    });

    test(
        'should return false if other has same type and value but different sign',
        () {
      final value1 = Numeric(value: '-24', precision: 2, scale: -1);
      final value2 = Numeric(value: '20', precision: 2, scale: 0);
      expect(value1.identicalTo(value2), false);
    });

    test('should return false if other has same type but different value', () {
      final value1 = Numeric(value: '-24', precision: 2, scale: -1);
      final value2 = Numeric(value: '-40', precision: 2, scale: 0);
      expect(value1.identicalTo(value2), false);
    });

    test('should return false if other has different type and value', () {
      final value1 = Numeric(value: '-24', precision: 2, scale: -1);
      final value2 = Integer(-40);
      expect(value1.identicalTo(value2), false);
    });
  });
}
