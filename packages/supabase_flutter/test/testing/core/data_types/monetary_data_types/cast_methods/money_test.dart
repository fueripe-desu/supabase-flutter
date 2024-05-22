import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/currency/currencies.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/character_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/monetary_data_types.dart';

void main() {
  group('toString() method', () {
    test('should cast to string correctly', () {
      final value = Money(r'$10.35', overrideCurrency: Currencies.usd);
      const expected = r'$10.35';
      final operation = value.toString();
      expect(operation == expected, true);
    });
    test('should cast correctly if value does not have decimal part', () {
      final value = Money(r'$10', overrideCurrency: Currencies.usd);
      const expected = r'$10.00';
      final operation = value.toString();
      expect(operation == expected, true);
    });

    test('should cast correctly negative values', () {
      final value = Money(r'-$10.35', overrideCurrency: Currencies.usd);
      const expected = r'-$10.35';
      final operation = value.toString();
      expect(operation == expected, true);
    });

    test('should correctly cast if symbol comes before amount', () {
      final value = Money(r'$10.35', overrideCurrency: Currencies.usd);
      const expected = r'$10.35';
      final operation = value.toString();
      expect(operation == expected, true);
    });

    test('should correctly cast if symbol comes after amount', () {
      final value = Money(r'10,35Kz', overrideCurrency: Currencies.aoa);
      const expected = r'10,35Kz';
      final operation = value.toString();
      expect(operation == expected, true);
    });

    test('should correctly cast if decimal separator is dot', () {
      final value = Money(r'$10.35', overrideCurrency: Currencies.usd);
      const expected = r'$10.35';
      final operation = value.toString();
      expect(operation == expected, true);
    });

    test('should correctly cast if decimal separator is comma', () {
      final value = Money(r'R$10,35', overrideCurrency: Currencies.brl);
      const expected = r'R$10,35';
      final operation = value.toString();
      expect(operation == expected, true);
    });

    test('should correctly cast if precision is 3', () {
      final value = Money(r'10.357ب.د', overrideCurrency: Currencies.bhd);
      const expected = r'10.357ب.د';
      final operation = value.toString();
      expect(operation == expected, true);
    });
  });

  group('toDetailedString() method', () {
    test('should cast to string correctly', () {
      final value = Money(r'$10.35', overrideCurrency: Currencies.usd);
      const expected = r'Value: $10.35, Currency: USD (United States Dollar)';
      final operation = value.toDetailedString();
      expect(operation == expected, true);
    });

    test('should cast correctly if value does not have decimal part', () {
      final value = Money(r'$10', overrideCurrency: Currencies.usd);
      const expected = r'Value: $10.00, Currency: USD (United States Dollar)';
      final operation = value.toDetailedString();
      expect(operation == expected, true);
    });

    test('should correctly cast if symbol comes before amount', () {
      final value = Money(r'$10.35', overrideCurrency: Currencies.usd);
      const expected = r'Value: $10.35, Currency: USD (United States Dollar)';
      final operation = value.toDetailedString();
      expect(operation == expected, true);
    });

    test('should correctly cast if symbol comes after amount', () {
      final value = Money(r'10,35Kz', overrideCurrency: Currencies.aoa);
      const expected = r'Value: 10,35Kz, Currency: AOA (Angolan Kwanza)';
      final operation = value.toDetailedString();
      expect(operation == expected, true);
    });

    test('should correctly cast if decimal separator is dot', () {
      final value = Money(r'$10.35', overrideCurrency: Currencies.usd);
      const expected = r'Value: $10.35, Currency: USD (United States Dollar)';
      final operation = value.toDetailedString();
      expect(operation == expected, true);
    });

    test('should correctly cast if decimal separator is comma', () {
      final value = Money(r'R$10,35', overrideCurrency: Currencies.brl);
      const expected = r'Value: R$10,35, Currency: BRL (Brazilian Real)';
      final operation = value.toDetailedString();
      expect(operation == expected, true);
    });

    test('should correctly cast if precision is 3', () {
      final value = Money(r'10.357ب.د', overrideCurrency: Currencies.bhd);
      const expected = r'Value: 10.357ب.د, Currency: BHD (Bahraini Dinar)';
      final operation = value.toDetailedString();
      expect(operation == expected, true);
    });
  });

  group('toPrimitiveInt() method', () {
    test('should throw UnsupportedError when trying to cast', () {
      final value = Money(r'$10.35', overrideCurrency: Currencies.usd);
      expect(() => value.toPrimitiveInt(), throwsUnsupportedError);
    });
  });

  group('toPrimitiveDouble() method', () {
    test('should throw UnsupportedError when trying to cast', () {
      final value = Money(r'$10.35', overrideCurrency: Currencies.usd);
      expect(() => value.toPrimitiveDouble(), throwsUnsupportedError);
    });
  });

  group('toBigInteger() method', () {
    test('should throw UnsupportedError when trying to cast', () {
      final value = Money(r'$10.35', overrideCurrency: Currencies.usd);
      expect(() => value.toBigInteger(), throwsUnsupportedError);
    });
  });

  group('toInteger() method', () {
    test('should throw UnsupportedError when trying to cast', () {
      final value = Money(r'$10.35', overrideCurrency: Currencies.usd);
      expect(() => value.toInteger(), throwsUnsupportedError);
    });
  });

  group('toSmallInteger() method', () {
    test('should throw UnsupportedError when trying to cast', () {
      final value = Money(r'$10.35', overrideCurrency: Currencies.usd);
      expect(() => value.toSmallInteger(), throwsUnsupportedError);
    });
  });

  group('toBigSerial() method', () {
    test('should throw UnsupportedError when trying to cast', () {
      final value = Money(r'$10.35', overrideCurrency: Currencies.usd);
      expect(() => value.toBigSerial(), throwsUnsupportedError);
    });
  });

  group('toSerial() method', () {
    test('should throw UnsupportedError when trying to cast', () {
      final value = Money(r'$10.35', overrideCurrency: Currencies.usd);
      expect(() => value.toSerial(), throwsUnsupportedError);
    });
  });

  group('toSmallSerial() method', () {
    test('should throw UnsupportedError when trying to cast', () {
      final value = Money(r'$10.35', overrideCurrency: Currencies.usd);
      expect(() => value.toSmallSerial(), throwsUnsupportedError);
    });
  });

  group('toReal() method', () {
    test('should throw UnsupportedError when trying to cast', () {
      final value = Money(r'$10.35', overrideCurrency: Currencies.usd);
      expect(() => value.toReal(), throwsUnsupportedError);
    });
  });

  group('toDoublePrecision() method', () {
    test('should throw UnsupportedError when trying to cast', () {
      final value = Money(r'$10.35', overrideCurrency: Currencies.usd);
      expect(() => value.toDoublePrecision(), throwsUnsupportedError);
    });
  });

  group('toNumeric() method', () {
    test('should cast correctly when positive value has decimal part', () {
      final value = Money(r'$10.35', overrideCurrency: Currencies.usd);
      final expected = Numeric(value: '10.35', precision: 4, scale: 2);
      final operation = value.toNumeric();
      expect(operation == expected, true);
    });

    test('should cast correctly when positive value is integer-valued', () {
      final value = Money(r'$10', overrideCurrency: Currencies.usd);
      final expected = Numeric(value: '10.00', precision: 4, scale: 2);
      final operation = value.toNumeric();
      expect(operation == expected, true);
    });

    test('should cast correctly when positive value has scale 3', () {
      final value = Money(r'10.357ب.د', overrideCurrency: Currencies.bhd);
      final expected = Numeric(value: '10.357', precision: 5, scale: 3);
      final operation = value.toNumeric();
      expect(operation == expected, true);
    });

    test('should cast correctly when negative value has decimal part', () {
      final value = Money(r'-$10.35', overrideCurrency: Currencies.usd);
      final expected = Numeric(value: '-10.35', precision: 4, scale: 2);
      final operation = value.toNumeric();
      expect(operation == expected, true);
    });

    test('should cast correctly when negative value is integer-valued', () {
      final value = Money(r'-$10', overrideCurrency: Currencies.usd);
      final expected = Numeric(value: '-10.00', precision: 4, scale: 2);
      final operation = value.toNumeric();
      expect(operation == expected, true);
    });

    test('should cast correctly when negative value has scale 3', () {
      final value = Money(r'-10.357ب.د', overrideCurrency: Currencies.bhd);
      final expected = Numeric(value: '-10.357', precision: 5, scale: 3);
      final operation = value.toNumeric();
      expect(operation == expected, true);
    });
  });

  group('toDecimal() method', () {
    test('should cast correctly when positive value has decimal part', () {
      final value = Money(r'$10.35', overrideCurrency: Currencies.usd);
      final expected = Decimal(value: '10.35', precision: 4, scale: 2);
      final operation = value.toDecimal();
      expect(operation == expected, true);
    });

    test('should cast correctly when positive value is integer-valued', () {
      final value = Money(r'$10', overrideCurrency: Currencies.usd);
      final expected = Decimal(value: '10.00', precision: 4, scale: 2);
      final operation = value.toDecimal();
      expect(operation == expected, true);
    });

    test('should cast correctly when positive value has scale 3', () {
      final value = Money(r'10.357ب.د', overrideCurrency: Currencies.bhd);
      final expected = Decimal(value: '10.357', precision: 5, scale: 3);
      final operation = value.toDecimal();
      expect(operation == expected, true);
    });

    test('should cast correctly when negative value has decimal part', () {
      final value = Money(r'-$10.35', overrideCurrency: Currencies.usd);
      final expected = Decimal(value: '-10.35', precision: 4, scale: 2);
      final operation = value.toDecimal();
      expect(operation == expected, true);
    });

    test('should cast correctly when negative value is integer-valued', () {
      final value = Money(r'-$10', overrideCurrency: Currencies.usd);
      final expected = Decimal(value: '-10.00', precision: 4, scale: 2);
      final operation = value.toDecimal();
      expect(operation == expected, true);
    });

    test('should cast correctly when negative value has scale 3', () {
      final value = Money(r'-10.357ب.د', overrideCurrency: Currencies.bhd);
      final expected = Decimal(value: '-10.357', precision: 5, scale: 3);
      final operation = value.toDecimal();
      expect(operation == expected, true);
    });
  });

  group('toChar() method', () {
    test('should cast to string correctly', () {
      final value = Money(r'$10.35', overrideCurrency: Currencies.usd);
      final expected = Char(r'$10.35', length: 6);
      final operation = value.toChar();
      expect(operation == expected, true);
    });
    test('should cast correctly if value does not have decimal part', () {
      final value = Money(r'$10', overrideCurrency: Currencies.usd);
      final expected = Char(r'$10.00', length: 6);
      final operation = value.toChar();
      expect(operation == expected, true);
    });

    test('should cast correctly negative values', () {
      final value = Money(r'-$10.35', overrideCurrency: Currencies.usd);
      final expected = Char(r'-$10.35', length: 7);
      final operation = value.toChar();
      expect(operation == expected, true);
    });

    test('should correctly cast if symbol comes before amount', () {
      final value = Money(r'$10.35', overrideCurrency: Currencies.usd);
      final expected = Char(r'$10.35', length: 6);
      final operation = value.toChar();
      expect(operation == expected, true);
    });

    test('should correctly cast if symbol comes after amount', () {
      final value = Money(r'10,35Kz', overrideCurrency: Currencies.aoa);
      final expected = Char(r'10,35Kz', length: 7);
      final operation = value.toChar();
      expect(operation == expected, true);
    });

    test('should correctly cast if decimal separator is dot', () {
      final value = Money(r'$10.35', overrideCurrency: Currencies.usd);
      final expected = Char(r'$10.35', length: 6);
      final operation = value.toChar();
      expect(operation == expected, true);
    });

    test('should correctly cast if decimal separator is comma', () {
      final value = Money(r'R$10,35', overrideCurrency: Currencies.brl);
      final expected = Char(r'R$10,35', length: 7);
      final operation = value.toChar();
      expect(operation == expected, true);
    });

    test('should correctly cast if precision is 3', () {
      final value = Money(r'10.357ب.د', overrideCurrency: Currencies.bhd);
      final expected = Char(r'10.357ب.د', length: 9);
      final operation = value.toChar();
      expect(operation == expected, true);
    });
  });

  group('toVarChar() method', () {
    test('should cast to string correctly', () {
      final value = Money(r'$10.35', overrideCurrency: Currencies.usd);
      final expected = VarChar(r'$10.35', length: 6);
      final operation = value.toVarChar();
      expect(operation == expected, true);
    });
    test('should cast correctly if value does not have decimal part', () {
      final value = Money(r'$10', overrideCurrency: Currencies.usd);
      final expected = VarChar(r'$10.00', length: 6);
      final operation = value.toVarChar();
      expect(operation == expected, true);
    });

    test('should cast correctly negative values', () {
      final value = Money(r'-$10.35', overrideCurrency: Currencies.usd);
      final expected = VarChar(r'-$10.35', length: 7);
      final operation = value.toVarChar();
      expect(operation == expected, true);
    });

    test('should correctly cast if symbol comes before amount', () {
      final value = Money(r'$10.35', overrideCurrency: Currencies.usd);
      final expected = VarChar(r'$10.35', length: 6);
      final operation = value.toVarChar();
      expect(operation == expected, true);
    });

    test('should correctly cast if symbol comes after amount', () {
      final value = Money(r'10,35Kz', overrideCurrency: Currencies.aoa);
      final expected = VarChar(r'10,35Kz', length: 7);
      final operation = value.toVarChar();
      expect(operation == expected, true);
    });

    test('should correctly cast if decimal separator is dot', () {
      final value = Money(r'$10.35', overrideCurrency: Currencies.usd);
      final expected = VarChar(r'$10.35', length: 6);
      final operation = value.toVarChar();
      expect(operation == expected, true);
    });

    test('should correctly cast if decimal separator is comma', () {
      final value = Money(r'R$10,35', overrideCurrency: Currencies.brl);
      final expected = VarChar(r'R$10,35', length: 7);
      final operation = value.toVarChar();
      expect(operation == expected, true);
    });

    test('should correctly cast if precision is 3', () {
      final value = Money(r'10.357ب.د', overrideCurrency: Currencies.bhd);
      final expected = VarChar(r'10.357ب.د', length: 9);
      final operation = value.toVarChar();
      expect(operation == expected, true);
    });
  });

  group('toText() method', () {
    test('should cast to string correctly', () {
      final value = Money(r'$10.35', overrideCurrency: Currencies.usd);
      final expected = Text(r'$10.35');
      final operation = value.toText();
      expect(operation == expected, true);
    });
    test('should cast correctly if value does not have decimal part', () {
      final value = Money(r'$10', overrideCurrency: Currencies.usd);
      final expected = Text(r'$10.00');
      final operation = value.toText();
      expect(operation == expected, true);
    });

    test('should cast correctly negative values', () {
      final value = Money(r'-$10.35', overrideCurrency: Currencies.usd);
      final expected = Text(r'-$10.35');
      final operation = value.toText();
      expect(operation == expected, true);
    });

    test('should correctly cast if symbol comes before amount', () {
      final value = Money(r'$10.35', overrideCurrency: Currencies.usd);
      final expected = Text(r'$10.35');
      final operation = value.toText();
      expect(operation == expected, true);
    });

    test('should correctly cast if symbol comes after amount', () {
      final value = Money(r'10,35Kz', overrideCurrency: Currencies.aoa);
      final expected = Text(r'10,35Kz');
      final operation = value.toText();
      expect(operation == expected, true);
    });

    test('should correctly cast if decimal separator is dot', () {
      final value = Money(r'$10.35', overrideCurrency: Currencies.usd);
      final expected = Text(r'$10.35');
      final operation = value.toText();
      expect(operation == expected, true);
    });

    test('should correctly cast if decimal separator is comma', () {
      final value = Money(r'R$10,35', overrideCurrency: Currencies.brl);
      final expected = Text(r'R$10,35');
      final operation = value.toText();
      expect(operation == expected, true);
    });

    test('should correctly cast if precision is 3', () {
      final value = Money(r'10.357ب.د', overrideCurrency: Currencies.bhd);
      final expected = Text(r'10.357ب.د');
      final operation = value.toText();
      expect(operation == expected, true);
    });
  });
}
