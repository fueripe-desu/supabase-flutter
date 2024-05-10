import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
  test('should return a SmallSerial max', () {
    expect(SmallSerial.max.value, SmallSerial.max);
  });

  test('should return a SmallSerial min', () {
    expect(SmallSerial.min.value, SmallSerial.min);
  });
}
