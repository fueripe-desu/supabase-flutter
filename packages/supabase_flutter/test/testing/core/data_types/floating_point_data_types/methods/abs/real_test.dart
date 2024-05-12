import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/floating_point_data_types.dart';

void main() {
  test('should return inverse if value is negative', () {
    final value = Real(-20);
    final expected = Real(20);
    final operation = value.abs();
    expect(operation.identicalTo(expected), true);
  });

  test('should return itself if value is already positive', () {
    final value = Real(20);
    final expected = Real(20);
    final operation = value.abs();
    expect(operation.identicalTo(expected), true);
  });

  test('should inverse min value', () {
    final value = Real(Real.minValue);
    final expected = Real(-Real.minValue);
    final operation = value.abs();
    expect(operation.identicalTo(expected), true);
  });

  test('should not affect max value', () {
    final value = Real(Real.maxValue);
    final expected = Real(Real.maxValue);
    final operation = value.abs();
    expect(operation.identicalTo(expected), true);
  });
}
