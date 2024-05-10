import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
  test('should return a BigInteger zero', () {
    expect(BigInteger.zero.value, 0);
  });

  test('should return a BigInteger positive one', () {
    expect(BigInteger.positiveOne.value, 1);
  });

  test('should return a BigInteger negative one', () {
    expect(BigInteger.negativeOne.value, -1);
  });

  test('should return a BigInteger max', () {
    expect(BigInteger.max.value, BigInteger.max);
  });

  test('should return a BigInteger min', () {
    expect(BigInteger.min.value, BigInteger.min);
  });
}
