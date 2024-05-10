import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
  test('should return itself if value is already positive', () {
    final value = BigInteger(10);
    final expected = BigInteger(10);
    final operation = value.abs();
    expect(operation.identicalTo(expected), true);
  });

  test('should return the absolute of a negative value', () {
    final value = BigInteger(-10);
    final expected = BigInteger(10);
    final operation = value.abs();
    expect(operation.identicalTo(expected), true);
  });

  test('should throw RangeError if used with min value', () {
    final value = BigInteger(BigInteger.minValue);
    expect(() => value.abs(), throwsRangeError);
  });
}
