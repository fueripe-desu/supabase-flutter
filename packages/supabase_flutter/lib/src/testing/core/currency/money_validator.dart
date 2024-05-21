import 'package:supabase_flutter/src/testing/core/currency/currency.dart';
import 'package:supabase_flutter/src/testing/supabase_test_extensions.dart';

class MoneyValidator {
  String _value = '';

  MoneyValidationResult validate(String value, Currency currency) {
    _value = value.trim();
    _removeNegation(currency.symbol);

    if (!_hasValidChars(currency)) {
      return _returnError('Money formatted incorrectly.');
    }

    if (_moreThanOneDecimalSeparator(currency.decimalSeparator, currency)) {
      return _returnError('Decimal separator appears more than once.');
    }

    if (_symbolInIncorrectPosition(currency)) {
      return _returnError('Incorrect symbol position.');
    }

    if (_invalidSeparatorsPosition(currency)) {
      return _returnError('Invalid separator position.');
    }

    _value = '';
    return const MoneyValidationResult(true);
  }

  MoneyValidationResult _returnError(String error) {
    _value = '';
    return const MoneyValidationResult(
      false,
      message: 'Invalid separator position.',
    );
  }

  void _removeNegation(String symbol) {
    final last = _value.length - 1;
    if (_value[0] == '-') {
      _value = _value.substring(1).trim();
      return;
    } else if (_value[last] == '-') {
      _value = _value.substring(0, last).trim();
      return;
    } else if (_value[0] == '(' && _value[last] == ')') {
      _value = _value.substring(1, last).trim();
      return;
    } else if (_value.contains('-') && _value.indexOf('-') == symbol.length) {
      final splitted = _value.split('');
      splitted.removeAt(symbol.length);
      _value = splitted.join('');
    }
  }

  bool _hasValidChars(Currency currency) {
    String newValue = _value;
    final decSeparator = currency.decimalSeparator;

    // If value contains the symbol remove the first appearance
    if (newValue.contains(currency.symbol)) {
      newValue = newValue.replaceFirst(currency.symbol, '').trim();
    }

    for (final char in newValue.split('')) {
      if (_isNumerical(char) || char == currency.groupSeparator) {
        continue;
      } else if (decSeparator != null && char == decSeparator) {
        continue;
      } else {
        return false;
      }
    }

    return true;
  }

  bool _moreThanOneDecimalSeparator(
    String? decimalSeparator,
    Currency currency,
  ) {
    final newValue = _value.replaceAll(currency.symbol, '');

    return decimalSeparator == null
        ? false
        : newValue.count(decimalSeparator) > 1;
  }

  bool _symbolInIncorrectPosition(Currency currency) {
    final newValue = _value.trim();
    if (_value.count(currency.symbol) == 0) {
      return false;
    }

    final symbolPos = newValue.indexOf(currency.symbol);

    if (currency.placeSymbolBefore) {
      return symbolPos != 0;
    } else {
      return symbolPos != (newValue.length - currency.symbol.length);
    }
  }

  bool _invalidSeparatorsPosition(Currency currency) {
    final newValue = _value.replaceFirst(currency.symbol, '').trim();
    if (currency.decimalSeparator == null) {
      return false;
    }

    if (newValue.count(currency.groupSeparator) == 0) {
      return false;
    }

    final decimalPos = newValue.indexOf(currency.decimalSeparator!);
    final groupPos = newValue.lastIndexOf(currency.groupSeparator);

    return decimalPos < groupPos;
  }

  bool _isNumerical(String input) => RegExp(r'^\d$').hasMatch(input);
}

class MoneyValidationResult {
  final bool isValid;
  final String? message;

  const MoneyValidationResult(this.isValid, {this.message});
}
