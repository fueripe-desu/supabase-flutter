import 'package:supabase_flutter/src/testing/core/currency/money_validator.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/character_data_types.dart';

class MoneyBuilder {
  Numeric build(String amount, Currency currency) {
    final result = MoneyValidator().validate(amount, currency);

    if (!result.isValid) {
      throw ArgumentError(result.message);
    }

    final trimmed = amount.trim();
    final isNegative = _isNegative(trimmed, currency.symbol);

    late final String withoutNegation;
    if (isNegative) {
      withoutNegation = _removeNegation(trimmed, currency.symbol);
    } else {
      withoutNegation = trimmed;
    }

    final withoutSymbol =
        withoutNegation.replaceFirst(currency.symbol, '').trim();
    final withoutGroup =
        withoutSymbol.replaceAll(currency.groupSeparator, '').trim();
    final adjustedScale = _adjustScale(withoutGroup, currency).trim();
    final (decimalPart, integerPart) = _extractValues(adjustedScale, currency);
    final minorUnits = (integerPart * currency.minorUnitsInMajor) + decimalPart;
    final signed = isNegative ? minorUnits * -1 : minorUnits;

    return signed as Numeric;
  }

  String minorUnitsToString(Numeric minorUnits, Currency currency) {
    final isNegative = minorUnits.isNegative;
    final (minor, major) = _calculateMinorAndMajor(minorUnits, currency);
    final majorString = _addGroupSeparator(major, currency);
    final amount = _assembleMinorAndMajor(minor, majorString, currency);

    return _addSymbol(amount, isNegative, currency);
  }

  String _addGroupSeparator(Numeric major, Currency currency) {
    List<String> newMajor = [];
    final splitted = major.toString().split('').reversed.toList();

    for (int i = 0; i < splitted.length; i++) {
      if (i % 3 == 0 && i != 0) {
        newMajor.insert(0, currency.groupSeparator);
      }

      newMajor.insert(0, splitted[i]);
    }

    return newMajor.join('');
  }

  String _addSymbol(
    String amount,
    bool isNegative,
    Currency currency,
  ) {
    late final String finalValue;
    if (currency.placeSymbolBefore) {
      finalValue = currency.symbol + amount;
    } else {
      finalValue = amount + currency.symbol;
    }

    if (isNegative) {
      return '-$finalValue';
    } else {
      return finalValue;
    }
  }

  String _assembleMinorAndMajor(
    Numeric? minor,
    String major,
    Currency currency,
  ) {
    if (currency.decimalSeparator != null) {
      final minorString = minor.toString();
      final minorPadded = minorString.padRight(currency.scalePrecision, '0');

      return major + currency.decimalSeparator! + minorPadded;
    } else {
      return major;
    }
  }

  (Numeric?, Numeric) _calculateMinorAndMajor(
    Numeric minorUnits,
    Currency currency,
  ) {
    if (currency.decimalSeparator == null) {
      return (null, minorUnits.abs());
    } else {
      final minor = minorUnits % currency.minorUnitsInMajor;
      final major = (minorUnits - minor) / currency.minorUnitsInMajor;
      final newMajor = (major as Numeric).truncate().abs();
      final rawMinor = (minor as Numeric).truncate().abs();
      final newMinor = Numeric(
        value: rawMinor.value,
        precision: currency.scalePrecision,
        scale: 0,
      );

      return (newMinor, newMajor);
    }
  }

  String _adjustScale(String amount, Currency currency) {
    if (currency.decimalSeparator != null) {
      if (amount.contains(currency.decimalSeparator!)) {
        final splitted = amount.split(currency.decimalSeparator!);
        final decimalPart = Char(splitted[1], length: currency.scalePrecision);
        return splitted[0] + currency.decimalSeparator! + decimalPart.value;
      }
    }

    return amount;
  }

  bool _isNegative(String value, String symbol) {
    final last = value.length - 1;
    if (value[0] == '-') {
      return true;
    } else if (value[last] == '-') {
      return true;
    } else if (value[0] == '(' && value[last] == ')') {
      return true;
    } else if (value.contains('-') && value.indexOf('-') == symbol.length) {
      return true;
    }

    return false;
  }

  String _removeNegation(String value, String symbol) {
    final last = value.length - 1;
    if (value[0] == '-') {
      return value.substring(1).trim();
    } else if (value[last] == '-') {
      return value.substring(0, last).trim();
    } else if (value[0] == '(' && value[last] == ')') {
      return value.substring(1, last).trim();
    } else if (value.contains('-') && value.indexOf('-') == symbol.length) {
      final splitted = value.split('');
      splitted.removeAt(symbol.length);
      return splitted.join('');
    } else {
      throw ArgumentError('Value is not negative.');
    }
  }

  (Numeric, Numeric) _extractValues(String value, Currency currency) {
    late final String? decimalPart;
    late final String integerPart;

    if (currency.decimalSeparator == null) {
      decimalPart = null;
      integerPart = value;
    } else {
      if (value.contains(currency.decimalSeparator!)) {
        final splitted = value.split(currency.decimalSeparator!);
        decimalPart = splitted[1];
        integerPart = splitted[0];
      } else {
        decimalPart = '0' * currency.scalePrecision;
        integerPart = value;
      }
    }

    final trimmedInt = integerPart.trim();
    final trimmedDec = (decimalPart ?? '0').trim();
    final parsedInteger = Numeric(
      value: trimmedInt,
      precision: trimmedInt.length,
      scale: 0,
    );

    final parsedDecimal = Numeric(
      value: trimmedDec,
      precision: trimmedDec.length,
      scale: 0,
    );

    return (parsedDecimal, parsedInteger);
  }
}

class Currency {
  final String symbol;
  final String groupSeparator;
  final String? decimalSeparator;
  final int scalePrecision;
  final bool placeSymbolBefore;
  final int minorUnitsInMajor;

  Currency({
    required this.symbol,
    required this.minorUnitsInMajor,
    required this.groupSeparator,
    required this.scalePrecision,
    required this.placeSymbolBefore,
    this.decimalSeparator,
  }) {
    if (decimalSeparator != null && decimalSeparator!.length > 1) {
      throw ArgumentError(
        'Decimal separator cannot have length greater than 1.',
      );
    }

    if (groupSeparator.length != 1) {
      throw ArgumentError(
        'Group separator must have length equal to 1.',
      );
    }

    if (groupSeparator == decimalSeparator) {
      throw ArgumentError(
        'Group and decimal separator cannot be equal.',
      );
    }

    if (minorUnitsInMajor < 1) {
      throw ArgumentError(
        'Minor units should be positive and not zero.',
      );
    }

    if (scalePrecision < 0) {
      throw ArgumentError(
        'Scale precision cannot be negative.',
      );
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Currency) return false;
    return symbol == other.symbol &&
        groupSeparator == other.groupSeparator &&
        decimalSeparator == other.decimalSeparator &&
        scalePrecision == other.scalePrecision &&
        placeSymbolBefore == other.placeSymbolBefore &&
        minorUnitsInMajor == other.minorUnitsInMajor;
  }

  @override
  int get hashCode {
    return Object.hash(
      symbol,
      groupSeparator,
      decimalSeparator,
      scalePrecision,
      placeSymbolBefore,
      minorUnitsInMajor,
    );
  }

  Currency copyWith({
    String? symbol,
    String? groupSeparator,
    String? decimalSeparator,
    int? scalePrecision,
    bool? placeSymbolBefore,
    int? minorUnitsInMajor,
  }) {
    return Currency(
      symbol: symbol ?? this.symbol,
      groupSeparator: groupSeparator ?? this.groupSeparator,
      decimalSeparator: decimalSeparator ?? this.decimalSeparator,
      scalePrecision: scalePrecision ?? this.scalePrecision,
      placeSymbolBefore: placeSymbolBefore ?? this.placeSymbolBefore,
      minorUnitsInMajor: minorUnitsInMajor ?? this.minorUnitsInMajor,
    );
  }
}
