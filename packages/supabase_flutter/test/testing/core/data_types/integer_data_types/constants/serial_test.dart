import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
  test('should return the max value of Serial', () {
    expect(Serial.maxValue, 2147483647);
  });

  test('should return the min value of Serial', () {
    expect(Serial.minValue, 1);
  });
}
