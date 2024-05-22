import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/currency/currencies.dart';
import 'package:supabase_flutter/src/testing/core/locale/locale.dart';
import 'package:supabase_flutter/src/testing/utils/locale_data.dart';

void main() {
  late final Locale locale;

  setUpAll(() {
    locale = Locale();
  });

  group('getCurrentLocale() method', () {
    setUp(() {
      locale.reset();
    });

    test('should return the default locale', () {
      // Arrange
      final expected = LocaleData(
        localeString: Locales.en_US.localeString,
        localeCurrency: Currencies.usd,
      );

      // Act
      final value = locale.getCurrentLocale();

      // Assert
      expect(value == expected, true);
    });

    test('should return the set locale', () {
      // Arrange
      final expected = LocaleData(
        localeString: Locales.en_GB.localeString,
        localeCurrency: Currencies.gbp,
      );

      // Act
      locale.setCurrentLocale(Locales.en_GB);
      final value = locale.getCurrentLocale();

      // Assert
      expect(value == expected, true);
    });
  });

  group('getCurrentCurrency() method', () {
    setUp(() {
      locale.reset();
    });

    test('should return the default locale currency', () {
      // Arrange
      final expected = Currencies.usd;

      // Act
      final value = locale.getCurrentCurrency();

      // Assert
      expect(value == expected, true);
    });

    test('should return the set locale', () {
      // Arrange
      final expected = Currencies.gbp;

      // Act
      locale.setCurrentLocale(Locales.en_GB);
      final value = locale.getCurrentCurrency();

      // Assert
      expect(value == expected, true);
    });
  });

  group('setCurrentLocale() method', () {
    setUp(() {
      locale.reset();
    });

    test('should return the set locale', () {
      // Arrange
      final expected = LocaleData(
        localeString: Locales.pt_BR.localeString,
        localeCurrency: Currencies.brl,
      );

      // Act
      locale.setCurrentLocale(Locales.pt_BR);
      final value = locale.getCurrentLocale();

      // Assert
      expect(value == expected, true);
    });
  });

  group('setCurrentLocaleByString() method', () {
    setUp(() {
      locale.reset();
    });

    test('should return the set locale', () {
      // Arrange
      final expected = LocaleData(
        localeString: Locales.pt_BR.localeString,
        localeCurrency: Currencies.brl,
      );

      // Act
      locale.setCurrentLocaleByString('pt_BR');
      final value = locale.getCurrentLocale();

      // Assert
      expect(value == expected, true);
    });

    test('should throw ArgumentError if locale does not exist', () {
      // Assert
      expect(
        () => locale.setCurrentLocaleByString('non-existent'),
        throwsArgumentError,
      );
    });
  });

  group('addLocale() method', () {
    setUp(() {
      locale.reset();
    });

    test('should add a locale', () {
      // Arrange
      final localeToAdd = LocaleData(
        localeString: 'test_locale',
        localeCurrency: Currencies.eur,
      );
      final expected = localeToAdd;

      // Act
      locale.addLocale(localeToAdd);
      locale.setCurrentLocaleByString('test_locale');
      final value = locale.getCurrentLocale();

      // Assert
      expect(value == expected, true);
    });

    test(
        'should throw ArgumentError when adding a locale with the same name as one that already exists',
        () {
      // Arrange
      final localeToAdd = LocaleData(
        localeString: 'en_US',
        localeCurrency: Currencies.eur,
      );

      // Assert
      expect(() => locale.addLocale(localeToAdd), throwsArgumentError);
    });
  });

  group('updateLocale() method', () {
    setUp(() {
      locale.reset();
    });

    test('should update a locale', () {
      // Arrange
      final localeToAdd = LocaleData(
        localeString: 'pt_BR',
        localeCurrency: Currencies.eur,
      );
      final expected = localeToAdd;

      // Act
      locale.updateLocale(localeToAdd);
      locale.setCurrentLocaleByString('pt_BR');
      final value = locale.getCurrentLocale();

      // Assert
      expect(value == expected, true);
    });

    test('should throw ArgumentError if locale is set as current', () {
      // Arrange
      final localeToAdd = LocaleData(
        localeString: 'en_US',
        localeCurrency: Currencies.eur,
      );

      // Assert
      expect(() => locale.updateLocale(localeToAdd), throwsArgumentError);
    });

    test('should throw ArgumentError if locale does not exist', () {
      // Arrange
      final localeToAdd = LocaleData(
        localeString: 'unknown',
        localeCurrency: Currencies.eur,
      );

      // Assert
      expect(() => locale.updateLocale(localeToAdd), throwsArgumentError);
    });
  });

  group('deleteLocale() method', () {
    setUp(() {
      locale.setCurrentLocale(Locales.en_US);

      if (!locale.localeExists('ja_JP')) {
        locale.addLocale(
          LocaleData(
            localeString: Locales.ja_JP.localeString,
            localeCurrency: Currencies.jpy,
          ),
        );
      }
    });

    test('should delete a locale', () {
      // Act
      locale.deleteLocale('ja_JP');

      // Assert
      expect(locale.localeExists('ja_JP'), false);
    });

    test('should throw ArgumentError if locale is set as current', () {
      // Assert
      expect(() => locale.deleteLocale('en_US'), throwsArgumentError);
    });

    test('should throw ArgumentError if locale does not exist', () {
      // Assert
      expect(() => locale.deleteLocale('unknown'), throwsArgumentError);
    });
  });

  group('localeExists() method', () {
    setUp(() {
      locale.setCurrentLocale(Locales.en_US);
    });

    test('should return true if locale exists', () {
      // Assert
      expect(locale.localeExists('ja_JP'), true);
    });

    test('should return false if locale does not exist', () {
      // Assert
      expect(locale.localeExists('unknown'), false);
    });
  });
}
