import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
  test('should return itself if value is positive', () {
    final value = BigInteger(10);
    final expected = BigInteger(10);
    final operation = value.truncate();
    expect(operation.identicalTo(expected), true);
  });

  test('should return itself if value is zero value', () {
    final value = BigInteger(0);
    final expected = BigInteger(0);
    final operation = value.truncate();
    expect(operation.identicalTo(expected), true);
  });

  test('should return itself if value is negative value', () {
    final value = BigInteger(-10);
    final expected = BigInteger(-10);
    final operation = value.truncate();
    expect(operation.identicalTo(expected), true);
  });
}
