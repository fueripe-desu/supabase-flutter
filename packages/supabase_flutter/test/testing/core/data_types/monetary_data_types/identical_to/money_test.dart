import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/currency/currencies.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/monetary_data_types.dart';

void main() {
  test('should return true if both are identical', () {
    final value1 = Money(r'$10.50', overrideCurrency: Currencies.usd);
    final value2 = Money(r'$10.50', overrideCurrency: Currencies.usd);
    final operation = value1.identicalTo(value2);
    expect(operation, true);
  });

  test('should return false if both have different types', () {
    final value1 = Money(r'$10.50', overrideCurrency: Currencies.usd);
    final value2 = Numeric(value: '10.50', precision: 4, scale: 2);
    final operation = value1.identicalTo(value2);
    expect(operation, false);
  });

  test('should return false if both have different currencies', () {
    final value1 = Money(r'$10.50', overrideCurrency: Currencies.usd);
    final value2 = Money(r'R$10,50', overrideCurrency: Currencies.brl);
    final operation = value1.identicalTo(value2);
    expect(operation, false);
  });

  test('should return false if both have different values', () {
    final value1 = Money(r'$10.50', overrideCurrency: Currencies.usd);
    final value2 = Money(r'$20.50', overrideCurrency: Currencies.usd);
    final operation = value1.identicalTo(value2);
    expect(operation, false);
  });
}
