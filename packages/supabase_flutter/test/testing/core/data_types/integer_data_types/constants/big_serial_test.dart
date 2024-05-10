import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
  test('should return the max value of BigSerial', () {
    expect(BigSerial.maxValue, 9223372036854775806);
  });

  test('should return the min value of BigSerial', () {
    expect(BigSerial.minValue, 1);
  });
}
