import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
  test('should negate positive SmallInteger', () {
    final value = -SmallInteger(20);
    final expected = SmallInteger(-20);
    expect(value.identicalTo(expected), true);
  });

  test('should inverse negative SmallInteger', () {
    final value = -SmallInteger(-20);
    final expected = SmallInteger(20);
    expect(value.identicalTo(expected), true);
  });

  test('should throw RangeError if min value of SmallInteger is negated', () {
    final value = SmallInteger(SmallInteger.minValue);
    expect(() => -value, throwsRangeError);
  });
}
