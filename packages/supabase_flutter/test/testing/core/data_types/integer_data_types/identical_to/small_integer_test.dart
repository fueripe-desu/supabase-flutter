import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
  group('positive comparison', () {
    test('should return true if other has same type and value', () {
      expect(SmallInteger(20).identicalTo(SmallInteger(20)), true);
    });

    test(
        'should return false if other has same type and value but different sign',
        () {
      expect(SmallInteger(20).identicalTo(SmallInteger(-20)), false);
    });

    test('should return false if other has same type but different value', () {
      expect(SmallInteger(20).identicalTo(SmallInteger(40)), false);
    });

    test('should return false if other has different type and value', () {
      expect(SmallInteger(20).identicalTo(BigInteger(40)), false);
    });
  });

  group('negative comparison', () {
    test('should return true if other has same type and value', () {
      expect(SmallInteger(-20).identicalTo(SmallInteger(-20)), true);
    });

    test(
        'should return false if other has same type and value but different sign',
        () {
      expect(SmallInteger(-20).identicalTo(SmallInteger(20)), false);
    });

    test('should return false if other has same type but different value', () {
      expect(SmallInteger(-20).identicalTo(SmallInteger(-40)), false);
    });

    test('should return false if other has different type and value', () {
      expect(SmallInteger(-20).identicalTo(BigInteger(-40)), false);
    });
  });

  test('should return true if both have same type and zero values', () {
    expect(SmallInteger(0).identicalTo(SmallInteger(0)), true);
  });
}
