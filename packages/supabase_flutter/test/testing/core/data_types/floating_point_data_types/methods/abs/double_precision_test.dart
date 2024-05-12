import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/floating_point_data_types.dart';

void main() {
  test('should return inverse if value is negative', () {
    final value = DoublePrecision(-20);
    final expected = DoublePrecision(20);
    final operation = value.abs();
    expect(operation.identicalTo(expected), true);
  });

  test('should return itself if value is already positive', () {
    final value = DoublePrecision(20);
    final expected = DoublePrecision(20);
    final operation = value.abs();
    expect(operation.identicalTo(expected), true);
  });

  test('should inverse min value', () {
    final value = DoublePrecision(DoublePrecision.minValue);
    final expected = DoublePrecision(-DoublePrecision.minValue);
    final operation = value.abs();
    expect(operation.identicalTo(expected), true);
  });

  test('should not affect max value', () {
    final value = DoublePrecision(DoublePrecision.maxValue);
    final expected = DoublePrecision(DoublePrecision.maxValue);
    final operation = value.abs();
    expect(operation.identicalTo(expected), true);
  });
}
