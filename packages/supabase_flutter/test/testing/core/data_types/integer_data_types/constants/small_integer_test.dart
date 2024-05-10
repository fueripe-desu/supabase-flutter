import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
  test('should return the max value of SmallInteger', () {
    expect(SmallInteger.maxValue, 32767);
  });

  test('should return the min value of SmallInteger', () {
    expect(SmallInteger.minValue, -32768);
  });
}
