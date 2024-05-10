import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
  test('should return the max value of BigInteger', () {
    expect(BigInteger.maxValue, 9223372036854775807);
  });

  test('should return the min value of BigInteger', () {
    expect(BigInteger.minValue, -9223372036854775808);
  });
}
