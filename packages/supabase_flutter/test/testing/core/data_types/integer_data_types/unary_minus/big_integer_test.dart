import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
  test('should negate positive BigInteger', () {
    final value = -BigInteger(20);
    final expected = BigInteger(-20);
    expect(value.identicalTo(expected), true);
  });

  test('should inverse negative BigInteger', () {
    final value = -BigInteger(-20);
    final expected = BigInteger(20);
    expect(value.identicalTo(expected), true);
  });

  test('should throw RangeError if min value of BigInteger is negated', () {
    final value = BigInteger(BigInteger.minValue);
    expect(() => -value, throwsRangeError);
  });
}
