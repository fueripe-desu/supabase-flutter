import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
  test('should return a BigSerial max', () {
    expect(BigSerial.max.value, BigSerial.max);
  });

  test('should return a BigSerial min', () {
    expect(BigSerial.min.value, BigSerial.min);
  });
}
