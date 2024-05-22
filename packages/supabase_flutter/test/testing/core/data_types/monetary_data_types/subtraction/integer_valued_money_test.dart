import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/currency/currencies.dart';
import 'package:supabase_flutter/src/testing/core/data_types/monetary_data_types.dart';

void main() {
  test('should correctly perform positive subtraction', () {
    final value1 = Money(r'$30.00', overrideCurrency: Currencies.usd);
    final value2 = Money(r'$20.00', overrideCurrency: Currencies.usd);
    final expected = Money(r'$10.00', overrideCurrency: Currencies.usd);
    final operation = value1 - value2;
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly perform negative subtraction', () {
    final value1 = Money(r'-$30.00', overrideCurrency: Currencies.usd);
    final value2 = Money(r'-$20.00', overrideCurrency: Currencies.usd);
    final expected = Money(r'-$10.00', overrideCurrency: Currencies.usd);
    final operation = value1 - value2;
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly perform mixed sign subtraction (positive + negative)',
      () {
    final value1 = Money(r'$50.00', overrideCurrency: Currencies.usd);
    final value2 = Money(r'-$30.00', overrideCurrency: Currencies.usd);
    final expected = Money(r'$80.00', overrideCurrency: Currencies.usd);
    final operation = value1 - value2;
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly perform mixed sign subtraction (negative + positive)',
      () {
    final value1 = Money(r'-$20.00', overrideCurrency: Currencies.usd);
    final value2 = Money(r'$30.00', overrideCurrency: Currencies.usd);
    final expected = Money(r'-$50.00', overrideCurrency: Currencies.usd);
    final operation = value1 - value2;
    expect(operation.identicalTo(expected), true);
  });

  test('should return positive value (positive + positive)', () {
    final value1 = Money(r'$40.00', overrideCurrency: Currencies.usd);
    final value2 = Money(r'$30.00', overrideCurrency: Currencies.usd);
    final expected = Money(r'$10.00', overrideCurrency: Currencies.usd);
    final operation = value1 - value2;
    expect(operation.identicalTo(expected), true);
  });

  test('should return negative value (positive + positive)', () {
    final value1 = Money(r'$30.00', overrideCurrency: Currencies.usd);
    final value2 = Money(r'$40.00', overrideCurrency: Currencies.usd);
    final expected = Money(r'-$10.00', overrideCurrency: Currencies.usd);
    final operation = value1 - value2;
    expect(operation.identicalTo(expected), true);
  });

  test('should return zero (positive + positive)', () {
    final value1 = Money(r'$40.00', overrideCurrency: Currencies.usd);
    final value2 = Money(r'$40.00', overrideCurrency: Currencies.usd);
    final expected = Money(r'$0.00', overrideCurrency: Currencies.usd);
    final operation = value1 - value2;
    expect(operation.identicalTo(expected), true);
  });

  test('should return positive value (negative + negative)', () {
    final value1 = Money(r'-$30.00', overrideCurrency: Currencies.usd);
    final value2 = Money(r'-$40.00', overrideCurrency: Currencies.usd);
    final expected = Money(r'$10.00', overrideCurrency: Currencies.usd);
    final operation = value1 - value2;
    expect(operation.identicalTo(expected), true);
  });

  test('should return negative value (negative + negative)', () {
    final value1 = Money(r'-$40.00', overrideCurrency: Currencies.usd);
    final value2 = Money(r'-$30.00', overrideCurrency: Currencies.usd);
    final expected = Money(r'-$10.00', overrideCurrency: Currencies.usd);
    final operation = value1 - value2;
    expect(operation.identicalTo(expected), true);
  });

  test('should return zero (negative + negative)', () {
    final value1 = Money(r'-$40.00', overrideCurrency: Currencies.usd);
    final value2 = Money(r'-$40.00', overrideCurrency: Currencies.usd);
    final expected = Money(r'$0.00', overrideCurrency: Currencies.usd);
    final operation = value1 - value2;
    expect(operation.identicalTo(expected), true);
  });

  test('should return positive value (positive + negative)', () {
    final value1 = Money(r'$40.00', overrideCurrency: Currencies.usd);
    final value2 = Money(r'-$30.00', overrideCurrency: Currencies.usd);
    final expected = Money(r'$70.00', overrideCurrency: Currencies.usd);
    final operation = value1 - value2;
    expect(operation.identicalTo(expected), true);
  });

  test('should return negative value (negative + positive)', () {
    final value1 = Money(r'-$40.00', overrideCurrency: Currencies.usd);
    final value2 = Money(r'$30.00', overrideCurrency: Currencies.usd);
    final expected = Money(r'-$70.00', overrideCurrency: Currencies.usd);
    final operation = value1 - value2;
    expect(operation.identicalTo(expected), true);
  });

  test('should retain positive sign when subtracting zero', () {
    final value1 = Money(r'$20.00', overrideCurrency: Currencies.usd);
    final value2 = Money(r'$0.00', overrideCurrency: Currencies.usd);
    final expected = Money(r'$20.00', overrideCurrency: Currencies.usd);
    final operation = value1 - value2;
    expect(operation.identicalTo(expected), true);
  });

  test('should retain negative sign when subtracting zero', () {
    final value1 = Money(r'-$20.00', overrideCurrency: Currencies.usd);
    final value2 = Money(r'$0.00', overrideCurrency: Currencies.usd);
    final expected = Money(r'-$20.00', overrideCurrency: Currencies.usd);
    final operation = value1 - value2;
    expect(operation.identicalTo(expected), true);
  });

  test('should throw ArgumentError when one of the operands is not Money', () {
    final value1 = Money(r'-$20.00', overrideCurrency: Currencies.usd);
    const value2 = 0;
    expect(() => value1 - value2, throwsArgumentError);
  });
}
