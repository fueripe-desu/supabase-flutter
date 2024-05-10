import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
  test('should create Serial successfully if value is in range', () {
    expect(Serial(365).value, 365);
  });

  test('should throw a RangeError if value of Serial overflows', () {
    expect(() => Serial(2147483648), throwsRangeError);
  });

  test('should throw a RangeError if value of Serial underflows', () {
    expect(() => Serial(-10), throwsRangeError);
  });
}
