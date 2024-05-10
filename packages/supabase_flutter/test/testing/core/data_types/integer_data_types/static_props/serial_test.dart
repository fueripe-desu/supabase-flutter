import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
  test('should return a Serial max', () {
    expect(Serial.max.value, Serial.max);
  });

  test('should return a Serial min', () {
    expect(Serial.min.value, Serial.min);
  });
}
