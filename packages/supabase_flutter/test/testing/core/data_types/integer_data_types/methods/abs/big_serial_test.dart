import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
  test('should return itself if value is already positive', () {
    final value = BigSerial(10);
    final expected = BigSerial(10);
    final operation = value.abs();
    expect(operation.identicalTo(expected), true);
  });

  test('should not throw RangeError if used with min value', () {
    final value = BigSerial(BigSerial.minValue);
    expect(() => value.abs(), returnsNormally);
  });
}
