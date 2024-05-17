import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';

void main() {
  test('should inverse value when positive', () {
    final value = Numeric(value: '-10', precision: 2, scale: 0);
    final expected = Numeric(value: '10', precision: 2, scale: 0);
    final operation = -value;
    expect(operation.identicalTo(expected), true);
  });

  test('should inverse value when negative', () {
    final value = Numeric(value: '10', precision: 2, scale: 0);
    final expected = Numeric(value: '-10', precision: 2, scale: 0);
    final operation = -value;
    expect(operation.identicalTo(expected), true);
  });
}
