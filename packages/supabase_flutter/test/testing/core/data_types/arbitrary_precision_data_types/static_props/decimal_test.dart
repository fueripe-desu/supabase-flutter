import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';

void main() {
  test('should return a Decimal with the value of integer zero', () {
    final expected = Decimal(value: '0', precision: 1, scale: 0);
    expect(Decimal.integerZero.identicalTo(expected), true);
  });

  test('should return a Decimal with the value of float zero', () {
    final expected = Decimal(value: '0.0', precision: 2, scale: 1);
    expect(Decimal.floatZero.identicalTo(expected), true);
  });

  test('should return a Decimal with the value of negative one', () {
    final expected = Decimal(value: '-1', precision: 1, scale: 0);
    expect(Decimal.negativeOne.identicalTo(expected), true);
  });

  test('should return a Decimal with the value of positive one', () {
    final expected = Decimal(value: '1', precision: 1, scale: 0);
    expect(Decimal.positiveOne.identicalTo(expected), true);
  });
}
