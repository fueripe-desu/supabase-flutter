import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
  test('should return itself if value is already positive', () {
    final value = SmallInteger(10);
    final expected = SmallInteger(10);
    final operation = value.abs();
    expect(operation.identicalTo(expected), true);
  });

  test('should return the absolute of a negative value', () {
    final value = SmallInteger(-10);
    final expected = SmallInteger(10);
    final operation = value.abs();
    expect(operation.identicalTo(expected), true);
  });

  test('should throw RangeError if used with min value', () {
    final value = SmallInteger(SmallInteger.minValue);
    expect(() => value.abs(), throwsRangeError);
  });
}
