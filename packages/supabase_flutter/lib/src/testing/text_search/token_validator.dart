import 'package:supabase_flutter/src/testing/text_search/text_search.dart';

class TokenValidator {
  final List<String> _tokens = [];
  int _start = 0;
  int _end = 0;

  TokenValidationResult validateTokens(List<String> tokens) {
    _tokens.addAll([...tokens]);

    if (_isQueryEmpty()) {
      return const TokenValidationResult(
        isValid: false,
        message: "Search query cannot be empty.",
      );
    }

    if (_firstTokenBinary()) {
      return TokenValidationResult(
        isValid: false,
        message:
            "First token cannot be a binary operator, got: '${tokens.first}'.",
      );
    }

    if (_firstTokenClosingParenthesis()) {
      return const TokenValidationResult(
        isValid: false,
        message: "First token cannot be a closing parenthesis.",
      );
    }

    if (_lastTokenBinary()) {
      return TokenValidationResult(
        isValid: false,
        message:
            "Last token cannot be a binary operator, got: '${tokens.last}'.",
      );
    }

    if (_lastTokenUnary()) {
      return const TokenValidationResult(
        isValid: false,
        message: "Last token cannot be a not operator.",
      );
    }

    if (_lastTokenOpeningParenthesis()) {
      return const TokenValidationResult(
        isValid: false,
        message: "Last token cannot be an opening parenthesis.",
      );
    }

    if (_incorrectUseOfUnary()) {
      return TokenValidationResult(
        isValid: false,
        message:
            "Not operator used incorrectly. It must precede an operand or a subexpression: ${_getErrorRange()}",
      );
    }

    if (_binaryPrecedingClosingParenthesis()) {
      return TokenValidationResult(
        isValid: false,
        message:
            "Binary operator used with empty second operand: ${_getErrorRange()}",
      );
    }

    if (_openingParenthesisPrecedingBinary()) {
      return TokenValidationResult(
        isValid: false,
        message:
            "Binary operator used with empty first operand: ${_getErrorRange()}",
      );
    }

    if (_invalidPrefixOperator()) {
      return TokenValidationResult(
        isValid: false,
        message: "Invalid prefix operator: ${_getErrorRange()}",
      );
    }

    if (_consecutiveBinary()) {
      return TokenValidationResult(
        isValid: false,
        message: "Consecutive binary operator: ${_getErrorRange()}",
      );
    }

    if (_binaryWithInvalidOperand()) {
      return TokenValidationResult(
        isValid: false,
        message:
            "Binary operator used with invalid operands: ${_getErrorRange()}",
      );
    }

    if (_invalidPhraseOperator()) {
      return TokenValidationResult(
        isValid: false,
        message: "Invalid phrase operator: ${_getErrorRange()}",
      );
    }

    if (_unknownOperator()) {
      return TokenValidationResult(
        isValid: false,
        message: "Unkown operator: ${_getErrorRange()}",
      );
    }

    if (_consecutiveOperands()) {
      return TokenValidationResult(
        isValid: false,
        message: "Query cannot have consecutive operands: ${_getErrorRange()}",
      );
    }

    if (_isInvalidProximity()) {
      return TokenValidationResult(
        isValid: false,
        message: "Invalid use of proximity operator: ${_getErrorRange()}",
      );
    }

    if (_areParenthesesUnbalanced()) {
      return TokenValidationResult(
        isValid: false,
        message: "Parentheses unbalanced: ${_getErrorRange()}",
      );
    }

    return const TokenValidationResult(
      isValid: true,
      message: "Query validated successfully.",
    );
  }

  bool _isQueryEmpty() => _tokens.isEmpty;

  bool _firstTokenBinary() => _isBinaryOperator(_tokens.first);

  bool _firstTokenClosingParenthesis() => _isClosingParenthesis(_tokens.first);

  bool _lastTokenBinary() => _isBinaryOperator(_tokens.last);

  bool _lastTokenUnary() => _isUnaryOperator(_tokens.last);

  bool _lastTokenOpeningParenthesis() => _isOpeningParenthesis(_tokens.last);

  bool _incorrectUseOfUnary() => _forEachToken((last, current, next) {
        if (_isUnaryOperator(current)) {
          if (_isOperand(next!) || _isOpeningParenthesis(next)) {
            return false;
          } else {
            return true;
          }
        }
        return false;
      });

  bool _unknownOperator() => _forEachToken((last, current, next) {
        if (RegExp(r"[^a-z0-9&|!()<>:*'-]").hasMatch(current)) {
          return true;
        }

        if (current == '>') {
          if (next == '>') {
            return true;
          }
        }

        if (current == '<') {
          if (next == '<') {
            return true;
          }
        }

        return false;
      });

  bool _invalidPhraseOperator() => _forEachToken((last, current, next) {
        if (current == '<') {
          if (next != null && (int.tryParse(next) == null || next != '-')) {
            return true;
          }
        }

        return false;
      });

  bool _binaryPrecedingClosingParenthesis() =>
      _forEachToken((last, current, next) {
        if (_isBinaryOperator(current)) {
          if (_isClosingParenthesis(next!)) {
            return true;
          }
        }

        return false;
      });

  bool _openingParenthesisPrecedingBinary() =>
      _forEachToken((last, current, next) {
        if (_isBinaryOperator(current)) {
          if (_isOpeningParenthesis(last!)) {
            return true;
          }
        }

        return false;
      });

  bool _consecutiveBinary() => _forEachToken((last, current, next) {
        final operation = TextSearchOperation.fromStringToOperation(current);
        late final bool isBinary;

        if (operation == null) {
          isBinary = false;
        } else {
          isBinary = TextSearchOperation.isBinaryOperator(operation);
        }

        if (isBinary) {
          final split = current.split('');

          if (split.length > 1) {
            if (_isBinaryOperator(split.last)) {
              return true;
            }
          }

          if (_hasConsecutiveMatches(current, operation!.toOperatorRegex())) {
            return true;
          }

          final matchLength =
              _firstMatchLength(current, operation.toOperatorRegex());

          if (matchLength < current.length) {
            return true;
          }
        }

        return false;
      });

  bool _binaryWithInvalidOperand() => _forEachToken((last, current, next) {
        if (_isBinaryOperator(current)) {
          final isLastValid = _isOperand(last!) ||
              _isClosingParenthesis(last) ||
              _isPrefixOperator(last);
          final isNextValid = _isUnaryOperator(next!) ||
              _isOperand(next) ||
              _isOpeningParenthesis(next);

          if (!isLastValid || !isNextValid) {
            return true;
          }
        }

        return false;
      });

  bool _consecutiveOperands() => _forEachToken((last, current, next) {
        if (_isOperand(current)) {
          if (next != null && _isOperand(next)) {
            return true;
          }
        }

        return false;
      });

  bool _invalidPrefixOperator() => _forEachToken((last, current, next) {
        if (current.contains(':')) {
          if (RegExp(r'[^:*abcd]').hasMatch(current)) {
            return true;
          }

          if (current == ':') {
            return true;
          }

          if (next != null && _isOperand(next)) {
            return true;
          }

          if (last != null) {
            if (_isBinaryOperator(last) ||
                _isUnaryOperator(last) ||
                _isOpeningParenthesis(last) ||
                _isClosingParenthesis(last)) {
              return true;
            }
          }
        }

        return false;
      });

  bool _areParenthesesUnbalanced() {
    final List<String> parenthesisStack = [];

    for (int i = 0; i < _tokens.length; i++) {
      final current = _tokens[i];
      final (startRange, endRange) = _getNextAndLastIndex(i);
      _setErrorRange(startRange, endRange);

      if (current == '(') {
        parenthesisStack.add(current);
      }

      if (current == ')') {
        if (parenthesisStack.isEmpty) {
          return true;
        }
        parenthesisStack.removeLast();
      }
    }

    return parenthesisStack.isNotEmpty;
  }

  bool _isOperand(String token) =>
      !_isBinaryOperator(token) &&
      !_isUnaryOperator(token) &&
      !_isPrefixOperator(token) &&
      !_isOpeningParenthesis(token) &&
      !_isClosingParenthesis(token);

  bool _isBinaryOperator(String token) =>
      TextSearchOperation.isStringBinaryOperator(token);

  bool _isUnaryOperator(String token) =>
      TextSearchOperation.isStringUnaryOperator(token);

  bool _isPrefixOperator(String token) =>
      TextSearchOperation.isStringPrefixOperator(token);

  bool _isOpeningParenthesis(String token) =>
      TextSearchOperation.isStringSubExpression(token);

  bool _isClosingParenthesis(String token) => token == ')';

  bool _forEachToken(
    bool Function(
      String? last,
      String current,
      String? next,
    ) func,
  ) {
    for (int i = 0; i < _tokens.length; i++) {
      final current = _tokens[i];
      final (last, next) = _getLastAndNextString(i);
      final (startRange, endRange) = _getNextAndLastIndex(i);

      final result = func(last, current, next);

      if (result == true) {
        _setErrorRange(startRange, endRange);
        return result;
      }
    }

    return false;
  }

  bool _isInvalidProximity() => _forEachToken((last, current, next) {
        if (current == '<->') {
          return false;
        }
        if (current.startsWith('<') || current.endsWith('>')) {
          final chars = current.split('');
          if (!chars.contains('<') || !chars.contains('>')) {
            return true;
          }

          final start = chars.indexOf('<');
          final end = chars.indexOf('>');

          final sublist = chars.sublist(start + 1, end);

          if (sublist.isEmpty) {
            return true;
          }

          final intCast = int.tryParse(sublist.join(''));

          if (intCast == null) {
            return true;
          }
        }
        return false;
      });

  bool _hasConsecutiveMatches(String input, RegExp regex) {
    final matches = regex.allMatches(input);

    RegExpMatch? previousMatch;
    for (RegExpMatch match in matches) {
      if (previousMatch != null && (previousMatch.end == match.start)) {
        return true;
      }
      previousMatch = match;
    }

    return false;
  }

  int _firstMatchLength(String input, RegExp regex) {
    final match = regex.firstMatch(input);

    if (match != null) {
      return match.end - match.start;
    } else {
      return 0;
    }
  }

  (String?, String?) _getLastAndNextString(int current) {
    final last = current > 0 ? _tokens[current - 1] : null;
    final next = current < (_tokens.length - 1) ? _tokens[current + 1] : null;

    return (last, next);
  }

  (int, int) _getNextAndLastIndex(int current) {
    final (last, next) = _getLastAndNextString(current);

    final startRange = last == null ? current : current - 1;
    final endRange = next == null ? current : current + 1;

    return (startRange, endRange);
  }

  void _setErrorRange(int start, int end) {
    _start = start;
    _end = end;
  }

  String _getErrorRange() => _tokens.sublist(_start, _end + 1).join(' ');
}

class TokenValidationResult {
  final bool isValid;
  final String? message;

  const TokenValidationResult({required this.isValid, this.message});
}
