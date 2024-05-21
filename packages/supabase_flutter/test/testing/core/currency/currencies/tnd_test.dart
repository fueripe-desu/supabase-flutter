import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/currency/currencies.dart';
import 'package:supabase_flutter/src/testing/core/currency/currency.dart';
import 'package:supabase_flutter/src/testing/core/data_types/monetary_data_types.dart';

void main() {
  late final String Function(String amount, Currency currency) currency;

  setUpAll(() {
    currency = (amount, currency) {
      return Money(amount, overrideCurrency: currency).toString();
    };
  });

  test('should display correctly display a positive value', () {
    final currencyValue = Currencies.tnd;
    const amount = r'2123456789.325د.ت';
    const expected = r'2,123,456,789.325د.ت';
    final operation = currency(amount, currencyValue);

    expect(operation, expected);
  });

  test(
      'should display correctly display a negative value (minus before amount)',
      () {
    final currencyValue = Currencies.tnd;
    const amount = r'-20386.477د.ت';
    const expected = r'-20,386.477د.ت';
    final operation = currency(amount, currencyValue);

    expect(operation, expected);
  });

  test('should display correctly display a negative value (minus after amount)',
      () {
    final currencyValue = Currencies.tnd;
    const amount = r'20386.477د.ت-';
    const expected = r'-20,386.477د.ت';
    final operation = currency(amount, currencyValue);

    expect(operation, expected);
  });

  test('should display correctly display a negative value (with parentheses)',
      () {
    final currencyValue = Currencies.tnd;
    const amount = r'(20386.477د.ت)';
    const expected = r'-20,386.477د.ت';
    final operation = currency(amount, currencyValue);

    expect(operation, expected);
  });

  test('should display correctly display a negative value (after symbol)', () {
    final currencyValue = Currencies.tnd;
    const amount = r'-20386.477د.ت';
    const expected = r'-20,386.477د.ت';
    final operation = currency(amount, currencyValue);

    expect(operation, expected);
  });

  test(
      'should display correctly when group separators are in invalid positions',
      () {
    final currencyValue = Currencies.tnd;
    const amount = r'2,12345,6789.357د.ت';
    const expected = r'2,123,456,789.357د.ت';
    final operation = currency(amount, currencyValue);

    expect(operation, expected);
  });

  test('should display correctly when symbol is missing', () {
    final currencyValue = Currencies.tnd;
    const amount = r'2,12345,6789.357';
    const expected = r'2,123,456,789.357د.ت';
    final operation = currency(amount, currencyValue);

    expect(operation, expected);
  });
}
