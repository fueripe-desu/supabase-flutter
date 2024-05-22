import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/currency/currencies.dart';
import 'package:supabase_flutter/src/testing/core/currency/currency.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';

void main() {
  final dollar = Currencies.usd;

  group('currency', () {
    test(
        'should throw an ArgumentError when currency name has length different from 3',
        () {
      expect(() => dollar.copyWith(currencyName: 'US'), throwsArgumentError);
    });

    test(
        'should throw an ArgumentError when the decimal separator has a length greater than 1',
        () {
      expect(
          () => dollar.copyWith(decimalSeparator: '...'), throwsArgumentError);
    });

    test(
        'should throw an ArgumentError when the group separator has a length different than 1',
        () {
      expect(() => dollar.copyWith(groupSeparator: ',,,'), throwsArgumentError);
      expect(() => dollar.copyWith(groupSeparator: ''), throwsArgumentError);
    });

    test(
        'should throw an ArgumentError if group and decimal separators are equal',
        () {
      expect(
        () => dollar.copyWith(groupSeparator: '.', decimalSeparator: '.'),
        throwsArgumentError,
      );
    });

    test('should throw an ArgumentError if minor units is negative', () {
      expect(
          () => dollar.copyWith(minorUnitsInMajor: -100), throwsArgumentError);
    });

    test('should throw an ArgumentError if minor units is zero', () {
      expect(() => dollar.copyWith(minorUnitsInMajor: 0), throwsArgumentError);
    });

    test('should throw an ArgumentError if scale precision is negative', () {
      expect(() => dollar.copyWith(scalePrecision: -2), throwsArgumentError);
    });
  });

  group('money parsing', () {
    late final bool Function(
      String input,
      Currency currency,
      Numeric expected,
    ) parse;

    late final Currency brl;
    late final Currency bif;

    setUpAll(() {
      parse = (input, currency, expected) {
        final result = MoneyBuilder().build(input, currency);

        return result.identicalTo(expected);
      };

      brl = Currencies.usd;
      bif = Currencies.bif;
    });

    test('should return true if a valid string is given', () {
      expect(
        parse(r'R$ 99,99', brl, Numeric(value: '9999', precision: 4, scale: 0)),
        true,
      );
    });

    test('shouldbe able to parse a currency without the currency symbol', () {
      expect(
        parse(r'99,99', brl, Numeric(value: '9999', precision: 4, scale: 0)),
        true,
      );
    });

    test('should throw an ArgumentError if an invalid string is given', () {
      expect(
        () => parse(r'R$ 99,99R$', brl, Numeric(value: '9999')),
        throwsArgumentError,
      );
    });

    test('should be able to parse values without decimal places', () {
      expect(
        parse(r'R$ 99', brl, Numeric(value: '9900', precision: 4, scale: 0)),
        true,
      );
    });

    test('should be able to parse large values without group separators', () {
      expect(
        parse(
          r'R$ 501234,22',
          brl,
          Numeric(value: '50123422', precision: 8, scale: 0),
        ),
        true,
      );
    });

    test(
        'should be able to parse large values with group separators incorrectly positioned',
        () {
      expect(
        parse(
          r'R$ 5.0123.4,22',
          brl,
          Numeric(value: '50123422', precision: 8, scale: 0),
        ),
        true,
      );
    });

    test(
        'should be able to parse currencies that do not support decimal places',
        () {
      expect(
        parse(
          r'501,234 FBu',
          bif,
          Numeric(value: '50123400', precision: 8, scale: 0),
        ),
        true,
      );
    });

    test(
        'should be able to parse negative amounts with minus before the symbol',
        () {
      expect(
        parse(
          r'-R$ 1234,56',
          brl,
          Numeric(value: '-123456', precision: 7, scale: 0),
        ),
        true,
      );
    });

    test('should be able to parse negative amounts with minus after the symbol',
        () {
      expect(
        parse(
          r'R$-1234,56',
          brl,
          Numeric(value: '-123456', precision: 7, scale: 0),
        ),
        true,
      );
    });

    test('should be able to parse negative amounts with minus after the number',
        () {
      expect(
        parse(
          r'R$1234,56-',
          brl,
          Numeric(value: '-123456', precision: 7, scale: 0),
        ),
        true,
      );
    });

    test('should be able to parse negative amounts with parentheses', () {
      expect(
        parse(
          r'(R$1234,56)',
          brl,
          Numeric(value: '-123456', precision: 7, scale: 0),
        ),
        true,
      );
    });
  });
}
