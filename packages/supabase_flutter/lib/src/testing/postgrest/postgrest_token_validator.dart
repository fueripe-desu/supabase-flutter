import 'package:supabase_flutter/src/testing/postgrest/postgrest_tokens.dart';

class PostrestValueTokenValidator {
  final List<PostrestValueToken> _tokens = [];

  PostrestValidationResult validate(List<PostrestValueToken> tokens) {
    _tokens.addAll(tokens);

    if (_invalidFirstToken()) {
      return const PostrestValidationResult(
        isValid: false,
        message: 'First token is invalid.',
      );
    }

    if (_invalidLastToken()) {
      return const PostrestValidationResult(
        isValid: false,
        message: 'Last token is invalid.',
      );
    }

    if (_consecutiveCommas()) {
      return const PostrestValidationResult(
        isValid: false,
        message: 'Consecutive commas found.',
      );
    }

    if (_unclosedComplexType()) {
      return const PostrestValidationResult(
        isValid: false,
        message: 'Unclosed complex type found.',
      );
    }

    if (_trailingComma()) {
      return const PostrestValidationResult(
        isValid: false,
        message: 'Trailing comma found.',
      );
    }

    return const PostrestValidationResult(isValid: true);
  }

  bool _invalidFirstToken() =>
      _tokens.first is! ValueToken && _tokens.first is! StartToken;

  bool _invalidLastToken() =>
      _tokens.last is! ValueToken && _tokens.last is! EndToken;

  bool _consecutiveCommas() {
    final List<PostrestValueToken> operators = [];

    for (PostrestValueToken token in _tokens) {
      if (token is SeparatorToken) {
        if (operators.last is SeparatorToken) {
          return true;
        }
      }

      operators.add(token);
    }

    return false;
  }

  bool _unclosedComplexType() {
    final List<PostrestValueToken> operators = [];

    for (PostrestValueToken token in _tokens) {
      if (token is StartToken) {
        operators.add(token);
      }

      if (token is EndToken) {
        if (operators.isEmpty) {
          return true;
        } else {
          operators.removeLast();
        }
      }
    }

    if (operators.isNotEmpty) {
      return true;
    }

    return false;
  }

  bool _trailingComma() {
    final List<PostrestValueToken> operators = [];

    for (PostrestValueToken token in _tokens) {
      if (token is SeparatorToken) {
        if (operators.last is StartToken) {
          return true;
        }
      }

      if (token is EndToken) {
        if (operators.last is SeparatorToken) {
          return true;
        }
      }

      operators.add(token);
    }
    return false;
  }
}

class PostrestExpTokenValidator {
  final List<PostrestExpToken> _tokens = [];
  PostrestExpToken? _errorToken;

  PostrestValidationResult validate(List<PostrestExpToken> tokens) {
    _clearCache();
    _tokens.addAll(tokens);

    if (_hasNullColumnName()) {
      return PostrestValidationResult(
        isValid: false,
        message: 'Null column name: $_errorToken',
      );
    }

    if (_hasNullFilterName()) {
      return PostrestValidationResult(
        isValid: false,
        message: 'Null filter name: $_errorToken',
      );
    }

    if (_hasNullValue()) {
      return PostrestValidationResult(
        isValid: false,
        message: 'Null value: $_errorToken',
      );
    }

    if (_invalidColumnName()) {
      return PostrestValidationResult(
        isValid: false,
        message: 'Invalid column name: $_errorToken',
      );
    }

    if (_invalidFilterName()) {
      return PostrestValidationResult(
        isValid: false,
        message: 'Invalid filter name: $_errorToken',
      );
    }

    if (_unbalancedLogicalScope()) {
      return const PostrestValidationResult(
        isValid: false,
        message: 'Unbalanced parentheses from logical operator.',
      );
    }

    return const PostrestValidationResult(isValid: true);
  }

  bool _hasNullColumnName() {
    return _forEachFilter((column, filter, value) {
      if (column == null) {
        return true;
      }

      return false;
    });
  }

  bool _hasNullFilterName() {
    return _forEachFilter((column, filter, value) {
      if (filter == null) {
        return true;
      }

      return false;
    });
  }

  bool _hasNullValue() {
    return _forEachFilter((column, filter, value) {
      if (value == null) {
        return true;
      }

      return false;
    });
  }

  bool _invalidColumnName() {
    return _forEachFilter((column, filter, value) {
      if (!_isColumnNameValid(column!)) {
        return true;
      }

      return false;
    });
  }

  bool _invalidFilterName() {
    return _forEachFilter((column, filter, value) {
      if (!_isFilterNameValid(filter!)) {
        return true;
      }

      return false;
    });
  }

  bool _unbalancedLogicalScope() {
    final List<bool> logicalStartStack = [];

    for (final token in _tokens) {
      if (token is LogicalStart) {
        logicalStartStack.add(true);
      } else if (token is LogicalEnd) {
        if (logicalStartStack.isEmpty) {
          return true;
        }

        logicalStartStack.removeLast();
      }
    }

    if (logicalStartStack.isNotEmpty) {
      return true;
    }

    return false;
  }

  bool _forEachFilter(
    bool Function(String? column, String? filter, String? value) filterFunc,
  ) {
    for (final token in _tokens) {
      if (token is PostrestFilterParams) {
        final result = filterFunc(token.column, token.filter, token.value);

        if (result) {
          _errorToken = token;
          return true;
        }
      }
    }

    return false;
  }

  bool _isColumnNameValid(String value) {
    final firstCharValid = RegExp(r'^[A-Za-z_]$').hasMatch(value[0]);
    final hasInvalidChars = RegExp(r'[^A-Za-z0-9_]+').hasMatch(value);

    if (!firstCharValid || hasInvalidChars) {
      return false;
    }

    return true;
  }

  bool _isFilterNameValid(String value) {
    final hasInvalidChars = RegExp(r'[^A-Za-z]+').hasMatch(value);

    if (hasInvalidChars) {
      return false;
    }

    return true;
  }

  void _clearCache() {
    _tokens.clear();
    _errorToken = null;
  }
}

class PostrestValidationResult {
  final bool isValid;
  final String? message;

  const PostrestValidationResult({required this.isValid, this.message});
}
