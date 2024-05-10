import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
  test('should return itself if value is positive', () {
    final value = Serial(10);
    final expected = Serial(10);
    final operation = value.ceil();
    expect(operation.identicalTo(expected), true);
  });
}
