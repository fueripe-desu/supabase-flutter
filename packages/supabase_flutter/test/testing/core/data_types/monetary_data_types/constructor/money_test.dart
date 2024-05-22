import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/currency/currencies.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/monetary_data_types.dart';

void main() {
  test('should successfully create Money', () {
    final value = Money(r'$20.35', overrideCurrency: Currencies.usd);
    expect(value.toString() == r'$20.35', true);
  });

  test('should successfully create negative Money', () {
    final value = Money(r'-$20.35', overrideCurrency: Currencies.usd);
    expect(value.toString() == r'-$20.35', true);
  });

  test('should use global currency if no locale is specified', () {
    final value = Money(r'$20.35');
    expect(value.toString() == r'$20.35', true);
  });

  test('should use specified locale if given', () {
    final value = Money(r'R$20,35', localeString: 'pt_BR');
    expect(value.toString() == r'R$20,35', true);
  });

  test('should use prioritize override currency over all others', () {
    final value = Money(
      r'20,35Kz',
      localeString: 'pt_BR',
      overrideCurrency: Currencies.aoa,
    );
    expect(value.toString() == r'20,35Kz', true);
  });

  test('should cut value scale if more digits than necessary were given', () {
    final value = Money(r'R$20,35123134', localeString: 'pt_BR');
    expect(value.toString() == r'R$20,35', true);
  });

  test(
      'should cut value scale add zeroes if less digits than necessary were given',
      () {
    final value = Money(r'R$20,3', localeString: 'pt_BR');
    expect(value.toString() == r'R$20,30', true);
  });

  test('should successfully create from positive minor units', () {
    final minorUnits = Numeric(value: '2020', precision: 4, scale: 0);
    final value = Money.fromMinorUnits(minorUnits, localeString: 'en_US');
    expect(value.toString() == r'$20.20', true);
  });

  test('should successfully create from negative minor units', () {
    final minorUnits = Numeric(value: '-2020', precision: 4, scale: 0);
    final value = Money.fromMinorUnits(minorUnits, localeString: 'en_US');
    expect(value.toString() == r'-$20.20', true);
  });
}
