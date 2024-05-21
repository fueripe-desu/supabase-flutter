import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/currency/currency.dart';
import 'package:supabase_flutter/src/testing/core/currency/money_validator.dart';

// Set this to 'true' if you want to print errors logs.
// If no error occurs then 'null' will be printed.
const bool logFilterErrors = false;

void main() {
  late final bool Function(String input, Currency currency) validate;

  final dollar = Currency(
    symbol: r'$',
    decimalSeparator: '.',
    groupSeparator: ',',
    scalePrecision: 2,
    minorUnitsInMajor: 100,
    placeSymbolBefore: true,
  );

  final fakeCurrency = Currency(
    symbol: r'$/.',
    decimalSeparator: '.',
    groupSeparator: ',',
    scalePrecision: 2,
    minorUnitsInMajor: 100,
    placeSymbolBefore: true,
  );

  setUpAll(() {
    validate = (input, currency) {
      final result = MoneyValidator().validate(input, currency);

      if (logFilterErrors) {
        print(result.message);
      }

      return result.isValid;
    };
  });

  test('should return true if the value is correctly formatted', () {
    expect(validate(r'$100', dollar), true);
  });

  test('should return true if value has no symbol and decimal part', () {
    expect(validate(r'100', dollar), true);
  });

  test('should return true if value has no symbol', () {
    expect(validate(r'100.123', dollar), true);
  });

  test(
      'should return false when there is more than one occurrence of the currency symbol',
      () {
    expect(validate(r'$100.00$', dollar), false);
  });

  test('should return false if symbol is not the one specified by the currency',
      () {
    expect(validate(r'R$100.00', dollar), false);
  });

  test(
      'should return false when there is more than one occurrence of the decimal separator',
      () {
    expect(validate(r'$100.00.00', dollar), false);
  });

  test('should return false if symbol is not before the number', () {
    expect(validate(r'100.00$', dollar), false);
  });

  test('should return true if symbol is before the number', () {
    expect(validate(r'$100.00', dollar), true);
  });

  test('should return false if symbol is not after the number', () {
    final newDollar = dollar.copyWith(placeSymbolBefore: false);
    expect(validate(r'$100.00', newDollar), false);
  });

  test('should return true if symbol is after the number', () {
    final newDollar = dollar.copyWith(placeSymbolBefore: false);
    expect(validate(r'100.00$', newDollar), true);
  });

  test('should return true if scale is not specified', () {
    expect(validate(r'$100', dollar), true);
  });

  test('should ignore misplaced group separators', () {
    expect(validate(r'$12,34.56', dollar), true);
  });

  test('should allow numbers without group separators', () {
    expect(validate(r'$1234.56', dollar), true);
  });

  test('should return false when switching the decimal and group separators',
      () {
    expect(validate(r'$1.234,56', dollar), false);
  });

  test('should not consider the space between the symbol and the number', () {
    final newDollar = dollar.copyWith(
      groupSeparator: ' ',
      placeSymbolBefore: false,
    );
    expect(validate(r'1 234.56 $', newDollar), true);
  });

  test(
      'should return true if value is negated correctly with minus sign before symbol',
      () {
    expect(validate(r'-$1234.56', dollar), true);
  });

  test(
      'should return true if value without symbol is negated correctly with minus sign before symbol',
      () {
    expect(validate(r'-1234.56', dollar), true);
  });

  test(
      'should return true if value is negated correctly with minus sign after the number',
      () {
    expect(validate(r'$1234.56-', dollar), true);
  });

  test(
      'should return true if value without symbol is negated correctly with minus sign after the number',
      () {
    expect(validate(r'1234.56-', dollar), true);
  });

  test(
      'should return true if value is negated correctly with minus sign after the symbol',
      () {
    expect(validate(r'$-1234.56', dollar), true);
  });

  test('should return true if symbol is after the amount and negation before',
      () {
    final newDollar = dollar.copyWith(placeSymbolBefore: false);
    expect(validate(r'-1234.56$', newDollar), true);
  });

  test('should return true if value is negated correctly with parentheses', () {
    expect(validate(r'($1234.56)', dollar), true);
  });

  test(
      'should return true if value without symbol is negated correctly with parentheses',
      () {
    expect(validate(r'(1234.56)', dollar), true);
  });

  test('should return false if more than one negation method is used', () {
    expect(validate(r'-($-1234.56)-', dollar), false);
  });

  test('should return false if value contains invalid characters', () {
    expect(validate(r'$100a', dollar), false);
  });

  test(
      'should not count symbol as decimal separator when both share a common character',
      () {
    expect(validate(r'$/.100.25', fakeCurrency), true);
  });
}
