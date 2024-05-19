import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';

void main() {
  test('should return a Numeric with the value of integer zero', () {
    final expected = Numeric(value: '0', precision: 1, scale: 0);
    expect(Numeric.integerZero.identicalTo(expected), true);
  });

  test('should return a Numeric with the value of float zero', () {
    final expected = Numeric(value: '0.0', precision: 2, scale: 1);
    expect(Numeric.floatZero.identicalTo(expected), true);
  });

  test('should return a Numeric with the value of negative one', () {
    final expected = Numeric(value: '-1', precision: 1, scale: 0);
    expect(Numeric.negativeOne.identicalTo(expected), true);
  });

  test('should return a Numeric with the value of positive one', () {
    final expected = Numeric(value: '1', precision: 1, scale: 0);
    expect(Numeric.positiveOne.identicalTo(expected), true);
  });
}
