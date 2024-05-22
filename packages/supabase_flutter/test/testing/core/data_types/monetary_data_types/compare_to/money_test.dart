import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/currency/currencies.dart';
import 'package:supabase_flutter/src/testing/core/data_types/monetary_data_types.dart';

void main() {
  test('should return 1 when performing positive comparison (greater)', () {
    final value1 = Money(r'$20.00', overrideCurrency: Currencies.usd);
    final value2 = Money(r'$10.00', overrideCurrency: Currencies.usd);
    final operation = value1.compareTo(value2);
    expect(operation, 1);
  });

  test('should return -1 when performing positive comparison (less)', () {
    final value1 = Money(r'$20.00', overrideCurrency: Currencies.usd);
    final value2 = Money(r'$30.00', overrideCurrency: Currencies.usd);
    final operation = value1.compareTo(value2);
    expect(operation, -1);
  });

  test('should return 0 when performing positive comparison (equal)', () {
    final value1 = Money(r'$20.00', overrideCurrency: Currencies.usd);
    final value2 = Money(r'$20.00', overrideCurrency: Currencies.usd);
    final operation = value1.compareTo(value2);
    expect(operation, 0);
  });

  test('should return 1 when performing negative comparison (greater)', () {
    final value1 = Money(r'-$20.00', overrideCurrency: Currencies.usd);
    final value2 = Money(r'-$30.00', overrideCurrency: Currencies.usd);
    final operation = value1.compareTo(value2);
    expect(operation, 1);
  });

  test('should return -1 when performing negative comparison (less)', () {
    final value1 = Money(r'-$20.00', overrideCurrency: Currencies.usd);
    final value2 = Money(r'-$10.00', overrideCurrency: Currencies.usd);
    final operation = value1.compareTo(value2);
    expect(operation, -1);
  });

  test('should return 0 when performing negative comparison (equal)', () {
    final value1 = Money(r'-$20.00', overrideCurrency: Currencies.usd);
    final value2 = Money(r'-$20.00', overrideCurrency: Currencies.usd);
    final operation = value1.compareTo(value2);
    expect(operation, 0);
  });

  test(
      'should return 1 when performing mixed sign comparison (positive + negative)',
      () {
    final value1 = Money(r'$20.00', overrideCurrency: Currencies.usd);
    final value2 = Money(r'-$10.00', overrideCurrency: Currencies.usd);
    final operation = value1.compareTo(value2);
    expect(operation, 1);
  });

  test(
      'should return -1 when performing mixed sign comparison (negative + positive)',
      () {
    final value1 = Money(r'-$20.00', overrideCurrency: Currencies.usd);
    final value2 = Money(r'$10.00', overrideCurrency: Currencies.usd);
    final operation = value1.compareTo(value2);
    expect(operation, -1);
  });

  test('should return 1 when performing zero comparison (greater)', () {
    final value1 = Money(r'$20.00', overrideCurrency: Currencies.usd);
    final value2 = Money(r'$0.00', overrideCurrency: Currencies.usd);
    final operation = value1.compareTo(value2);
    expect(operation, 1);
  });

  test('should return -1 when performing zero comparison (less)', () {
    final value1 = Money(r'-$20.00', overrideCurrency: Currencies.usd);
    final value2 = Money(r'$0.00', overrideCurrency: Currencies.usd);
    final operation = value1.compareTo(value2);
    expect(operation, -1);
  });

  test('should return 0 when performing zero comparison (equal)', () {
    final value1 = Money(r'$0.00', overrideCurrency: Currencies.usd);
    final value2 = Money(r'$0.00', overrideCurrency: Currencies.usd);
    final operation = value1.compareTo(value2);
    expect(operation, 0);
  });

  test('should return 0 when comparing positive zero to negative zero', () {
    final value1 = Money(r'$0.00', overrideCurrency: Currencies.usd);
    final value2 = Money(r'-$0.00', overrideCurrency: Currencies.usd);
    final operation = value1.compareTo(value2);
    expect(operation, 0);
  });

  test('should return 0 when comparing negative zero to positive zero', () {
    final value1 = Money(r'-$0.00', overrideCurrency: Currencies.usd);
    final value2 = Money(r'$0.00', overrideCurrency: Currencies.usd);
    final operation = value1.compareTo(value2);
    expect(operation, 0);
  });

  test('should throw ArgumentError if one of the operands is not Money', () {
    final value1 = Money(r'$0.00', overrideCurrency: Currencies.usd);
    const value2 = double.nan;
    expect(() => value1.compareTo(value2), throwsArgumentError);
  });
}
