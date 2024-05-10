import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
  test('should negate positive Integer', () {
    final value = -Integer(20);
    final expected = Integer(-20);
    expect(value.identicalTo(expected), true);
  });

  test('should inverse negative Integer', () {
    final value = -Integer(-20);
    final expected = Integer(20);
    expect(value.identicalTo(expected), true);
  });

  test('should throw RangeError if min value of Integer is negated', () {
    final value = Integer(Integer.minValue);
    expect(() => -value, throwsRangeError);
  });
}
