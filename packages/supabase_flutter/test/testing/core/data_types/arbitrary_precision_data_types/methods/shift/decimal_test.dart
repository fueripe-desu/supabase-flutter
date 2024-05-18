import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';

void main() {
  test('should shift the decimal point to the right if input is positive', () {
    final value = Decimal(value: '312.9873249', precision: 10, scale: 7);
    final expected = Decimal(value: '31298.73249', precision: 10, scale: 5);
    final operation = value.shift(2);
    expect(operation.identicalTo(expected), true);
  });

  test(
      'should return an integer if decimal point is shifted to the right beyond significant digits',
      () {
    final value = Decimal(value: '3.5', precision: 2, scale: 1);
    // 35 because it would become 35. after shifiting, so the point is removed
    final expected = Decimal(value: '35', precision: 2, scale: 0);
    final operation = value.shift(1);
    expect(operation.identicalTo(expected), true);
  });

  test(
      'should add 0s if decimal point is shifted to the right after the value becomes an integer',
      () {
    final value = Decimal(value: '3.5', precision: 2, scale: 1);
    final expected = Decimal(value: '3500', precision: 4, scale: 0);
    final operation = value.shift(3);
    expect(operation.identicalTo(expected), true);
  });

  test('should return itself if value is shifted by 0 places', () {
    final value = Decimal(value: '3.5', precision: 2, scale: 1);
    final expected = Decimal(value: '3.5', precision: 2, scale: 1);
    final operation = value.shift(0);
    expect(operation.identicalTo(expected), true);
  });

  test('should shift the decimal point to the left if input is negative', () {
    final value = Decimal(value: '312.9873249', precision: 10, scale: 7);
    final expected = Decimal(value: '3.129873249', precision: 10, scale: 9);
    final operation = value.shift(-2);
    expect(operation.identicalTo(expected), true);
  });

  test(
      'should add 0s to the left if decimal point is shifted to the right beyond significant digits',
      () {
    final value = Decimal(value: '3.5', precision: 2, scale: 1);
    // 0.35 because it would become .35 after shifiting, so a 0 is added
    final expected = Decimal(value: '0.35', precision: 3, scale: 2);
    final operation = value.shift(-1);
    expect(operation.identicalTo(expected), true);
  });

  test('should add 0s to the right of an integer if input is positive', () {
    final value = Decimal(value: '30', precision: 2, scale: 0);
    final expected = Decimal(value: '30000', precision: 5, scale: 0);
    final operation = value.shift(3);
    expect(operation.identicalTo(expected), true);
  });

  test('should remove 0s on the left of an integer if input is negative', () {
    final value = Decimal(value: '300', precision: 3, scale: 0);
    final expected = Decimal(value: '3', precision: 1, scale: 0);
    final operation = value.shift(-2);
    expect(operation.identicalTo(expected), true);
  });

  test(
      'should add a decimal point to the left if there are not 0s to remove from integer',
      () {
    final value = Decimal(value: '312', precision: 3, scale: 0);
    final expected = Decimal(value: '3.12', precision: 3, scale: 2);
    final operation = value.shift(-2);
    expect(operation.identicalTo(expected), true);
  });

  test(
      'should add a decimal point to the left of the integer if negative value exceeds the amount of 0s',
      () {
    final value = Decimal(value: '300', precision: 3, scale: 0);
    final expected = Decimal(value: '0.03', precision: 3, scale: 2);
    final operation = value.shift(-4);
    expect(operation.identicalTo(expected), true);
  });

  test('should shift correctly fractional values', () {
    final value = Decimal(value: '0.323', precision: 3, scale: 3);
    final expected = Decimal(value: '3.23', precision: 3, scale: 2);
    final operation = value.shift(1);
    expect(operation.identicalTo(expected), true);
  });

  test('should shift correctly negative scale values', () {
    final value = Decimal(value: '34', precision: 2, scale: -1);
    final expected = Decimal(value: '300', precision: 3, scale: 0);
    final operation = value.shift(1);
    expect(operation.identicalTo(expected), true);
  });
}
