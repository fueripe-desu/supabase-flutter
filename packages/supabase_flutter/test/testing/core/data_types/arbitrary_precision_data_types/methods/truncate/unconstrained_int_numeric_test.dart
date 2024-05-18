import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';

void main() {
  test('should truncate correctly positive values', () {
    final value = Numeric(value: '20');
    final expected = Numeric(value: '20', precision: 2, scale: 0);
    final operation = value.truncate();
    expect(operation.identicalTo(expected), true);
  });

  test('should truncate correctly zero values', () {
    final value = Numeric(value: '0');
    final expected = Numeric(value: '0', precision: 1, scale: 0);
    final operation = value.truncate();
    expect(operation.identicalTo(expected), true);
  });

  test('should truncate correctly negative values', () {
    final value = Numeric(value: '-20');
    final expected = Numeric(value: '-20', precision: 2, scale: 0);
    final operation = value.truncate();
    expect(operation.identicalTo(expected), true);
  });
}
